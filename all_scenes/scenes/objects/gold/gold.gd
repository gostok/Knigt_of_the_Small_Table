extends Area2D
@onready var player = get_parent().find_child('Player')
@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	anim.play("gold")

func _on_body_entered(body):
	if body == player:
		var tween = get_tree().create_tween()
		var tween_2 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 25), 0.4)
		tween_2.tween_property(self, "modulate:a", 0, 0.4)
		tween.tween_callback(queue_free)
		body.gold += 1
		
