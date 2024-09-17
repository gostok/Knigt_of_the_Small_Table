extends CharacterBody2D

enum {
	IDLE,
	WANDERING
	
}
var state = IDLE

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animEnemy = $Animations/AnimationPlayer
@onready var anim = $Animations/AnimatedSprite2D
const SPEED = 25
var is_moving_left = true
var Axis = [Vector2.LEFT, Vector2.RIGHT]


func _ready() -> void:
	animEnemy.play('Walk')
	randomize()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if state == IDLE:
		if $Timers/TimerIdle.is_stopped():
			velocity = Vector2.ZERO
			$Timers/TimerIdle.start(randi_range(0, 6))
	elif state == WANDERING:
		if $Timers/TimerWandering.is_stopped():
			$Timers/TimerWandering.start(randi_range(1, 5))
			velocity = Axis.pick_random() * SPEED
			
	if velocity == Vector2.ZERO:
		animEnemy.play("Idle")
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false
	
	move_and_slide()



	
func defect_turn_around():
	if not $RayCast/RayCast_R.is_colliding() or $RayCast/RayCast_L.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left


func _on_timer_wandering_timeout() -> void:
	state = IDLE
	animEnemy.play('Idle')


func _on_timer_idle_timeout() -> void:
	animEnemy.play('Walk')
	state = WANDERING
	
