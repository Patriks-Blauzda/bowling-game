extends Node

var game_finished = false

# Saves the scores in each frame in individual arrays
var scoring = [ [] ]
# Saves the total score of each frame
var summed_score = []

# Saves index for current scene
var scene_index = 0

# Stores upright pins in current scene
var active_pins = []

# Returns the sum of each frame
func get_total_score():
	var sum = 0
	for frame in summed_score:
		sum += frame
	
	return sum


# Checks whether the current scene is empty, or if strike on last frame
func is_scene_empty():
	if scene_index > 8 && !scoring[scene_index].empty():
		if scoring[scene_index][scoring[scene_index].size() - 1] == 10:
			return true
	
	return scoring[scene_index].empty()


# Scoring system, accounts for strikes and spares
func add_points():
	var status = get_tree().root.get_child(1).get_node("Pins").check_pins()
	var score = 0
	
	for i in range(status.size()):
		if active_pins[i]:
			score += int(not status[i])
	
	
	# If strike/par on previous frames, append score there
	for index in range(scene_index - 2, scene_index):
		if index > -1:
			
			if summed_score[index] >= 10:
				
				match scene_index - index:
					1:
						if scoring[scene_index].size() < 1 || (scoring[index].size() == 1 && scoring[scene_index].size() < 2):
								summed_score[index] += score
					2:
						if scoring[index + 1].size() < 2 && scoring[scene_index].size() == 0:
							if scoring[index].size() == 1:
									summed_score[index] += score
	
	
	scoring[scene_index].append(score)
	if scene_index < 9:
		if score == 10 || scoring[scene_index].size() > 1 :
				finish_scene()
	
	# Handles final scene scoring
	else:
		if scoring[scene_index].size() > 1:
			
			if scoring[scene_index][0] == 10 && scoring[scene_index].size() > 2:
				finish_scene()
				
			elif scoring[scene_index][0] != 10:
				finish_scene()


# Append current scene results to score sheet
func finish_scene():
	scoring.append([])
	
	var sum = 0
	for score in scoring[scene_index]:
		sum += score
	summed_score.append(sum)
	
	scene_index += 1
	
	if scoring.size() > 10:
		game_finished = true


# Restarts the game and empties own variables, so that none carry over to the new game
func reset_game():
	scoring = [ [] ]
	summed_score.clear()
	scene_index = 0
	var _reload = get_tree().reload_current_scene()
