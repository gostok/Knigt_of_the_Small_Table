extends Area2D

var speed = 25

func _physics_process(delta):
	position += transform.x * speed


func _on_area_entered(area):
	if area.name == "HurtBox":
		queue_free()
