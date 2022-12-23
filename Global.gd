extends Node

var game_finished = false

# Saves the scores in each frame in individual arrays
var scoring = [ [] ]

# Saves index for current scene
var scene_index = 0

# Stores upright pins in current scene
var active_pins = []

# Returns the sum of each frame
func get_total_score():
	var sum = 0
	for frame in scoring:
		for shot in frame:
			sum += shot
	
	return sum


# Checks whether the current scene is empty
func is_scene_empty():
	return scoring[scene_index].empty()


# Basic scoring, planned to be expanded later
func add_points():
	var status = get_tree().root.get_child(1).get_node("Pins").check_pins()
	var score = 0
	
	for i in range(status.size()):
		if active_pins[i]:
			score += int(not status[i])
	
	scoring[scene_index].append(score)
	if score == 10 || scoring[scene_index].size() > 1:
		finish_scene()
		return true
		pass
	else:
		return false


# Append current scene results to score sheet
func finish_scene():
	scoring.append([])
	
	scene_index += 1
	
	if scoring.size() >= 10:
		game_finished = true


func reset_game():
	scoring = [ [] ]
	scene_index = 0
	var _reload = get_tree().reload_current_scene()
