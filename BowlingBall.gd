extends RigidBody

onready var pins = get_parent().get_node("Pins")
onready var camera = get_parent().get_node("Camera")

# Player input states
enum state {
	POSITIONING = 0
	ANGLING = 1
	SPEED = 2
	SPIN = 3
	ROLLING = 4
}

var action = state.POSITIONING

var speed = 0
var angle = 0
var spin = 0


# Resets all bowling ball and camera values and disables the ball's physics
func reset():
	mode = RigidBody.MODE_STATIC
	camera.overhead_view = true
	
	$Control/Speed.hide()
	$Control/Spin.hide()
	$GuidingArrow.hide()
	
	speed = 0
	angle = 0
	spin = 0
	
	translation = Vector3(-3.7, 0.25, 11)
	rotation_degrees = Vector3.ZERO
	action = state.POSITIONING


func _ready():
	reset()
	pins.set_pins(true)


# Enables physics for the bowling ball and applies specified amount of force and rotation
func roll(speed, angle, spin = 0):
	mode = MODE_RIGID
	apply_central_impulse(Vector3(angle, 18, -speed))
	apply_torque_impulse(Vector3(-1, 0, spin))


# Functions to change position and spin, locked between set values
func adjust_position(direction):
	translation.x = clamp(translation.x + 0.01 * direction, -4.2, -3.2)

func adjust_spin(direction):
	spin = clamp(spin + 0.05 * direction, -10, 10)
	if spin < 0:
		$Control/Spin.flip_h = false
	else:
		$Control/Spin.flip_h = true


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
							camera.overhead_view = false
							
							$GuidingArrow.hide()
							$Control/Speed.hide()
							
							$Control/Spin.show()
							action = state.SPIN
							
						state.SPIN:
							$Control/Spin.hide()
							
							roll(speed, angle, spin)
							action = state.ROLLING
				
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
		state.SPIN:
			if Input.is_action_pressed("left"):
				adjust_spin(1)
			
			if Input.is_action_pressed("right"):
				adjust_spin(-1)
			
			$Control/Spin.rotation_degrees -= spin
		
		# Checks when the ball has dropped in the gutter and waits before finishing
		state.ROLLING:
			if translation.y < -0.45 && $Timer.is_stopped():
				$Timer.start()


# After set amount of time has passed, adds score and resets the game
func _on_Timer_timeout():
	pins.set_pins(Global.add_points())
	reset()
	

# Prevents the ball from spinning and going flying when in the gutter
func _on_Gutter_body_entered(body):
	if body.name == "BowlingBall":
		angular_velocity = Vector3.ZERO
