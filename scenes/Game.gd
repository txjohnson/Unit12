extends Node2D

var wall = preload("res://objects/Wall.tscn")
var block = preload ("res://objects/Block.tscn")
var poe   = preload ("res://objects/Poe.tscn")
var fx    = preload("res://assets/Burst.tscn")


var rng = RandomNumberGenerator.new()


export var blocks_count = 400
export var monster_count = 10

func _ready():
	rng.randomize()
	create_border()
	place_blocks()
	pass # Replace with function body.


func create_border ():
	var window_size = OS.get_window_size()

	var xmax = int (window_size.x / $Grid.cell_size.x)
	var ymax = int (window_size.y / $Grid.cell_size.y)

	for x in range (xmax+1):
		var w1 = wall.instance()
		var w2 = wall.instance()
		w1.initial_grid_position = Vector2 (x, 0)
		w2.initial_grid_position = Vector2 (x, ymax)
		$Grid.add_child (w1)
		$Grid.add_child (w2)
		
	for y in range (1, ymax):
		var w1 = wall.instance()
		var w2 = wall.instance()
		w1.initial_grid_position = Vector2 (0, y)
		w2.initial_grid_position = Vector2 (xmax, y)
		$Grid.add_child (w1)
		$Grid.add_child (w2)

func place_blocks():
	var window_size = OS.get_window_size()

	var xmax = int (window_size.x / $Grid.cell_size.x)
	var ymax = int (window_size.y / $Grid.cell_size.y)

	var positions = []
	
	for i in range (blocks_count):
		var pos = Vector2()
		while $Grid.get_cellv (pos) >= 0 or pos in positions:
			pos = Vector2 (rng.randi() % xmax, rng.randi() % ymax)
		positions .append (pos)
		
	for p in positions:
		var b = block.instance()
		b.initial_grid_position = p
		$Grid.add_child (b)
		

func on_bad_end (who):
	var bad = fx.instance()
	bad.position = who.position
	$Grid.remove_child (who)
	add_child (bad)
	bad.emitting = true