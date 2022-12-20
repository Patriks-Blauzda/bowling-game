extends Camera

# Follows the bowling ball at a set distance, but doesn't go out of bounds
func _process(_delta):
	translation.z = clamp(get_parent().get_node("BowlingBall").translation.z + 3, -6, 12.2)
