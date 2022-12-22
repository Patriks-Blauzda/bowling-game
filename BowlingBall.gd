extends RigidBody

# Player input states
enum state {
	POSITIONING = 0
	ANGLING = 1
	SPEED = 2
	ROLLING = 3
}

var action = state.POSITIONING

var speed = 0
var angle = 0
var spin = 0


# Resets all bowling ball and camera values and disables the ball's physics
func reset():
	mode = RigidBody.MODE_STATIC
	get_parent().get_node("Camera").overhead_view = true
	
	$Control/Speed.hide()
	$Control/Spin.hide()
	$Control/SpinText.hide()
	$GuidingArrow.hide()
	
	speed = 0
	angle = 0
	spin = 0
	
	translation = Vector3(-3.7, 0.25, 11)
	rotation_degrees = Vector3.ZERO
	action = state.POSITIONING


func _ready():
	reset()


# Enables physics for the bowling ball and applies specified amount of force and rotation
func roll(speed, angle, spin = 0):
	mode = MODE_RIGID
	apply_central_impulse(Vector3(angle, 18, -speed))
	apply_torque_impulse(Vector3(0, 0, spin))


# Functions to change position and spin, locked between set values
func adjust_position(direction):
	translation.x = clamp(translation.x + 0.01 * direction, -4.2, -3.2)

func adjust_spin(direction):
	spin = clamp(spin + 0.05 * direction, -10, 10)


func _input(event):
	if event is InputEventKey:
		if !event.echo && !event.pressed:
			match event.scancode:
				# Advances the game state every time the spacebar is pressed
				KEY_SPACE:
					match action:
						state.POSITIONING:
							$GuidingArrow.show()
							
							action = state.ANGLING
							
						state.ANGLING:
							angle = -$GuidingArrow.rotation_degrees.y * 2
							
							$Control/Speed.show()
							
							action = state.SPEED
							
						state.SPEED:
							speed = $Control/Speed.value
							get_parent().get_node("Camera").overhead_view = false
							
							$GuidingArrow.hide()
							$Control/Speed.hide()
							
							$Control/Spin.show()
							$Control/SpinText.show()
							action = state.ROLLING
							
						state.ROLLING:
							if mode != MODE_RIGID:
								$Control/Spin.hide()
								$Control/SpinText.hide()
								
								roll(speed, angle, spin)
				
				# Keys for debugging
				KEY_R:
					var _reload = get_tree().reload_current_scene()
				
				KEY_T:
					reset()


func _process(_delta):
	
	# Acts based on game state to allow player input
	match action:
		# Adjust from where to throw the bowling ball
		state.POSITIONING:
			if Input.is_action_pressed("left"):
				adjust_position(-1)
			
			if Input.is_action_pressed("right"):
				adjust_position(1)
		
		# Goes back and forth for the player to determine angle
		state.ANGLING:
			$GuidingArrow.rotation_degrees.y = clamp(sin(Time.get_unix_time_from_system() * 2) * 20, -20, 20)
		
		# Same as angling, but for the ball's speed
		state.SPEED:
			$Control/Speed.value = clamp(sin(Time.get_unix_time_from_system() * 6) * 50 + 150, 100, 200)
		
		# Allows the player to choose how much the ball spins before rolling
		state.ROLLING:
			if Input.is_action_pressed("left"):
				adjust_spin(1)
			
			if Input.is_action_pressed("right"):
				adjust_spin(-1)
			
			$Control/Spin.rotation_degrees -= spin
			$Control/SpinText.text = str(stepify(-spin, 0.10))


# Prevents the ball from spinning and going flying when in the gutter
func _on_Gutter_body_entered(body):
	if body.name == "BowlingBall":
		angular_velocity = Vector3.ZERO
