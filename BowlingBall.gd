extends RigidBody

var rolling = false

# Enables physics for the bowling ball and applies specified amount of force and rotation
func roll(speed, angle, spin = 0):
	mode = MODE_RIGID
	apply_central_impulse(Vector3(angle, 18, -speed))
	apply_torque_impulse(Vector3(0, 0, spin))

# Change position to roll the bowling ball from
func adjust_position(direction):
	translation.x = clamp(translation.x + 0.01 * direction, -4.2, -3.2)


func _process(_delta):
	if !rolling:
		if Input.is_action_pressed("left"):
			adjust_position(-1)
		
		if Input.is_action_pressed("right"):
			adjust_position(1)
	


func _input(event):
	if event is InputEventKey:
		if !event.echo && !event.pressed:
			match event.scancode:
				KEY_SPACE:
					if mode != MODE_RIGID && !rolling:
						roll(180, 8, 10)
						rolling = true
						
				KEY_R:
					var _reload = get_tree().reload_current_scene()


# Prevents the ball from spinning and going flying when in the gutter
func _on_Gutter_body_entered(body):
	if body.name == "BowlingBall":
		angular_velocity = Vector3.ZERO
