extends Camera

var overhead_view = true


# Follows the bowling ball at a set distance, but doesn't go out of bounds
func _process(_delta):
	var bowlingball = get_parent().get_node("BowlingBall")
	
	if !overhead_view:
		translation.z = clamp(bowlingball.translation.z + 3, -6, 12.2)
		
		rotation_degrees.x = -18.8
	
	# Overhead camera angle, should only be used 
	else:
		translation.z = bowlingball.translation.z + 0.4
		rotation_degrees.x = -35
