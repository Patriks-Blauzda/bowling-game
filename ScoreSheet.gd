extends Panel

# Empties the score sheet
func clear_display():
	for frame in get_node("GridContainer").get_children():
		frame.text = ""


func _ready():
	clear_display()


# Displays current score per frame and total score, as well as adjusts buttons based on game state
func display_scores():
	$Next.visible = not Global.game_finished
	
	var scores = Global.scoring
	for i in range(scores.size()):
		if i < 10:
			var frame = get_node("GridContainer/Frame" + str(i + 1))
			
			frame.text = ""
			
			for score in scores[i]:
				if score == 10:
					frame.text += "X "
				else:
					frame.text += str(score) + " "
			
			if Global.summed_score.size() > i:
				frame.text += "\n" + str(Global.summed_score[i]) + " "
		
		
	$GridContainer/Total.text = str(Global.get_total_score())
	
	show()


# Advances the game or restarts it if the game has ended
func _on_Next_pressed():
	hide()
	get_owner().get_node("BowlingBall").reset(Global.is_scene_empty())


# Closes the game
func _on_Quit_pressed():
	get_tree().quit()
	

# Reloads scene
func _on_Restart_pressed():
	Global.reset_game()
