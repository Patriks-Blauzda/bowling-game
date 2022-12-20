extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(Vector3(0, 15, -180))
	apply_torque_impulse(Vector3(0, 0, 0))
