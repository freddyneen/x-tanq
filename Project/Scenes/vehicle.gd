extends Node2D

export (PackedScene) var CaterpillarPart
export (PackedScene) var Bullet

var speed = 10
var move_left = false
var move_right = false
var fire_power = 0
var firing = false

func _ready():
	create_caterpillar_track()
	#set_process_input(true)
	pass
	
func _input(event):
	if event.is_action_pressed("ui_left") and not move_right:
		move_left = true
		
	if event.is_action_released("ui_left"):
		move_left = false
		
	if event.is_action("ui_right") and not move_left:
		move_right = true
		
	if event.is_action_released("ui_right"):
		move_right = false
		
	if event.is_action_pressed("ui_select"):
		firing = true
		
	if event.is_action_released("ui_select") and firing:
		firing = false;
		fire()
		fire_power = 0
		
func _process(delta):
	#print_debug(delta)
	if (firing and fire_power < 1):
		fire_power = min(1, fire_power + delta)

func _physics_process(delta):
	move_vehicle(delta)
		
func move_vehicle(delta):
	var move_value = 0
	if move_left:
		move_value = -1
	elif move_right:
		move_value = 1
	
	if move_value != 0:
		$WheelR.set_angular_velocity(move_value * speed)
		$WheelL.set_angular_velocity(move_value * speed)
		
func fire():
	var bullet = Bullet.instance() as RigidBody2D
	bullet.position = $Center/Barrel.get_fire_point_position()
	get_tree().get_root().add_child(bullet)
	bullet.apply_central_impulse($Center/Barrel.get_barrel_direction() * 400 * fire_power)

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
