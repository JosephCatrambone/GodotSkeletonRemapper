# MIT License
#
# Copyright (c) 2020 K. S. Ernest (iFire) Lee & V-Sekai
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# GDScript implementation of a modified version of the fortune algorthim.
# Thanks to iFire, Lyuma, and MMMaellon for the C++ implementation this version was based off, saved me
# a lot of headaches ;)
# https://github.com/godot-extended-libraries/godot-fire/commit/622022d2779f9d35b586db4ee31c9cb76d0b7bc7

@tool
extends EditorScenePostImportPlugin

const NO_BONE = -1
const VECTOR_DIRECTION = Vector3.UP

class RestBone extends RefCounted:
	var rest_local_before: Transform3D
	var rest_local_after: Transform3D
	var rest_delta: Quaternion
	var children_centroid_direction: Vector3
	var parent_index: int = NO_BONE
	var children: Array = []
	var override_direction: bool = true

static func _get_perpendicular_vector(p_v: Vector3) -> Vector3:
	var perpendicular: Vector3 = Vector3()
	if !is_zero_approx(p_v[0]) and !is_zero_approx(p_v[1]):
		perpendicular = Vector3(0, 0, 1).cross(p_v).normalized()
	else:
		perpendicular = Vector3(1, 0, 0)

	return perpendicular

static func _align_vectors(a: Vector3, b: Vector3) -> Quaternion:
	a = a.normalized()
	b = b.normalized()
	var angle: float = a.angle_to(b)
	if is_zero_approx(angle):
		return Quaternion()
	if !is_zero_approx(a.length_squared()) and !is_zero_approx(b.length_squared()):
		# Find the axis perpendicular to both vectors and rotate along it by the angular difference
		var perpendicular: Vector3 = a.cross(b).normalized()
		var angle_diff: float = a.angle_to(b)
		if is_zero_approx(perpendicular.length_squared()):
			perpendicular = _get_perpendicular_vector(a)
		return Quaternion(perpendicular, angle_diff)
	else:
		return Quaternion()

static func _fortune_with_chains(
	p_skeleton: Skeleton3D,
	r_rest_bones: Dictionary,
	p_fixed_chains: Array,
	p_ignore_unchained_bones: bool,
	p_ignore_chain_tips: Array,
	p_base_pose: Array) -> Dictionary:
	var bone_count: int = p_skeleton.get_bone_count()

	# First iterate through all the bones and create a RestBone for it with an empty centroid
	for j in range(0, bone_count):
		var rest_bone: RestBone = RestBone.new()

		rest_bone.parent_index = p_skeleton.get_bone_parent(j)
		rest_bone.rest_local_before = p_base_pose[j]
		rest_bone.rest_local_after = rest_bone.rest_local_before
		r_rest_bones[j] = rest_bone

	# Collect all bone chains into a hash table for optimisation
	var chain_hash_table: Dictionary = {}.duplicate()
	for chain in p_fixed_chains:
		for bone_id in chain:
			chain_hash_table[bone_id] = chain

	# We iterate through again, and add the child's position to the centroid of its parent.
	# These position are local to the parent which means (0, 0, 0) is right where the parent is.
	for i in range(0, bone_count):
		var parent_bone: int = p_skeleton.get_bone_parent(i)
		if (parent_bone >= 0):

			var apply_centroid = true

			var chain = chain_hash_table.get(parent_bone, null)
			if typeof(chain) == TYPE_PACKED_INT32_ARRAY:
				var index: int = NO_BONE
				for findind in range(len(chain)):
					if chain[findind] == parent_bone:
						index = findind
				if (index + 1) < chain.size():
					# Check if child bone is the next bone in the chain
					if chain[index + 1] == i:
						apply_centroid = true
					else:
						apply_centroid = false
				else:
					# If the bone is at the end of a chain, p_ignore_chain_tips argument determines
					# whether it should attempt to be corrected or not
					if p_ignore_chain_tips.has(chain):
						r_rest_bones[parent_bone].override_direction = false
						apply_centroid = false
					else:
						apply_centroid = true
			else:
				if p_ignore_unchained_bones:
					r_rest_bones[parent_bone].override_direction = false
					apply_centroid = false

			if apply_centroid:
				r_rest_bones[parent_bone].children_centroid_direction = r_rest_bones[parent_bone].children_centroid_direction + p_skeleton.get_bone_rest(i).origin
			r_rest_bones[parent_bone].children.append(i)


	# Point leaf bones to parent
	for i in range(0, bone_count):
		var leaf_bone: RestBone = r_rest_bones[i]
		if (leaf_bone.children.size() == 0):
			if p_ignore_unchained_bones and !chain_hash_table.get(i, null):
				r_rest_bones[i].override_direction = false
			leaf_bone.children_centroid_direction = r_rest_bones[leaf_bone.parent_index].children_centroid_direction

	# We iterate again to point each bone to the centroid
	# When we rotate a bone, we also have to move all of its children in the opposite direction
	for i in range(0, bone_count):
		if r_rest_bones[i].override_direction:
			r_rest_bones[i].rest_delta = _align_vectors(VECTOR_DIRECTION, r_rest_bones[i].children_centroid_direction)
			r_rest_bones[i].rest_local_after.basis = r_rest_bones[i].rest_local_after.basis * Basis(r_rest_bones[i].rest_delta)

			# Iterate through the children and rotate them in the opposite direction.
			for j in range(0, r_rest_bones[i].children.size()):
				var child_index: int = r_rest_bones[i].children[j]
				r_rest_bones[child_index].rest_local_after = Transform3D(r_rest_bones[i].rest_delta.inverse(), Vector3()) * r_rest_bones[child_index].rest_local_after

	return r_rest_bones

