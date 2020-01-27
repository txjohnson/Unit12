extends TileMap

var tile_size = cell_size
var half_tile_size = cell_size / 2

func _ready():
	for n in get_children():
		n.position = map_to_world (n.initial_grid_position)
		set_cellv(n.initial_grid_position, n.get_index())
	pass
	

func can_move_from (current_pos, direction):
	var grid_pos = world_to_map (current_pos) + direction
	
	if 	get_cellv (grid_pos) < 0:
		return true
	else:
		return false

func get_target_position (current, direction):
	var grid_pos = world_to_map (current) + direction
	return map_to_world (grid_pos)

func object_at_target (current, direction):
	var grid_pos = world_to_map (current) + direction
	var obj = get_cellv (grid_pos)
	if obj < 0:
		return null
	else:
		return get_children()[obj]

func update_child_position (index, old_pos, new_pos):
	var from = world_to_map (old_pos)
	var to   = world_to_map (new_pos)
	
	set_cellv (from, -1)
	set_cellv (to, index)
	
func add_child (node, legible_unique_name=false):
	.add_child (node)
	set_cellv (node.initial_grid_position, node.get_index())
	node.position = map_to_world (node.initial_grid_position)

func remove_child (node):
	var grid_pos = world_to_map(node.position)
	set_cellv(grid_pos, -1)
	node .replace_by (Node.instance())
	node.queue_free()