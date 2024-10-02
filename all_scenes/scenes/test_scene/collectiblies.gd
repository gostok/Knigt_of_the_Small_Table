extends Node2D


var coin_preload = preload("res://all_scenes/scenes/objects/gold/coin.tscn")

func _ready() -> void:
	Signals.connect("box_destroyed", Callable(self, "_on_box_destroyed"))
	Signals.connect("enemy_died", Callable(self, "_on_enemy_died"))

func _on_box_destroyed(box_position):
	for i in randi_range(0,6):
		coin_spawn_box(box_position)

func _on_enemy_died(enemy_position):
	for i in randi_range(2,8):
		coin_spawn_enemy(enemy_position)

func coin_spawn_box(pos):
	var coin = coin_preload.instantiate()
	coin.position = pos
	call_deferred("add_child", coin)

func coin_spawn_enemy(pos):
	var coin = coin_preload.instantiate()
	coin.position = pos
	call_deferred("add_child", coin)
