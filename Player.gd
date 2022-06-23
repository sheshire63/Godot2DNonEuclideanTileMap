extends KinematicBody2D


const UNIT_SIZE = 128.0

export var max_speed := 2.0
export var ray_step := 128.0

var points = []
var last_triggered = []

func _ready() -> void:
	Global.player = self
	# get_ray_points()


func _physics_process(delta: float) -> void:
	var col = move_and_collide(_get_input_direction() * max_speed * UNIT_SIZE * delta)
	if col:
		pass


func _get_input_direction() -> Vector2:
	var dir = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		dir.x = -1
	if Input.is_action_pressed("move_right"):
		dir.x = 1
	if Input.is_action_pressed("move_up"):
		dir.y = -1
	if Input.is_action_pressed("move_down"):
		dir.y = 1
	return dir.normalized()


# func add_ray_shapes() -> void:
# 	var screen = get_viewport_rect().size
# 	for y in int(screen.y / ray_step):
# 		var target = Vector2(screen.x, (y + 1)  * ray_step)
# 		for i in [Vector2(1,1), Vector2(1,-1), Vector2(-1,1), Vector2(-1,-1)]:
# 			var ray = RayShape2D.new()
# 			ray.length = target.length()
# 			var shape = CollisionShape2D.new()
# 			shape.rotation = (target * i).angle() + PI/2
# 			shape.shape = ray
# 			vision.add_child(shape)
# 	for x in int(screen.x / ray_step):
# 		var target = Vector2((x + 1) * ray_step, screen.y)
# 		for i in [Vector2(1,1), Vector2(1,-1), Vector2(-1,1), Vector2(-1,-1)]:
# 			var ray = RayShape2D.new()
# 			ray.length = target.length()
# 			var shape = CollisionShape2D.new()
# 			shape.rotation = (target * i).angle() + PI/2
# 			shape.shape = ray
# 			vision.add_child(shape)


func get_ray_points() -> void:
	var screen = get_viewport_rect().size
	for i in [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]:
		points.append(screen * i)
	for y in int(screen.y / ray_step):
		var target = Vector2(screen.x, (y + 1) * ray_step)
		for i in [Vector2(1,1), Vector2(1,-1), Vector2(-1,1), Vector2(-1,-1)]:
			points.append(target * i)
	for x in int(screen.x / ray_step):
		var target = Vector2((x + 1) * ray_step, screen.y)
		for i in [Vector2(1,1), Vector2(1,-1), Vector2(-1,1), Vector2(-1,-1)]:
			points.append(target * i)

#ray shape propably does not stop at walls

#so raycasts2D or manual rays?
	#both would require to be called every frame
	#except if we keep the current system and just confirm it with a ray
		# this might not work if it does not count as entering if we move


# func _on_Vision_area_entered(area:Area2D) -> void:
# 	if area.has_method("trigger"):
# 		if is_facing_player(area):
# 			area.trigger()


# func _on_Vision_area_exited(area:Area2D) -> void:
# 	if area.has_method("untrigger"):
# 		area.untrigger()
	

