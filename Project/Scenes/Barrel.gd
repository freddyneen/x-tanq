extends KinematicBody2D

func get_fire_point_position():
	return to_global($FirePoint.position)


func get_barrel_direction():
	var global_pos = to_global(Vector2.ZERO)
	var global_fire_pos = to_global($FirePoint.position)
	return (global_fire_pos - global_pos).normalized()
