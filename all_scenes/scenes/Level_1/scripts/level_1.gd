extends Node2D

@onready var player = $Player


func _on_enter_body_entered(body):
	print("Entered:", body.name)
	if body == player:
		get_tree().create_timer(1)
		$assets/top_/top_floor.visible = false

func _on_exit_body_exited(body):
	print("Exited:", body.name)
	if body == player:
		await get_tree().create_timer(1)
		$assets/top_/top_floor.visible = true
