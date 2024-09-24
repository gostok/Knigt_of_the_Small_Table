extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
enum {
	CHASE,
	ATTACK,
	WANDERING,
	IDLE,
	STOP
}

var state = IDLE
var damage = 20



var player = null
var player_chase = false
@onready var animEnemy = $Animations/AnimationPlayer
@onready var anim = $Animations/AnimatedSprite2D
const SPEED = 25


var Axis = [Vector2.LEFT, Vector2.RIGHT]


func _ready() -> void:
	randomize()




func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y += gravity * delta
	
	if state == IDLE:
		if $Directions/Zones/Timers/TimerIdle.is_stopped():
			velocity = Vector2.ZERO
			$Directions/Zones/Timers/TimerIdle.start(randi_range(0, 6))
	elif state == WANDERING:
		if $Directions/Zones/Timers/TimerWandering.is_stopped():
			$Directions/Zones/Timers/TimerWandering.start(randi_range(1, 5))
			velocity = Axis.pick_random() * SPEED

	elif  state == STOP:
		velocity.x = 0
		animEnemy.play("Idle")

	elif state == CHASE:
		player_chase = true
		$Directions/Zones/Timers/TimerIdle.stop()
		$Directions/Zones/Timers/TimerWandering.stop()
		if player != null:
			var t = (player.position - self.position).normalized()
			velocity = (Vector2.LEFT if Vector2.RIGHT.dot(t) < Vector2.LEFT.dot(t) else Vector2.RIGHT) * SPEED
			if $Directions/AttackDirection/RangeBox/AttackRange/CollisionShape2D.disabled == true:
				animEnemy.play("Idle")
				await get_tree().create_timer(1).timeout
				$Directions/AttackDirection/RangeBox/AttackRange/CollisionShape2D.disabled = false
			if t:
				animEnemy.play('Walk')
				if (t and !$Directions/Zones/RayCast/RayCast_L.is_colliding()) or (t and !$Directions/Zones/RayCast/RayCast_R.is_colliding()):
					animEnemy.play("Idle")
				if t.x <0:
					anim.flip_h = true
					$Directions/AttackDirection.rotation_degrees = 180
				else:
					anim.flip_h = false
					$Directions/AttackDirection.rotation_degrees = 0

	elif state == ATTACK:
		attack_state()



	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false

	check_down(velocity)
	move_and_slide()






func _on_timer_wandering_timeout() -> void:
	state = IDLE
	animEnemy.play('Idle')

func _on_timer_idle_timeout() -> void:
	animEnemy.play('Walk')
	state = WANDERING
	

func _on_detecte_zone_body_entered(body):
	player = body
	player_chase = true
	state = CHASE


func _on_exit_zone_body_exited(body):
	player = null
	player_chase = false
	state = WANDERING

func check_down(vel: Vector2):
	vel = vel.normalized()
	if vel == Vector2.LEFT and !$Directions/Zones/RayCast/RayCast_L.is_colliding():
		velocity = Vector2.RIGHT * SPEED

	elif vel == Vector2.RIGHT and !$Directions/Zones/RayCast/RayCast_R.is_colliding():
		velocity = Vector2.LEFT * SPEED




func _on_attack_range_body_entered(body: CharacterBody2D) -> void:
	state = ATTACK

func attack_state():
	velocity.x = 0 
	animEnemy.play("Attack")
	await animEnemy.animation_finished
	$Directions/AttackDirection/RangeBox/AttackRange/CollisionShape2D.disabled = true
	state = CHASE




func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage)
