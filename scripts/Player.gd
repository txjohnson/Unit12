extends "res://scripts/Actor.gd"

func _ready():
	pass # Replace with function body.


func _process (delta):
	if Input.is_action_pressed ("ui_up"):
			move_in_direction(UP)
		
	elif Input.is_action_pressed ("ui_down"):
			move_in_direction (DOWN)
		
	elif Input.is_action_pressed ("ui_left"):
			move_in_direction (LEFT)
		
	elif Input.is_action_pressed ("ui_right"):
			move_in_direction (RIGHT)
		

