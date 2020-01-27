extends Node2D

onready var grid = get_parent ()

var initial_grid_position = Vector2()
var type = -1

func _ready():
#	modulate = Color( 1, 0.2, 0, 0.2 )
	pass
	
func _draw():
	var LINE_COLOR = Color(.25, .25, .25)
	var LINE_WIDTH = 2
	var window_size = OS.get_window_size()

	var half = grid.cell_size / 2
	
	var xmax = int (window_size.x / grid.cell_size.x)
	var ymax = int (window_size.y / grid.cell_size.y)
	
	for x in range (xmax):
		draw_line (grid.map_to_world (Vector2(x, 0)) + half, grid.map_to_world (Vector2(x, ymax)) + half, LINE_COLOR, LINE_WIDTH)
		
	for y in range (ymax):
		draw_line (grid.map_to_world (Vector2(0, y)) + half, grid.map_to_world (Vector2(xmax, y)) + half, LINE_COLOR, LINE_WIDTH)

