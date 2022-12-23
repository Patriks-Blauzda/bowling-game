extends Node

# Saves the scores in each frame in individual arrays
var scoring = []

# Saves scores for current scene
var current_scene = []

# Stores upright pins in current scene
var active_pins = []

# Returns the sum of each frame
func get_total_score():
	var sum = 0
	for frame in scoring:
		for shot in frame:
			sum += shot
	
	return sum


# Basic scoring, planned to be expanded later
func add_points():
	var status = get_tree().root.get_child(1).get_node("Pins").check_pins()
	var score = 0
	
	for i in range(status.size()):
		if active_pins[i]:
			score += int(not status[i])
	
	current_scene.append(score)
	if score == 10 || current_scene.size() > 1:
		add_scene()
		return true
	else:
		return false


# Append current scene results to score sheet
func add_scene():
	scoring.append(current_scene)
	
	print(current_scene)
	
	current_scene.clear()
