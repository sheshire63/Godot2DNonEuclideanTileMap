extends Area2D


class_name Segment


var has_player := false


func _ready() -> void:
	if Engine.editor_hint:
		return
	if connect("body_entered", self, "_on_body_entered") != OK:
		printerr("Failed to connect body_entered event")
	if connect("body_exited", self, "_on_body_exited") != OK:
		printerr("Failed to connect body_exited event")
	


func _on_body_entered(_body:Node) -> void:
	has_player = true


func _on_body_exited(_body:Node) -> void:
	has_player = false


func try_free() -> bool:
	if !has_player:
		#todo check all triggers
		get_parent().remove_child(self)
		queue_free()
		return true
	return false


