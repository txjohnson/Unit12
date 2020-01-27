extends KinematicBody2D

enum Actor { Nothing = -1, Player, Wall, Block, Monster }
export(Actor) var type = Actor.Player

export var speed = 400
export var initial_grid_position = Vector2 (0, 0)
export var can_be_pushed :bool = false
export var strength :int  = 0

onready var grid = get_parent ()


const UP    = Vector2 (0, -1)
const DOWN  = Vector2 (0, 1)
const RIGHT = Vector2 (1, 0)
const LEFT  = Vector2 (-1, 0)

var in_motion :bool = false
var motion_target = Vector2 ()
var motion_direction = Vector2 ()
var velocity = Vector2 ()


func move_in_direction (direction):
	if not in_motion and direction != Vector2():
		if grid .can_move_from (position, direction):
			motion_target = grid.get_target_position (position, direction)
			motion_direction = direction
			grid .update_child_position (get_index(), position, motion_target)
			in_motion = true
		else:
			var obj = grid .object_at_target (position, direction)
			if obj.push (direction, strength):
				move_in_direction (direction)
	pass

func push (direction, power):
	if not can_be_pushed: return false
	if power <= 0: return false
	
	if not in_motion and direction != Vector2():
		if grid .can_move_from (position, direction):
			motion_target = grid.get_target_position (position, direction)
			motion_direction = direction
			grid .update_child_position (get_index(), position, motion_target)
			in_motion = true
			return true
		else:
			var obj = grid .object_at_target (position, direction)
			if obj.push (direction, power - 1):
				move_in_direction (direction)
				return true
	return false
	
func move_and_pull_in_direction (direction):
	var obj = grid .object_at_target (position, -direction)
	move_in_direction (direction)
	if obj != null:
		obj .push (direction, 1)
		

func _physics_process (delta):
	if in_motion:
		velocity = speed * motion_direction * delta
		var distance = position .distance_to (motion_target)
		var move_distance = velocity.length()
		
		if distance < move_distance:
			velocity  = motion_direction * distance
			in_motion = false
		move_and_collide(velocity)
