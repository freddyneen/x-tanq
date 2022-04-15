extends Node2D

export (PackedScene) var CaterpillarPart

var speed = 10

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	create_caterpillar_track()
	set_process_input(true)
	pass
	
func _input(event):
	if event.is_action("ui_right"):
		$WheelR.set_angular_velocity(speed)
		$WheelL.set_angular_velocity(speed)
		
	if event.is_action("ui_left"):
		$WheelR.set_angular_velocity(-speed)
		$WheelL.set_angular_velocity(-speed)

func create_caterpillar_track():
	var cprev = CaterpillarPart.instance() as RigidBody2D
	$Track.add_child(cprev)
	
	var cpLength = cprev.PartLength
	var lastPosition = $Path/PathFollow.position
	var nextPosition = $Path/PathFollow.position
	
	cprev.position = lastPosition
	cprev.look_at(to_global(nextPosition))
	cprev.collision_layer = 2
	
	while $Path/PathFollow.get_unit_offset() < 1:
		$Path/PathFollow.offset += cpLength
		var cnext = CaterpillarPart.instance() as RigidBody2D
		nextPosition = $Path/PathFollow.position
		cnext.position = lastPosition
		cnext.look_at(to_global(nextPosition))
		cnext.collision_layer = 2
		$Track.add_child(cnext)
		var pj = PinJoint2D.new()
		pj.position = nextPosition
		pj.node_a = cprev.get_path()
		pj.node_b = cnext.get_path()
		$Track.add_child(pj)
		cprev = cnext
		print(cpLength, "|", $Path/PathFollow.position)
		lastPosition = $Path/PathFollow.position
