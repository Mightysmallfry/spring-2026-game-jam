extends Area2D

# Inside FishingEnemy.gd
var target_node : Node2D
var target_position = Vector2.ZERO
var speed = 100

signal hit_bar()

func _ready() -> void:
	input_event.connect(_on_input_event)
	area_entered.connect(_on_area_entered)

func setup_target(node : Node2D):
	if node:
		var center = node.global_position
		target_position = Vector2(randf_range(center.x - 130, center.x + 130),center.y)

	
func _physics_process(delta):
	if target_position != Vector2.ZERO:
		#This should make it so fish go to random spots on the bar
		# Calculate direction and move
		var direction = (target_position - global_position).normalized()
		global_position += direction * speed * delta
		var target_angle = direction.angle() + PI
		rotation = lerp_angle(rotation,target_angle,5.0 * delta)
		if direction.x > 0:
			$Sprite2D.flip_v = true
		else:
			$Sprite2D.flip_v = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("Fish global: ", global_position)
		print("Fish local: ", position)
		print("Mouse global: ", get_viewport().get_mouse_position())
		print("Event position: ", event.position)
		print("Event global position: ", event.global_position)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		print("Fish down")
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			on_clicked()

func on_clicked():
	speed = 0
	#do an animation or somthing
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "fish_detector":
		hit_bar.emit()
		queue_free()
