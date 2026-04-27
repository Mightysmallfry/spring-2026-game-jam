extends Marker2D

@export var target_node : Node2D
var spawn_speed : float
var enemy_speed: float = 50 #default
var enemy_scene = preload("res://World/Scenes/enemy_fish.tscn")
#@onready var enemy_container = get_node("/root/FishingGame/Enemies")
@onready var enemy_container = $"../../Enemies"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stop_spawning()
	$Timer.wait_time = spawn_speed

func start_spawning():
	var random_delay = randf_range(0.0,2.0)
	await get_tree().create_timer(random_delay).timeout
	$Timer.start()

func stop_spawning():
	$Timer.stop()
	clear_enemies()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy_container.add_child(enemy)
	
	enemy.global_position = global_position
	enemy.setup_target(target_node)
	enemy.speed = enemy_speed
	
	#Connecting signal from enemy
	var game_node = get_tree().get_first_node_in_group("GameManager")
	if game_node:
			enemy.hit_bar.connect(game_node.take_damage, CONNECT_ONE_SHOT)

func clear_enemies():
	for child in enemy_container.get_children():
		child.queue_free()

func _on_timer_timeout() -> void:
	spawn_enemy()
	$Timer.wait_time = randf_range(spawn_speed * 0.7, spawn_speed * 1)
