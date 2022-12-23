extends Node

# Default pin positions, ordered left to right and first to last
const pin_positions = [
	Vector3(-3.704, 0.267, -9.92), Vector3(-3.844, 0.267, -10.15), Vector3(-3.524, 0.267, -10.15), 
	Vector3(-4.004, 0.267, -10.4), Vector3(-3.704, 0.267, -10.4), Vector3(-3.404, 0.267, -10.4), 
	Vector3(-4.154, 0.267, -10.68), Vector3(-3.844, 0.267, -10.68), Vector3(-3.524, 0.267, -10.68), 
	Vector3(-3.264, 0.267, -10.68)
	]


# Separated from check_pins for readability
func _is_upright(rot : Vector3):
	if -60 < rot.x && rot.x < 60 && -60 < rot.z && rot.z < 60:
		return true
	else:
		return false

# Returns an array of each pin's status. If true, pin is upright
func check_pins(reset = false):
	var status = []
	for pin in get_children():
		if (pin.translation.y > 0.22 && _is_upright(pin.rotation_degrees)) || reset:
			status.append(true)
		else:
			status.append(false)
	
	return status


# Moves upright pins to original positions and other pins away, or resets all pins
func set_pins(reset = false):
	var status = check_pins(reset)
	
	for i in range(status.size()):
		if status[i] || reset:
			get_children()[i].translation = pin_positions[i]
			get_children()[i].rotation_degrees = Vector3.ZERO
			
			get_children()[i].linear_velocity = Vector3.ZERO
			get_children()[i].angular_velocity = Vector3.ZERO
		else:
			get_children()[i].translation = Vector3(get_children()[i].translation.x, -0.5, -11.5)
	
	Global.active_pins = status
