extends Area2D

# Inside FishingEnemy.gd
var target_node : Node2D
var target_position = Vector2.ZERO
var speed = 100

signal hit_bar()

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

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
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
