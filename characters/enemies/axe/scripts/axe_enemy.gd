extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
enum {
	ATTACK,
	WANDERING,
	IDLE
}

var player = CharacterBody2D
@onready var animEnemy = $Animations/AnimationPlayer
const SPEED = 60
var state = IDLE

var Axis = [Vector2.LEFT, Vector2.RIGHT]

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if state == IDLE:
		if $Directions/Zones/Timers/TimerIdle.is_stopped():
			velocity = Vector2.ZERO
			$Directions/Zones/Timers/TimerIdle.start(randi_range(0, 4))
	elif state == WANDERING:
		if $Directions/Zones/Timers/TimerWandering.is_stopped():
			$Directions/Zones/Timers/TimerWandering.start(randi_range(1, 3))
			velocity = Axis.pick_random() + SPEED
	elif state == ATTACK:
		$Directions/Zones/Timers/TimerIdle.stop()
		$Directions/Zones/Timers/TimerWandering.stop()
		var t = (player.global_position - self.global_position).normalized()
		velocity = (Vector2.LEFT if Vector2.RIGHT.dot(t) < Vector2.LEFT.dot(t) else Vector2.RIGHT) * SPEED

	check_down(velocity)
	move_and_slide()







func _on_timer_wandering_timeout() -> void:
	state = IDLE
	animEnemy.play('Idle')

func _on_timer_idle_timeout() -> void:
	state = WANDERING
	animEnemy.play('Walk')

func _on_detecte_zone_body_entered(body):
	if body is CharacterBody2D:
		player = body
		state = ATTACK


func _on_exit_zone_body_exited(body):
	if body == player:
		player = null
		state = IDLE

func check_down(vel: Vector2):
	vel = vel.normalized()
	if vel == Vector2.LEFT and !$Directions/Zones/RayCast/RayCast_L.is_colliding():
		velocity = Vector2.RIGHT * SPEED
	elif vel == Vector2.RIGHT and !$Directions/Zones/RayCast/RayCast_R.is_colliding():
		velocity = Vector2.LEFT * SPEED
