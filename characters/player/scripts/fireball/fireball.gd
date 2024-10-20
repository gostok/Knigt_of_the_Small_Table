extends Area2D


@export var speed = 100
@export var damage = 40

var direction: Vector2

func _ready():
	await get_tree().create_timer(1).timeout
	queue_free()

func set_direction(fireballDirection):
	direction = fireballDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position+direction))


func _physics_process(delta):
	global_position += direction * speed * delta


func _on_body_entered(body: CharacterBody2D):
	if body.is_in_goup("enemies"):
		body.get_damage(damage)
		queue_free()
	
