class_name DecisionTree
	
var left
var right
var label_confidence: Dictionary  # label_type -> float
var feature: int  # The index of the feature used to decide on left or right.
var threshold: float  # If the value is less than this, go left.
var impurity_index: float  # Used during training.

func predict(sample: Array):
	var probabilities = self.predict_with_probability(sample)
	var best_conf = 0.0
	var prediction = null
	for label_name in probabilities:
		# Find the max label confidence.
		if probabilities[label_name] > best_conf:
			best_conf = probabilities[label_name]
			prediction = label_name
	return prediction

func predict_with_probability(sample: Array) -> Dictionary:
	if self.left == null or self.right == null:
		return self.label_confidence
	elif sample[self.feature] < self.threshold:
		return self.left.predict_with_probability(sample)
	else:  # Has to be.
		return self.right.predict_with_probability(sample)

func as_dict() -> Dictionary:
	var self_dict = {
		"label_confidence": self.label_confidence,
		"feature": self.feature,
		"threshold": self.threshold,
		"impurity_index": self.impurity_index,
		"left": null,
		"right": null,
	}
	if self.left != null:
		self_dict["left"] = left.as_dict()
	if self.right != null:
		self_dict["right"] = right.as_dict()
	return self_dict

func save_to_json() -> String:
	var self_dict = self.as_dict()
	var json :JSON = JSON.new()
	return json.stringify(self_dict)

func load_from_json(json_string:String):
	var json :JSON = JSON.new()
	json.parse(json_string)
	var parsed : Dictionary = json.get_data() 
	self.label_confidence = parsed["label_confidence"]
	self.feature = parsed["feature"]
	self.threshold = parsed["threshold"]
	self.impurity_index = parsed["impurity_index"]
	if parsed["left"] != null:
		#self.left = get_script().new()
		#self.left.load_from_json(parsed["left"])
		self.left = parsed["left"]
	if parsed["right"] != null:
		#self.right = get_script().new()
		#self.right.load_from_json(parsed["right"])
		self.right = parsed["right"]

func _compute_median(values_list:Array) -> float:
	# Find the best threshold for this column.
	values_list.sort()
	var count_items_on_left:int = 0
	var threshold_value:float = values_list[0]
	var items_in_column = len(values_list)
	# TODO: Actually compute median.
	var median = values_list[int(round(items_in_column/2))]
	return median

func _compute_mean(values_list:Array) -> float:
	var accumulator = 0.0
	for entry in values_list:
		accumulator += entry
	return accumulator / float(len(values_list))

