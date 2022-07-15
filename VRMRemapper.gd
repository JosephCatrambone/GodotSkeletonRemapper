extends Node

func train():
	var bone_descriptors = Dictionary()  # name -> list of list of features
	# Ring finger -> [all the different bones we've seen that also ring fingers]
	
	for child in self.get_children():
		var skeleton = child.get_node("skeleton")
		if skeleton == null:
			print(child.name)
			print("MISSING SKELETON!  X HAS NO BONES!")
			continue
		var skeleton_properties = make_features_for_skeleton(skeleton)
		for name in skeleton_properties.keys():
			if not bone_descriptors.has(name):
				bone_descriptors[name] = []
			bone_descriptors[name].append(skeleton_properties[name])

	# DEBUG: Save a CSV of this data:
	var f = File.new()
	f.open("user://file.csv", File.WRITE_READ)

	# Build all possible pairs of bones.
	# [[bone_properties_a, bone_properties_b, 1/0], ...]
	var examples:Array = []
	var labels:Array = []
	var first : bool = true
	for bone_name_a in bone_descriptors.keys():
		for bone_array_a in bone_descriptors[bone_name_a]:
			for bone_name_b in bone_descriptors.keys():
				for bone_array_b in bone_descriptors[bone_name_b]:
					var feature_vector = []
					feature_vector.append_array(bone_array_a)
					feature_vector.append_array(bone_array_b)
					examples.append(feature_vector)
					labels.append(bone_name_a == bone_name_b)
					var header : PackedStringArray
					if first:
						header.push_back("label")
						header.push_back("vector")
						f.store_csv_line(header, "\t")
						first = false
					var line : PackedStringArray
					line.push_back(str(bone_name_a == bone_name_b))
					var feature_string : String = ""
					for feature in feature_vector:
						feature_string = feature_string + str(feature) + " "
					line.push_back(feature_string)
					f.store_csv_line(line, "\t")
	
	# Train our model.
	var dt = DecisionTree.new()
	dt.train(examples, labels, 15)
	print(dt.save_to_json())
	return dt

func compute_bone_depth_and_child_count(skeleton:Skeleton3D, bone_id:int, skeleton_info:Dictionary):
	# Mutates the given skeleton_info_dictionary
	# Sets a mapping from bone_id to {"children": count, "depth": int, "siblings": int}
	
	# Assume that our skeleton always has at least one bone.
	assert(skeleton.get_bone_count() > 0)
	
	# Initialize our dictionary entry.
	if not skeleton_info.has(bone_id):
		skeleton_info[bone_id] = {
			"children": 0,  # Fill in here.
			"depth": 0,  # Don't worry about depth for this node.  It will be assigned by the parent.
			"siblings": 0,  # Let parent fill this in.
		}
	
	# TODO: Handle multiple roots of the skeleton?
	var parent_id: int = skeleton.get_bone_parent(bone_id)
	if parent_id == -1:
		skeleton_info[bone_id]["depth"] = 0
	# NOTE: Godot has no way to get the children of a bone via function call, so we iterate over and check the nodes which have this as a parent.
	var child_bone_ids: Array[int] = []
	for child_bone_id in range(0, skeleton.get_bone_count()):
		if skeleton.get_bone_parent(child_bone_id) == bone_id:
			child_bone_ids.append(child_bone_id)
	
	skeleton_info[bone_id]["children"] = len(child_bone_ids)
	for child_id in child_bone_ids:
		if not skeleton_info.has(child_id):  # Don't override if set.
			skeleton_info[child_id] = {
				"children": 0,
				"depth": skeleton_info[bone_id]["depth"] + 1,
				"siblings": len(child_bone_ids)
			}
		compute_bone_depth_and_child_count(skeleton, child_id, skeleton_info)
	
	return skeleton_info

func make_features_for_skeleton(skeleton:Skeleton3D) -> Dictionary:
	# Return a mapping from BONE NAME to a feature array.
	var result = {}
	
	var bone_count = skeleton.get_bone_count()
	
	# For each bone, if it's a root node, compute the properties it needs.
	var bone_depth_info = Dictionary()
	for bone_id in range(0, skeleton.get_bone_count()):
		if skeleton.get_bone_parent(bone_id) == -1:  # If this is a root bone...
			compute_bone_depth_and_child_count(skeleton, bone_id, bone_depth_info)

	# Start by finding the depth of every bone.
	for bone_id in skeleton.get_bone_count():
		var pose:Transform3D = skeleton.get_bone_rest(bone_id)  # get_global_pose?
		result[skeleton.get_bone_name(bone_id)] = [
			# Position
			pose.origin.x, pose.origin.y, pose.origin.z, 
			# Rotation
			pose.basis.x.x, pose.basis.x.y, pose.basis.x.z,
			pose.basis.y.x, pose.basis.y.y, pose.basis.y.z,
			pose.basis.z.x, pose.basis.z.y, pose.basis.z.z,
			# Scale?
			# Hierarchy info -- TODO: Normalize
			float(bone_depth_info[bone_id]["depth"]) / float(bone_count),
			float(bone_depth_info[bone_id]["children"]) / float(bone_count),
			float(bone_depth_info[bone_id]["siblings"]) / float(bone_count), 
			# Wish I could do stuff with names.  :'(
		]
	return result