static func _fix_meshes(p_bind_fix_array: Array, p_mesh_instances: Array) -> void:
	print("bone_direction: _fix_meshes")

	for mi in p_mesh_instances:
		var skin: Skin = mi.get_skin();
		if skin == null:
			continue

		skin = skin.duplicate()
		mi.set_skin(skin)
		var skeleton_path: NodePath = mi.get_skeleton_path()
		var node: Node = mi.get_node_or_null(skeleton_path)
		var skeleton: Skeleton3D = node
		for bind_i in range(0, skin.get_bind_count()):
			var bone_index:int  = skin.get_bind_bone(bind_i)
			if (bone_index == NO_BONE):
				var bind_name: String = skin.get_bind_name(bind_i)
				if bind_name.is_empty():
					continue
				bone_index = skeleton.find_bone(bind_name)

			if (bone_index == NO_BONE):
				continue
			skin.set_bind_pose(bind_i, p_bind_fix_array[bone_index] * skin.get_bind_pose(bind_i))


static func find_mesh_instances_for_avatar_skeleton(p_node: Node, p_skeleton: Skeleton3D, p_valid_mesh_instances: Array) -> Array:
	if p_skeleton and p_node is MeshInstance3D:
		var skeleton: Node = p_node.get_node_or_null(p_node.skeleton)
		if skeleton == p_skeleton:
			p_valid_mesh_instances.push_back(p_node)

	for child in p_node.get_children():
		p_valid_mesh_instances = find_mesh_instances_for_avatar_skeleton(child, p_skeleton, p_valid_mesh_instances)

	return p_valid_mesh_instances


static func _refresh_skeleton(p_skeleton : Skeleton3D):
	p_skeleton.visible = not p_skeleton.visible
	p_skeleton.visible = not p_skeleton.visible


static func find_nodes_in_group(p_group: String, p_node: Node) -> Array:
	var valid_nodes: Array = Array()

	for group in p_node.get_groups():
		if p_group == group:
			valid_nodes.push_back(p_node)

	for child in p_node.get_children():
		var valid_child_nodes: Array = find_nodes_in_group(p_group, child)
		for valid_child_node in valid_child_nodes:
			valid_nodes.push_back(valid_child_node)

	return valid_nodes


static func get_full_bone_chain(p_skeleton: Skeleton3D, p_first: int, p_last: int) -> PackedInt32Array:
	var bone_chain: PackedInt32Array = get_bone_chain(p_skeleton, p_first, p_last)
	bone_chain.push_back(p_last)

	return bone_chain

static func get_bone_chain(p_skeleton: Skeleton3D, p_first: int, p_last: int) -> PackedInt32Array:
	var bone_chain: Array = []

	if p_first != NO_BONE and p_last != NO_BONE:
		var current_bone_index: int = p_last

		while 1:
			current_bone_index = p_skeleton.get_bone_parent(current_bone_index)
			bone_chain.push_front(current_bone_index)
			if current_bone_index == p_first:
				break
			elif current_bone_index == NO_BONE:
					return PackedInt32Array()

	return PackedInt32Array(bone_chain)


