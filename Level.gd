extends TileMap

# class segment:
# 	var trigger := {}
# 	var cells := {}
# 	var pos := Vector2.ZERO
# 	var loaded := false
# 	var s : TileMap setget _set_segment
# 	func _set_segment(new):
# 		s = new
# 		for p in new.get_used_cells():
# 			cells[p + pos] = new.get_cellv(p)
# 		var minn := Vector2.ZERO
# 		var maxx := Vector2.ZERO
# 		for i in cells:
# 			minn.x = min(minn.x, i.x)
# 			minn.y = min(minn.y, i.y)
# 			maxx.x = max(maxx.x, i.x)
# 			maxx.y = max(maxx.y, i.y)
# 		area = Rect2(minn, maxx + Vector2.ONE)
# 	var area := Rect2(0,0,0,0)


# 	func load_map(offset: Vector2) -> void:
# 		if loaded:
# 			return
# 		loaded = true
# 		var level = Global.level
# 		for i in cells:		
# 			level.set_cellv(i + offset, cells[i])
# 			level.update_bitmask_area(i)
# 		for i in trigger:
# 			level.set_trigger(i + offset, trigger[i], pos)
# 		load_trigger()


# 	func load_trigger() -> void:
# 		var level = Global.level
# 		for i in s.get_children():
# 			if i is Trigger:
# 				level.add_trigger(i, s, pos + i.global_position / level.cell_size)
		
# 	func unload_map() -> bool:
# 		if not loaded:
# 			return true
# 		if area.has_point(Global.player.global_position / s.cell_size):
# 			return false
# 		# check trigger
# 		for i in trigger:
# 			if i.active:
# 				return false
# 		# unload map
# 		var level = Global.level
# 		for i in cells:
# 			level.set_cellv(i, -1)
# 		for i in trigger:
# 			if i.active:
# 				i.unload_map()
# 		loaded = false
# 		return true


# class trigger:
# 	extends Node2D

# 	var left : segment
# 	var right : segment
# 	var up : segment
# 	var down : segment

# 	var pos := Vector2.ZERO setget _set_pos
# 	func _set_pos(new):
# 		pos = new
# 		position = new * Global.level.cell_size
# 	var active := false
# 	var points := []


# 	func set_segment(s : TileMap, direction : Vector2, p: Vector2) -> void:
# 		var new_segment := segment.new()
# 		new_segment.s = s
# 		new_segment.pos = pos - p
# 		match direction.round():
# 			Vector2.LEFT:
# 				left = new_segment
# 			Vector2.RIGHT:
# 				right = new_segment
# 			Vector2.UP:
# 				up = new_segment
# 			Vector2.DOWN:
# 				down = new_segment
	

# 	func load_map() -> void:
# 		if active:
# 			return
# 		active = true
# 		print(position)
# 		if left:
# 			left.load_map(pos)
# 		if right:
# 			right.load_map(pos)
# 		if up:
# 			up.load_map(pos)
# 		if down:
# 			down.load_map(pos)
	

# 	func unload_map() -> void:
# 		active = false
# 		var flag = true
# 		flag = left.unload_map()
# 		flag = right.unload_map()
# 		flag = up.unload_map()
# 		flag = down.unload_map()
# 		if flag:
# 			remove()
	

# 	func remove() -> void:
# 		Global.level.remove_child(self)
# 		queue_free()
	

# 	func _physics_process(_delta: float) -> void:
# 		var state = get_world_2d().direct_space_state
# 		for i in points:
# 			var from = i + global_position
# 			var to = Global.player.global_position
# 			if from.distance_to(to) < 2000:
# 				var col = state.intersect_ray(i + global_position, Global.player.global_position, [], 1)
# 				if col and col.collider == Global.player:
# 					load_map()
# 				return

# #todo fix the targetsegment offset?

# export var start := ""
# var triggers := {}
# var segments := {}

# func _ready() -> void:
# 	var s = segment.new()
# 	yield(get_parent(), "ready")
# 	s.s = Global.segments.get_node("Start")
# 	s.load_map(Vector2.ZERO)


# func add_trigger(t: Trigger, sender: TileMap, pos := Vector2.ZERO) -> void:
# 	# var s_pos = t.pos - pos
# 	pos += t.position / cell_size
	
# 	if not pos in triggers:
# 		var new_trigger := trigger.new()
# 		new_trigger.points = t.points
# 		new_trigger.pos = pos
# 		var dir = Vector2.DOWN.rotated(t.rotation)
# 		new_trigger.set_segment(sender, dir, pos)
# 		new_trigger.set_segment(Global.segments.get_node(t.target), dir * -1, pos)
# 		add_child(new_trigger)



# func set_trigger(pos : Vector2, t : trigger, s : segment) -> void:
# 	pos += s.pos
# 	pos *=  cell_size
# 	if not pos in triggers:
# 		triggers[pos] = t
	
