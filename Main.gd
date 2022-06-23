extends Node


func _ready() -> void:
	Global.level = $Level
	Global.segments = $Segments


func _physics_process(_delta: float) -> void:
	$Segments.position = $Level.get_viewport_rect().end + (Vector2.ONE * 100000)
