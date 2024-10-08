extends CharacterBody2D

class_name Enemy

enum {
	CHASE, IDLE, ATTACK, DAMAGE, DEATH
}
var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE: idle_state()
			ATTACK: attack_state()
			DAMAGE: pass
			DEATH: pass

@onready var animEnemy = $Animations/AnimationPlayer
var player: CharacterBody2D

const IDLE_SPEED = 60
var Axis = [Vector2.LEFT, Vector2.RIGHT]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	randomize()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta



	move_and_slide()

func _on_attack_range_body_entered(body: Node2D) -> void:
	state = ATTACK

func idle_state():
	animEnemy.play('Walk')
	await get_tree().create_timer(1).timeout
	$Directions/AttackDirection/RangeBox/AttackRange/CollisionShape2D.disabled = false
	state = CHASE

func attack_state():
	animEnemy.play('Attack')
	await animEnemy.animation_finished
	$Directions/AttackDirection/RangeBox/AttackRange/CollisionShape2D.disabled = true
	state = IDLE


func _on_timer_chase_timeout() -> void:
	state = IDLE

func _on_timer_idle_timeout() -> void:
	state = CHASE


func _on_detecte_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group('players') and body is CharacterBody2D:
		player = body
		state = ATTACK

func _on_exit_zone_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		state = IDLE

func check_down(vel: Vector2):
	vel = vel.normalized()
	if vel == Vector2.LEFT and $Directions/Zones/RayCast/RayCast_L.is_colliding():
		velocity = Vector2.RIGHT * IDLE_SPEED
	elif vel == Vector2.RIGHT and $Directions/Zones/RayCast/RayCast_R.is_colliding():
		velocity = Vector2.LEFT * IDLE_SPEED
