extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	var day_features = [
		# freezing, raining, foggy, sunny
		[0, 1, 0, 0],
		[0, 0, 0, 1],
		[0, 0, 0, 0],
		[0, 0, 1, 0],
		[1, 0, 0, 1],
		[1, 1, 0, 0],
		[1, 0, 1, 0],
	]
	var day_activities = [
		"lift_weights",
		"run",
		"run",
		"run",
		"lift_weights",
		"lift_weights",
		"lift_weights",
		"lift_weights",
	]
	var dt = DecisionTree.new()
	dt.train(day_features, day_activities)
	print_debug(dt.predict_with_probability([0, 0, 0, 0]))
	
	print("Training model")
	var model = $VRMRemapper.train(10)
	#print($VRMRemapper.remap($VRMRemapper/AJ/skeleton, $VRMRemapper/BigVegas/skeleton))
	print("Trained")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
