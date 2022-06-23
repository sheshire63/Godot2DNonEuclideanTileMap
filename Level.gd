extends TileMap


func _ready() -> void:
	yield(get_parent(), "ready")
	new_room("Start", Vector2(0, -128))


func new_room(name, offset: Vector2) -> Room2D:
	var room = Room2D.new()
	room.position = offset
	offset /= cell_size
	room.segment = Global.segments.get_node(name)
	add_child(room)
	return room


func load_room_from_trigger(trigger: Trigger) -> void:
	#get_room_position
	var pos = trigger.global_position
	var target_marker = trigger.marker.target
	pos -= target_marker.position

	var room = new_room(target_marker.get_parent().name, pos)
	trigger.room = room

	room.triggers.append(trigger)
	for t in room.get_children():
		if t.global_position == trigger.global_position:
			t.room = trigger.get_parent()
			trigger.get_parent().triggers.append(t)
			break


"""
		Flow:
			Room gets loaded from start
			Room loads its triggers

			triggers when 
				player in room and trigger can see the player
				plyer not in room and trigger sees the trigger loading it

			on trigger
				load connected room
				link triggered from info to new room
			on untrigger
				unlink triggered from info
			removing
				check if player is in room
				check if room is linked
			
			triggers get removed with the room
"""



class Trigger:
	extends Area2D
	var room : Room2D #the room the trigger has loaded
	var points := []
	var marker : TriggerMarker
	var direction : Vector2
	var triggered := false
	var is_first_frame := true


	func _draw() -> void:
		if Global.debug:
			draw_circle(Vector2.ZERO, 10, Color.red)
			for i in points:
				draw_circle(i, 5, Color.turquoise)
			draw_line(Vector2.ZERO, direction * 64, Color.blue, 10)
			if is_facing_player():
				draw_line(Vector2.ZERO, global_position.direction_to(Global.player.global_position) * 128, Color.green if triggered else Color.red, 7)

	
	func _ready() -> void:
		z_index = 1
		var body = CollisionShape2D.new()
		body.shape = SegmentShape2D.new()
		call_deferred("add_child", body)
		collision_layer = 1
		direction = Vector2.RIGHT.rotated(wrapf(marker.rotation - Vector2.UP.angle(), 0, 2 * PI))
		body.shape.a = points[1]
		body.shape.b = points[2]
		
	

#todo add check to see if the player is visible from the trigger?
#remove the while from player check?
#move the rays back to trigger
	func trigger() -> void:
		triggered = true
		if !is_instance_valid(room):
			Global.level.load_room_from_trigger(self)
	

	func untrigger() -> void:
		triggered = false
		# if is_instance_valid(room) and not room.has_player:
		# 	for i in room.triggers:
		# 		if is_instance_valid(i) and i.triggered:
		# 			return
		# 	room.queue_free()


	func _process(_delta: float) -> void:#todo add check if triggers are on screen
		update()
		if is_first_frame:
			is_first_frame = false
			return
		if is_facing_player():
			var viewrect = get_viewport_rect()
			viewrect.size *= 1.5
			viewrect.position = Global.player.global_position - (viewrect.size / 2)
			var state = get_world_2d().direct_space_state
			for i in points:
				var from = to_global(i)
				if not viewrect.has_point(from):
					continue
				from -= Global.player.global_position.direction_to(from)
				var col = state.intersect_ray(from, Global.player.global_position, get_parent().get_children(), 1, true, true)#the problem might be that the trigger at the same position is not detetcted
				if get_parent().has_player:
					if col and col.collider == Global.player:
						trigger()
						return
				elif col and col.collider in get_parent().triggers:
					trigger()
					return
		untrigger()			
	

	func is_facing_player() -> bool:
		return abs(wrapf(direction.angle_to(global_position.direction_to(Global.player.global_position)), -PI, PI)) < PI/2 #this does not work if only one is in the negative


class Room2D:
	extends Area2D
	
	var area_size := Vector2.ZERO
	var triggers := [] #triggers that have this room loaded
	var cells := {}
	var segment : TileMap
	var has_player := false
	var label := ""
	var is_first_frame = true
	var overlaps := []


	func _ready() -> void:
		label = segment.name
		var shape = CollisionShape2D.new()
		shape.shape = RectangleShape2D.new()
		collision_layer = 0
		collision_mask = 4
		call_deferred("add_child", shape)
		connect("body_entered", self, "_on_body_entered")
		connect("body_exited", self, "_on_body_exited")
		connect("area_entered", self, "_on_area_entered")
		connect("area_exited", self, "_on_area_exited")

		for cell in segment.get_used_cells():
			cells[cell + (global_position/segment.cell_size)] = segment.get_cellv(cell)

		var rect = segment.get_used_rect()
		area_size = rect.size * segment.cell_size / 2.0
		shape.shape.extents = area_size

		var offset = rect.position * segment.cell_size + area_size
		shape.position = offset
		
		add_trigger()
	

	func _draw() -> void:
		if Global.debug:
			draw_circle(Vector2.ZERO, 10, Color.magenta)


	func _on_body_entered(body) -> void:
		if body == Global.player:
			has_player = true
	

	func _on_body_exited(body) -> void:
		if body == Global.player:
			has_player = false
	

	func _on_area_entered(area) -> void:
		if area is Room2D:
			overlaps.append(area)
	

	func _on_area_exited(area) -> void:
		overlaps.erase(area)
	

	func add_trigger() -> void:
		for t in segment.get_children():
			var pos = t.get_position()
			var trigger:= Trigger.new()
			trigger.position = pos
			trigger.points = t.points
			trigger.marker = t
			add_child(trigger)

	
	func _draw_room_part() -> void:
		var state = get_world_2d().direct_space_state
		for cell in cells:
			for offset in [
						# Vector2(.25,.25), Vector2(.75,.75), Vector2(.25, .75), Vector2(.75, .25),
						Vector2.ZERO, Vector2.ONE, Vector2.RIGHT, Vector2.DOWN,
						# Vector2(-.25,-.25), Vector2(1.25,1.25), Vector2(1.25, -.25), Vector2(-.25, 1.25)
						]:
				var tile_changed = false
				for player_offset in [Vector2.ZERO, Vector2.ONE, -Vector2.ONE, Vector2(-1, 1), Vector2(1,-1)]:	
					var pos = cell + offset #adjust offsets to acount for the walls
					pos *= segment.cell_size
					var player_pos = Global.player.global_position
					player_pos += player_offset * 16.0
					var col = state.intersect_ray(pos, player_pos, get_children(), 1, true, true)
					if col and (col.collider in triggers):# or col.collider == Global.player):
						Global.level.set_cellv(cell, cells[cell])
						Global.level.update_bitmask_area(cell)
						tile_changed = true
						break
				if tile_changed:
					break


	func _draw_room() -> void:
		var from
		for cell in cells:
			if !from:
				from = cell
			from.x = min(from.x, cell.x)
			from.y = min(from.y, cell.y)
			Global.level.set_cellv(cell, cells[cell])
		Global.level.update_bitmask_region(from, from + (area_size / segment.cell_size *2))


	func _process(_delta: float) -> void:
		if is_first_frame:
			is_first_frame = false
			return
		if has_player:
			_draw_room()
			return
		for i in triggers:
			if is_instance_valid(i):
				if i.triggered:
					if overlaps:
						_draw_room_part()
					else:
						_draw_room()
					return
			else:
				triggers.erase(i)
		queue_free()


#the freeing does not always work
#the triggering of cells does not work
	#the ray does not seem to trigger the areas