func train(samples: Array, labels: Array, max_depth:int = -1, max_impurity:float = 1.0):
	# Generates a decision tree node or None.
	# Samples should be an array of arrays.
	# Labels should be an array of strings or classes.
	# max_depth should be the maximum depth OR -1 for unlimited.
	
	# Find the impurity of this category so we can maximize information gain.
	var probability_by_category = _probability_by_category(labels)
	var num_categories:int = len(probability_by_category)
	self.label_confidence = probability_by_category
	
	# Special case where everything is the same.
	# Don't bother to split because we can't get better.
	if num_categories < 2:
		return self
	
	# Find the best feature to use for a split.
	var best_split_column:int = 0
	var best_split_value:float = 0.0
	var lowest_impurity_index:float = 100000.0
	for candidate_column in range(0, len(samples[0])):
		var column_values = []
		for idx in range(0, len(samples)):
			column_values.append(samples[idx][candidate_column])
		var split_values = [
			_compute_median(column_values),
			_compute_mean(column_values),
		]
		for split_value in split_values:
			# Try splitting on this candidate column.
			# For now, assume that this column is a boolean.
			var left_candidate_labels = []
			var right_candidate_labels = []
			for idx in range(0, len(samples)):
				if samples[idx][candidate_column] < split_value:
					left_candidate_labels.append(labels[idx])
				else:
					right_candidate_labels.append(labels[idx])
			var left_impurity_index = 1.0 - _calculate_gini_impurity(left_candidate_labels)
			var right_impurity_index = 1.0 - _calculate_gini_impurity(right_candidate_labels)
			var weighted_impurity_index = (float(len(left_candidate_labels))/float(len(labels))*left_impurity_index + float(len(right_candidate_labels))/float(len(labels))*right_impurity_index)
			if weighted_impurity_index < lowest_impurity_index:
				lowest_impurity_index = weighted_impurity_index
				best_split_column = candidate_column
				best_split_value = split_value
	
	# Create the decision tree.
	self.feature = best_split_column
	self.threshold = best_split_value
	self.impurity_index = lowest_impurity_index
	
	if max_depth == 0 or self.impurity_index < 1e-6:# or decision_tree.impurity_index > max_impurity:  # Again, ==0, not <0 or != 0.
		return self  # If we are stopping OR we gain nothing by splitting, return only ourselves.
	
	# If the lowest impurity index is LESS than our impurity index, we don't want to add them.
	var left_samples:Array = []
	var left_labels:Array = []
	var right_samples:Array = []
	var right_labels:Array = []
	for idx in range(0, len(samples)):
		if samples[idx][self.feature] < self.threshold:
			left_samples.append(samples[idx])
			left_labels.append(labels[idx])
		else:
			right_samples.append(samples[idx])
			right_labels.append(labels[idx])
		# Try and train
	var left_candidate = get_script().new()
	left_candidate.train(left_samples, left_labels, max_depth-1, self.impurity_index)
	self.left = left_candidate
	var right_candidate = get_script().new()
	right_candidate.train(right_samples, right_labels, max_depth-1, self.impurity_index)
	self.right = right_candidate
	return self


func _probability_by_category(labels: Array):
	# Takes an array of labels and spits out the probability of a given category via counting.
	var count_by_category:Dictionary = {}
	var count = 0.0
	for label in labels:
		if not count_by_category.has(label):
			count_by_category[label] = 0
		count_by_category[label] += 1
		count += 1.0
	
	var probability_by_category:Dictionary = {}
	for category in count_by_category:
		probability_by_category[category] = float(count_by_category[category])/float(count)
	
	return probability_by_category


func _probability_to_gini_impurity(probability_by_category:Dictionary) -> float:
	# Sum of the squares of probabilities.
	var gini_impurity = 0.0
	for category in probability_by_category:
		var probability = probability_by_category[category]
		gini_impurity += probability*probability
	return gini_impurity


func _calculate_gini_impurity(labels: Array) -> float:
	# A helper method which goes straight to gini impurity from the labels.
	# Gini impurity is the sum of the squares of the probability.
	# Gini impurity _index_ is 1-gini impurity.
	var p_by_category = _probability_by_category(labels)
	return _probability_to_gini_impurity(p_by_category)

func evaluate(examples: Array, labels: Array, threshold: float = 0.5) -> Dictionary:
	# Returns the error types TP/FP/TN/FN for the given batch of results.
	var results = {
		"tp": 0,
		"fp": 0,
		"tn": 0,
		"fn": 0,
	}
	
	for index in range(0, len(examples)):
		var predictions = self.predict_with_probability(examples[index])
		# predictions is {false: 0.1, true: 0.9}
		# label in {true, false}
		# prediction in {true, false}
		
		# Map from the bone prediction same==true to a probability:
		var prediction = false
		if predictions.has(true):
			prediction = predictions[true] > threshold
			
		# Evaluate as true/false postitive/negative.
		if prediction == true:
			if labels[index] == true:
				results["tp"] += 1
			else:
				results["fp"] += 1
		else: # prediction is false:
			if labels[index] == true:
				results["fn"] += 1
			else:
				results["tn"] += 1
		
	# Renormalize and makes the counts into percents.
	var num_examples = len(examples)
	results["tp"] /= float(num_examples)
	results["fp"] /= float(num_examples)
	results["tn"] /= float(num_examples)
	results["fn"] /= float(num_examples)
		
	return results
