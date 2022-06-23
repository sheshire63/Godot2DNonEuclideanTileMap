tool
extends Node2D

class_name TriggerMarker

const ray_step := 256.0
export(float, 128, 1024, 128) var size := 128.0 setget _set_size
func _set_size(v:float):
	size = v
	update()
export(NodePath) var target_path setget _set_target_path
func _set_target_path(v:NodePath):
	target_path = v
	update()

var from := ""
var points := [Vector2.ZERO]
var target


func _draw() -> void:
	if Engine.editor_hint:
		draw_line(Vector2(-size/2, 0), Vector2(size/2, 0), Color(1, 0, 1, 1), 5)
		draw_line(Vector2.ZERO, Vector2.UP * 64, Color(1, 0, 1, 1), 5)
		# draw_string(Global.font, Vector2.ZERO, str(self), Color.blueviolet)
		if target_path:
			var t = get_node(target_path)
			if t:
				draw_line(Vector2.RIGHT * 16  , to_local(t.global_position), Color(1, 0, 1, 1), 5)


#func _to_string() -> String:
#	var data = [
##		str(get_script()),
#		self.from,
#		self.from_instance, "|",
##		self.from_transform.x,
##		self.from_transform.y,
##		self.from_transform.get_rotation(),
#		self.to,
#		self.to_instance,
##		self.to_transform.x,
##		self.to_transform.y,
##		self.to_transform.get_rotation()
#	]
#	return str(data)


func _ready() -> void:
	if target_path:
		target = get_node(target_path)
	z_index = 1
	from = get_parent().name
#	if global_pos:
#		global_position = global_pos
#	else:
#		from_instance = get_parent().get_parent()
#		global_pos = global_position
	size += 4
	for i in size/ray_step - 1:
		points.append(Vector2(size/2 - i * ray_step, 0).rotated(rotation))
		points.append(Vector2(-size/2 + i * ray_step, 0).rotated(rotation))
	# to_transform = get_global_transform()

	# var dir = Vector2.RIGHT.rotated(transform.get_rotation())
	# Global.register(dir, from, target, points, global_pos)



#
#func try_free() -> bool:
#	var from_clear := true
#	var to_clear := true
#	if is_instance_valid(from_instance):
#		from_clear = from_instance.try_free()
#
#	if is_instance_valid(to_instance):
#		to_clear = to_instance.try_free()
#	if from_clear and to_clear:
#		queue_free()
#		return true
#	return false
