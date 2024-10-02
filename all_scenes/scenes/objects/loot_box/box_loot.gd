extends CharacterBody2D


@onready var player = get_parent().find_child('Player')

var health = 1

func _ready() -> void:
	Signals.connect('player_hit', Callable(self, '_on_damage'))

func _on_damage(player_dam):
	health -= player_dam
	if health <= 0:
		health = 0
		var tween = get_tree().create_tween()
		Signals.emit_signal("box_destroyed", position)
		tween.tween_property(self, "modulate:a", 0, 0.4)
		tween.tween_callback(queue_free)
