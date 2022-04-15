extends RigidBody2D

export var engine_thrust = 30
var initialThrust = Vector2(0, -0.3)
var thrust = initialThrust

func get_input():
	if Input.is_action_pressed("ui_right"):
		thrust = initialThrust + transform.x
	if Input.is_action_pressed("ui_left"):
		thrust = initialThrust - transform.x

func _process(delta):
	get_input()

func _physics_process(delta):
	var rc = $RCLeft.is_colliding() or $RCRight.is_colliding()
	if thrust.x > 0 and rc:
		apply_impulse($WheelsRight.transform.get_origin(), thrust * engine_thrust)
		add_torque(-engine_thrust*4)
	elif thrust.x < 0 and rc:
		apply_impulse($WheelsLeft.transform.get_origin(), thrust * engine_thrust)
		add_torque(engine_thrust*4)
	thrust = initialThrust
