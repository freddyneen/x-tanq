extends Node2D

export (PackedScene) var CaterpillarPart
export (PackedScene) var Bullet

var speed = 10

func _ready():
	create_caterpillar_track()
	#set_process_input(true)
	pass
	
func _input(event):
	if event.is_action("ui_right"):
		$WheelR.set_angular_velocity(speed)
		$WheelL.set_angular_velocity(speed)
		
	if event.is_action("ui_left"):
		$WheelR.set_angular_velocity(-speed)
		$WheelL.set_angular_velocity(-speed)
		
	if event.is_action("ui_up"):
		$Center/Barrel.rotate(deg2rad(-1))
		
	if event.is_action("ui_down"):
		$Center/Barrel.rotate(deg2rad(1))
		
	if event.is_action("ui_select"):
		fire()
		
func fire():
	var bullet = Bullet.instance() as RigidBody2D
	bullet.position = $Center/Barrel.get_fire_point_position()
	get_tree().get_root().add_child(bullet)
	bullet.apply_central_impulse($Center/Barrel.get_barrel_direction() * 400)

func create_caterpillar_track():
	var partInit = CaterpillarPart.instance() as RigidBody2D
	var first
	var cprev
	
	var cpLength = partInit.get_part_length()
	partInit.queue_free()
	
	var lastPosition = $Path/PathFollow.position
	var nextPosition = lastPosition
	
	while $Path/PathFollow.get_unit_offset() < 1:
		$Path/PathFollow.offset += cpLength
		var cnext = CaterpillarPart.instance() as RigidBody2D
		$Track.add_child(cnext)
		if (first == null):
			first = cnext
		nextPosition = $Path/PathFollow.position
		var centerPos = (lastPosition + nextPosition) / 2 + $Path.position
		var rotationVec = (nextPosition - lastPosition).angle()
		cnext.position = centerPos
		cnext.set_rotation(rotationVec)
		cnext.collision_layer = 2
		
		if (cprev != null):
			var pj = PinJoint2D.new()
			$Track.add_child(pj)
			pj.position = lastPosition
			pj.node_a = cprev.get_path()
			pj.node_b = cnext.get_path()
		cprev = cnext
		lastPosition = nextPosition
		
	var pj = PinJoint2D.new()
	$Track.add_child(pj)
	pj.position = lastPosition
	pj.node_a = cprev.get_path()
	pj.node_b = first.get_path()
