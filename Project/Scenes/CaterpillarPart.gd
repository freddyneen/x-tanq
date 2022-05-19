extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_part_length():
	return $StartPoint.position.distance_to($EndPoint.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
