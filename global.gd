extends Node


# var connections := {}
var player
var level: TileMap
var font = preload("res://Assets/Font.tres")
# var points := []
var segments : Node2D
var debug = false


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        debug = !debug

# class connection:
# 	extends Node2D
# 	var maps := {
# 		Vector2.UP: {},
# 		Vector2.DOWN: {},
# 		Vector2.LEFT: {},
# 		Vector2.RIGHT: {},
# 		Vector2.ZERO: {}
# 	}

# 	var loaded := []
# 	# var offset := Vector2.ZERO
# 	var triggers := {
# 		Vector2.UP: [],
# 		Vector2.DOWN: [],
# 		Vector2.LEFT: [],
# 		Vector2.RIGHT: [],
# 		Vector2.ZERO: []
# 	}


# 	func add_map(map: TileMap, off: Vector2, dir: Vector2)-> void:
# 		for pos in map.get_used_cells():
# 			pos += off
# 			if maps[dir * -1].erase(pos):
# 				maps[Vector2.ZERO] = map.get_cellv(pos)
# 			else:
# 				maps[pos] = map.get_cellv(pos)


# 	func load(map: TileMap)-> void:
# 		for i in maps:
# 			if i and maps[i]:
# 				loaded.append(i)
# 			for pos in maps[i]:
# 				map.set_cellv(pos, maps[i][pos])
		
	
# 	func _clear(map: TileMap, dir: Vector2)-> void:
# 		#todo check trigger
# 		loaded.erase(dir)
# 		for pos in maps[dir]:
# 			map.set_cellv(pos, -1)


# 	func clear(map: TileMap, dir := Vector2.ZERO)-> void:
# 		if dir:
# 			_clear(map, dir)
# 		else:
# 			for i in maps:
# 				_clear(map, i)
# 		if !loaded:
# 			queue_free()



# 	# func _process(_delta: float) -> void:
# 	# 	if Engine.editor_hint:
# 	# 		return
# 	# 	var state = get_world_2d().direct_space_state
# 	# 	for point in points:
# 	# 		var col = state.intersect_ray(to_global(point), Global.player.global_position)
# 	# 		if col and col.collider == Global.player:
# 	# 			trigger()
# 	# 			return
# 	# 	untrigger()


# 	# func trigger() -> void:
# 	# 	if is_triggered:
# 	# 		return
# 	# 	is_triggered = true
# 	# 	if Global.set_connection(global_position, self):
# 	# 		_load_segments()
# 	# 	else:
# 	# 		queue_free()


# 	# func merge(target: Node2D) -> void:
# 	# 	if target == self:
# 	# 		# _load_segments()
# 	# 		return
# 	# 	target.from_transform = target.global_transform
# 	# 	target.from = to
# 	# 	target.from_instance = to_instance
# 	# 	self.queue_free()


# 	# func untrigger() -> void:
# 	# 	if not is_triggered:
# 	# 		return
# 	# 	is_triggered = false
# 	# 	Global.remove_connection(global_position, self)


# 	# func _load_segments() -> void:
# 	# 	if from:
# 	# 		if !is_instance_valid(from_instance):
# 	# 			from_instance = load(from).instance()
# 	# 			from_instance.global_transform = from_transform
# 	# 			Global.level.add_child(from_instance)
# 	# 	if to:
# 	# 		if !is_instance_valid(to_instance):
# 	# 			to_instance = load(to).instance()
# 	# 			to_instance.global_transform = to_transform
# 	# 			Global.level.add_child(to_instance)



# func register(dir: Vector2, from_name: String, to_name:String, ray_points: Array, pos := Vector2.ZERO) -> void:
# 	if not pos in connections:
# 		var new = connection.new()
# 		new.position = pos * level.cell_size
# 		new.points = ray_points
# 		new.add_map(from_name, pos, dir)
# 		new.add_map(to_name, pos, dir * -1)

# 		connections[pos] = new
	
	




# func set_connection(position, connection) -> bool:
# 	if position in connections:
# 		connections[position].merge(connection)
# 		connections[position]._load_segments()
# 		return false
# 	else:
# 		connections[position] = connection
# 		connection.get_parent().remove_child(connection)
# 		add_child(connection)
# 		connection.global_position = position
# 		return true


# func remove_connection(position, connection) -> void:
# 	if position in connections:
# 		if connection.try_free():
# 			connections.erase(position)

		
