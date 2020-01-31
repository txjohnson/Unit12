extends "res://scripts/Actor.gd"

var rng = RandomNumberGenerator.new()


var detected :bool = false
var detected_target = Vector2()

func _ready():
	pass # Replace with function body.

#func on_whos_there(who):
#	print (who.type == Actor.Player)
#	if who.type == Actor.Player:
#		who.emit_signal ("ohno", who)
#	return true
#
#
#func on_push (actor, direction, power):
#	if grid .can_move_from (position, direction):
#		return false
#	else:
#		var obj = grid .object_at_target (position, direction)
#		if actor == Actor.Block and (obj.type == Actor.Wall or obj.type == Actor.Block):
#			emit_signal ("ohno", self)
#			return true
#		else:
#			return false

func _process(delta):
	if not in_motion:
		if detected and rng.randi_range(0, 4) == 0:
			var dir = position .direction_to (detected_target)
			if dir.x > 0: dir.x = 1
			if dir.x < 0: dir.x = -1
			if dir.y > 0: dir.y = 1
			if dir.y < 0: dir.y = -1
			
			move_in_direction(dir)
			pass
		else:
			var dir = rng.randi_range(0, 4)
			
			if dir == 0:
				move_in_direction(UP)
			elif dir == 1:
				move_in_direction(DOWN)
			elif dir == 2:
				move_in_direction(LEFT)
			elif dir == 3:
				move_in_direction(RIGHT)
	
	pass

func _on_Area2D_area_entered(area):
	detected = true
	detected_target = area.position
	pass # Replace with function body.
