extends CharacterBody2D

var gravity = ProjectSettings.get_setting('physics/2d/default_gravity')

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2(randi_range(-30,30), -60), 0.4)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = 0
	move_and_slide()

func _on_detecter_body_entered(body):
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2(0, -100), 0.4)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.6)
	await get_tree().create_timer(0.5).timeout
	queue_free()
	body.gold += 1
