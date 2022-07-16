extends Node

var dt

func _ready():
	# If we happen to have a decision tree
	self.dt = DecisionTree.new()
	#self.dt.load_from_json('{"feature":15,"impurity_index":0.0236875651181344,"label_confidence":{"false":0.987965350790187,"true":0.0120346492098129},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":15,"impurity_index":0.0309820613344067,"label_confidence":{"false":0.98414023978447,"true":0.0158597602155301},"left":{"feature":16,"impurity_index":0.0452308916318722,"label_confidence":{"false":0.976750622751176,"true":0.0232493772488237},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":12,"impurity_index":0.052315877385581,"label_confidence":{"false":0.972733401583061,"true":0.0272665984169393},"left":{"feature":12,"impurity_index":0.0858497646441323,"label_confidence":{"false":0.9536,"true":0.0464},"left":{"feature":13,"impurity_index":0.00708613143289802,"label_confidence":{"false":0.996419834118981,"true":0.00358016588101915},"left":null,"right":null,"threshold":0},"right":{"feature":12,"impurity_index":0.136741848687389,"label_confidence":{"false":0.922722774407297,"true":0.0772772255927025},"left":null,"right":null,"threshold":-0.01470588235294},"threshold":-0.04576329417006},"right":{"feature":12,"impurity_index":0.016091077861244,"label_confidence":{"false":0.991820040899795,"true":0.0081799591002045},"left":{"feature":12,"impurity_index":0.0320572526627321,"label_confidence":{"false":0.983567134268537,"true":0.0164328657314629},"left":null,"right":null,"threshold":0.0340336134453781},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0629713423831071},"threshold":0.0128205128205128},"threshold":0},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.317841504062974},"threshold":0}')

func remap(source_skeleton:Skeleton3D, sink_skeleton:Skeleton3D) -> Dictionary:
	# Returns a mapping from bone_id in source skeleton to bone_id in target_skeleton.
	var mapping = Dictionary()
	var source_skeleton_features = self.make_features_for_skeleton(source_skeleton)
	var target_skeleton_features = self.make_features_for_skeleton(sink_skeleton)
	
	# Probability table.
	var probability_match:Dictionary = Dictionary()  # Map from the target/sink bone id to the most likely sources.
	for target_bone_id in range(0, sink_skeleton.get_bone_count()):
		var target_feature = target_skeleton_features[target_bone_id]
		probability_match[target_bone_id] = Dictionary()
		for source_bone_id in range(0, source_skeleton.get_bone_count()):
			var source_feature = source_skeleton_features[source_bone_id]
			var feature = []
			for feature_index in range(0, len(source_feature)):
				feature.append(source_feature[feature_index] - target_feature[feature_index])
			# DT is trained to map to labels 'true' and 'false'.
			probability_match[target_bone_id][source_bone_id] = dt.predict_with_probability(feature)[true]
	
	# Assign from root outwards.  Use the maximum probability match.
	# This does not maximize the overall probability, but puts greater priority on root bones.
	var used_bones = Dictionary()  # TODO: Make sure we don't double assign bones!
	# Start by finding all the potential unparented bones in the sink skeleton because those will be roots.
	var next_bones_to_assign = Array(sink_skeleton.get_parentless_bones())
	while len(next_bones_to_assign) > 0:
		var current_bone = next_bones_to_assign.pop_front()
		var child_bones = sink_skeleton.get_bone_children(current_bone)
		next_bones_to_assign.append_array(Array(child_bones))
		# Need to actually map the bones now.
		var best_match_id = -1
		var best_match_value = -1
		for potential_match_bone_id in range(0, source_skeleton.get_bone_count()):
			if probability_match[current_bone][potential_match_bone_id] > best_match_value:
				best_match_value = probability_match[current_bone][potential_match_bone_id]
				best_match_id = potential_match_bone_id
		mapping[best_match_id] = current_bone
	
	return mapping

func train(fraction_of_data_for_validation:int = 0):
	# If fraction_of_data_for_validation is less than two, then we reuse the train data as validation data.
	
	# Given a skeleton, take all the bones and add the properties of each into a huge pile
	# "index_finger_left" will have an array of ARRAYS of the features for similar bones.
	# Ring finger -> [all the different bones we've seen that also ring fingers]
	var bone_descriptors = Dictionary()
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
	#var f = File.new()
	#f.open("user://file.csv", File.WRITE_READ)

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
					for i in range(0, len(bone_array_a)):
						feature_vector.append(bone_array_a[i] - bone_array_b[i])
					examples.append(feature_vector)
					labels.append(bone_name_a == bone_name_b)
					
					# DEBUG:
					"""
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
					"""
	
	# Shuffle examples and split into n sets.
	var train_examples = []
	var train_labels = []
	var validation_examples = []
	var validation_labels = []
	var validation_set_size = len(examples) / fraction_of_data_for_validation
	shuffle_data_in_place(examples, labels)
	if fraction_of_data_for_validation > 1:
		validation_examples = examples.slice(-validation_set_size)
		validation_labels = labels.slice(-validation_set_size)
		train_examples = examples.slice(0, -validation_set_size)
		train_labels = labels.slice(0, -validation_set_size)
	else:
		train_examples = examples
		train_labels = labels
		validation_examples = examples
		validation_labels = labels
	
	# Train our model.
	self.dt = DecisionTree.new()
	self.dt.train(train_examples, train_labels, 5)
	print(dt.save_to_json())
	
	# Search for hyperparameter on validation data.
	var best_score = 0
	var best_threshold = 0
	for threshold in range(0, 100):
		var result = dt.evaluate(validation_examples, validation_labels, threshold/100.0)
		var score = result["tp"]*10.0 + result["tn"]*0.1 - result["fp"]*5.0
		if score > best_score:
			best_score = score
			best_threshold = threshold
	print("Best threshold: ", best_threshold)
	print("Best score: ", best_score)
	
	return dt

func shuffle_data_in_place(examples: Array, labels: Array):
	for idx in range(len(examples)-1, 2, -1):
		var swap_index = randi_range(0, idx-1)
		var temp = examples[idx]
		examples[idx] = examples[swap_index]
		examples[swap_index] = temp
		temp = labels[idx]
		labels[idx] = labels[swap_index]
		labels[swap_index] = temp

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
		var pose:Transform3D = skeleton.global_pose_to_world_transform(skeleton.get_bone_global_pose(bone_id))  # get_global_rest_pose?
		# Do some extra name properties:
		var string_prop_name_left:float = 0.0
		var string_prop_name_right:float = 0.0
		if skeleton.get_bone_name(bone_id).to_lower().contains("left"):
			string_prop_name_left = 1.0
		if skeleton.get_bone_name(bone_id).to_lower().contains("right"):
			string_prop_name_right = 1.0
		# Build vec:
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
			#string_prop_name_left,
			#string_prop_name_right,
		]
	return result
