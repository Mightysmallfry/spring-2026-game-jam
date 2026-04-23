extends Node2D

var dificulty : int
var spawn_time : float = 2.0
var enemy_fish_speed : float = 50
var bar_length : float
var spawner_count : int = 0
var active_spawners = []
var inactive_spawners = [0,1,2,3]
var speed_mult : float = 1
@onready var spawners = get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _set_difficualty(difficualty : int):

	match difficualty:
		0:
			bar_length = 1.0
			spawner_count = 0
			spawn_time = 2.0
			enemy_fish_speed = 50
			speed_mult = 1
		1:
			bar_length = .95
			speed_mult = 0.9
			spawner_count = 0
			spawn_time = 2.0
			enemy_fish_speed = 50
		2:
			bar_length = 0.9
			speed_mult = 0.8
			enemy_fish_speed = 100
			spawn_time = 4.0
			spawner_count = 1
		3:
			bar_length = 0.8
			speed_mult = 0.7
			enemy_fish_speed = 200
			spawn_time = 1.5
			spawner_count = 2
		4:
			bar_length = 0.7
			speed_mult = 0.6
			enemy_fish_speed = 300
			spawn_time = 1.5
			spawner_count = 3
		5:
			bar_length = 0.6
			speed_mult = 0.5
			enemy_fish_speed = 400
			spawn_time = 1.5
			spawner_count = 4
			

func _choose_random_spawners():
	for i in range(spawner_count):
		if inactive_spawners.size() > 0:
			var chosen = inactive_spawners.pick_random()
			inactive_spawners.erase(chosen)
			active_spawners.append(chosen)

func start_spawners():
	_choose_random_spawners()
	for i in active_spawners:
		var spawner = spawners[i]
		spawner.spawn_speed = spawn_time
		spawner.enemy_speed = enemy_fish_speed
		spawner.start_spawning()

func stop_spawners():
	for i in active_spawners:
		var spawner = spawners[i]
		spawner.stop_spawning()


func _on_fishing_game_fish_caught(fish: FishData) -> void:
	_set_difficualty(fish.fishRarity)
	%Fishing_target.speed_multiplier = speed_mult
	start_spawners()
