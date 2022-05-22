extends KinematicBody2D

const ROTATION_SPEED = 1
var rotates_left = false
var rotates_right = false

func get_fire_point_position():
	return to_global($FirePoint.position)

func get_barrel_direction():
	var global_pos = to_global(Vector2.ZERO)
	var global_fire_pos = to_global($FirePoint.position)
	return (global_fire_pos - global_pos).normalized()
	
func _input(event):
	if event.is_action_pressed("ui_up") and not rotates_right:
		rotates_left = true
		
	if event.is_action_released("ui_up"):
		rotates_left = false
		
	if event.is_action("ui_down") and not rotates_left:
		rotates_right = true
		
	if event.is_action_released("ui_down"):
		rotates_right = false

func _process(delta):
	rotate_barrel(delta)
		
func rotate_barrel(delta):
	var rotation_value = 0
	if rotates_left:
		rotation_value = -1
	elif rotates_right:
		rotation_value = 1
	
	if rotation_value != 0:
		rotation_value = rotation_value * delta * ROTATION_SPEED
		rotate(rotation_value)
