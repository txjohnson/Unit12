extends KinematicBody2D

signal ohno

enum Actor { Nothing = -1, Player, Wall, Block, Monster }
export(Actor) var type = Actor.Player

export var speed = 5
export var initial_grid_position = Vector2 (0, 0)
export var can_be_pushed :bool = false
export var strength :int  = 0

onready var grid = get_parent ()


const UP    = Vector2 (0, -1)
const DOWN  = Vector2 (0, 1)
const RIGHT = Vector2 (1, 0)
const LEFT  = Vector2 (-1, 0)

var in_motion :bool = false
var motion_lerp :float = 0.0
var motion_beg  = Vector2()
var motion_end  = Vector2()

var motion_target = Vector2 ()
var motion_direction = Vector2 ()
var velocity = Vector2 ()


func on_whos_there(who):
	return true
	
func on_push (actor, direction, power):
	if grid .can_move_from (position, direction):
		motion_target = grid.get_target_position (position, direction)
		motion_direction = direction
		grid .update_child_position (get_index(), position, motion_target)
		move_to (motion_target)
		return true
	else:
		var obj = grid .object_at_target (position, direction)
		if obj.push (type, direction, power - 1):
			move_in_direction (direction)
			return true

func move_in_direction (direction):
	if not in_motion and direction != Vector2():
		if grid .can_move_from (position, direction):
			motion_target = grid.get_target_position (position, direction)
			motion_direction = direction
			grid .update_child_position (get_index(), position, motion_target)
			move_to (motion_target)
		else:
			var obj = grid .object_at_target (position, direction)
			if on_whos_there (obj):
				if obj.push (type, direction, strength):
					move_in_direction (direction)
	pass

func push (actor, direction, power):
	if not can_be_pushed: return false
	if power <= 0: return false

	if not in_motion and direction != Vector2():
		return on_push (actor, direction, power)
	return false
	
func move_and_pull_in_direction (direction):
	var obj = grid .object_at_target (position, -direction)
	move_in_direction (direction)
	if obj != null:
		obj .push (type, direction, 1)
		
func move_to (target):
	motion_lerp = 0.0
	motion_beg = position
	motion_end = target
	in_motion = true
	
func _physics_process (delta):
	if in_motion:
		motion_lerp += speed * delta
		if motion_lerp < 1.0:
			position = motion_beg .linear_interpolate (motion_end, motion_lerp)
		else:
			position = motion_end
			in_motion = false

#	if in_motion:
#		velocity = speed * motion_direction * delta
#		var distance = position .distance_to (motion_target)
#		var move_distance = velocity.length()
#
#		if distance < move_distance:
#			velocity  = motion_direction * distance
#			in_motion = false
#		move_and_collide(velocity)