static func is_bone_parent_of(p_skeleton: Skeleton3D, p_parent_id: int, p_child_id: int) -> bool:
	var p: int = p_skeleton.get_bone_parent(p_child_id)
	while (p != NO_BONE):
		if (p == p_parent_id):
			return true
		p = p_skeleton.get_bone_parent(p)

	return false

static func is_bone_parent_of_or_self(p_skeleton: Skeleton3D, p_parent_id: int, p_child_id: int) -> bool:
	if p_parent_id == p_child_id:
		return true

	return is_bone_parent_of(p_skeleton, p_parent_id, p_child_id)


static func change_bone_rest(p_skeleton: Skeleton3D, bone_idx: int, bone_rest: Transform3D):
	var old_scale: Vector3 = p_skeleton.get_bone_pose_scale(bone_idx)
	var new_rotation: Quaternion = Quaternion(bone_rest.basis.orthonormalized())
	p_skeleton.set_bone_pose_position(bone_idx, bone_rest.origin)
	p_skeleton.set_bone_pose_scale(bone_idx, old_scale)
	p_skeleton.set_bone_pose_rotation(bone_idx, new_rotation)
	p_skeleton.set_bone_rest(bone_idx, Transform3D(
			Basis(new_rotation) * Basis(Vector3(1,0,0) * old_scale.x, Vector3(0,1,0) * old_scale.y, Vector3(0,0,1) * old_scale.z),
			bone_rest.origin))


static func fast_get_bone_global_pose(skel: Skeleton3D, bone_idx: int) -> Transform3D:
	var xform2: Transform3D = skel.get_bone_global_pose_override(bone_idx)
	if xform2 != Transform3D.IDENTITY: # this api is stupid.
		return xform2
	var transform: Transform3D = skel.get_bone_local_pose_override(bone_idx)
	if transform == Transform3D.IDENTITY: # another stupid api.
		transform = skel.get_bone_pose(bone_idx)
	var par_bone: int = skel.get_bone_parent(bone_idx)
	if par_bone == NO_BONE:
		return transform
	return fast_get_bone_global_pose(skel, par_bone) * transform


static func fast_get_bone_local_pose(skel: Skeleton3D, bone_idx: int) -> Transform3D:
	var transform: Transform3D = skel.get_bone_local_pose_override(bone_idx)
	if transform == Transform3D.IDENTITY: # another stupid api.
		transform = skel.get_bone_pose(bone_idx)
	return transform


static func get_fortune_with_chain_offsets(p_skeleton: Skeleton3D, p_base_pose: Array) -> Dictionary:
	var rest_bones: Dictionary = _fortune_with_chains(p_skeleton, {}.duplicate(), [], false, [], p_base_pose)

	var offsets: Dictionary = {"base_pose_offsets":[], "bind_pose_offsets":[]}

	for key in rest_bones.keys():
		offsets["base_pose_offsets"].append(rest_bones[key].rest_local_before.inverse() * rest_bones[key].rest_local_after)
		offsets["bind_pose_offsets"].append(Transform3D(rest_bones[key].rest_delta.inverse()))

	return offsets

static func fix_skeleton(p_root: Node, p_skeleton: Skeleton3D) -> void:
	print("bone_direction: fix_skeleton")

	var base_pose: Array = []
	for i in range(0, p_skeleton.get_bone_count()):
		base_pose.append(p_skeleton.get_bone_rest(i))

	var offsets: Dictionary = get_fortune_with_chain_offsets(p_skeleton, base_pose)
	for i in range(0, offsets["base_pose_offsets"].size()):
		var final_pose: Transform3D = p_skeleton.get_bone_rest(i) * offsets["base_pose_offsets"][i]
		change_bone_rest(p_skeleton, i, final_pose)
	# Correct the bind poses
	var mesh_instances: Array = find_mesh_instances_for_avatar_skeleton(p_root, p_skeleton, [])
	_fix_meshes(offsets["bind_pose_offsets"], mesh_instances)


func _post_process(scene: Node) -> void:
	var queue : Array
	queue.push_back(scene)
	var string_builder : Array
	while not queue.is_empty():
		var front = queue.front()
		var node = front
		if node is Skeleton3D:
			fix_skeleton(scene, node)
			_refresh_skeleton(node)
		var child_count : int = node.get_child_count()
		for i in child_count:
			queue.push_back(node.get_child(i))
		queue.pop_front()
	return scene

