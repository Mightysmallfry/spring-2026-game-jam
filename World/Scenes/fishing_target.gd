extends Sprite2D


var moveDistance = 50
var moveTime = .5

func _ready() -> void:
	var direction = randi_range(-1,1)
	var targetPosition = position
	var t = create_tween()
	targetPosition.y += direction * moveDistance
	if direction != 0:
		t.tween_property(self,"position",clamp(targetPosition,Vector2(166,0), Vector2(-166,0)),moveTime)
