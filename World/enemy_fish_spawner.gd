extends Marker2D

@export var target_node : Node2D
var spawn_speed : float
var enemy_speed: float = 50 #default
var enemy_scene = preload("res://enemy_fish.tscn")
@onready var enemy_container = get_node("/root/FishingGame/Enemies")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stop_spawning()
	$Timer.wait_time = spawn_speed

func start_spawning():
	$Timer.start()
func stop_spawning():
	$Timer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy_container.add_child(enemy)
	
	enemy.global_position = global_position
	enemy.setup_target(target_node)
	enemy.speed = enemy_speed
	
	#Connecting signal from enemy
	var game_node = get_node("/root/FishingGame")
	enemy.hit_bar.connect(game_node.take_damage)



func _on_timer_timeout() -> void:
	spawn_enemy()
