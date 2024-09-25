extends CharacterBody2D

signal health_changed(new_health)

enum {
	MOVE, ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_4, ATTACK_AIR, SLIDE,
	ROLL, CLIMB, DEATH, HEALTH, DAMAGE
}
var state = MOVE
var gold = 0
var health 
var damage = 25
var max_health = 100
const SPEED = 100
const JUMP = -200.0
var combo = false
var attack_cooldown = false
@onready var anim = $Animation/AnimatedSprite2D
@onready var animPlayer = $Animation/AnimationPlayer

var gravity = ProjectSettings.get_setting('physics/2d/default_gravity')

func _ready() -> void:
	add_to_group('players')
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	health = max_health

func _physics_process(delta):
	match  state:
		MOVE: move_state()
		ATTACK_1: attack_1_state()
		ATTACK_2: attack_2_state()
		ATTACK_3: attack_3_state()
		ATTACK_4: attack_4_state()
		ATTACK_AIR: attack_air_state()
		SLIDE: slide_state()
		ROLL: roll_state()
		DEATH: death_state()
		DAMAGE: damage_state()
		HEALTH: pass
		CLIMB: pass

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP
		animPlayer.play('jump')
	
	if health <= 0:
		health = 0
		state = DEATH

	move_and_slide()


func move_state():
	var direction = Input.get_axis('left', 'right')
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play('run')
		if direction == -1:
			anim.flip_h = true
		elif direction == 1:
			anim.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play('Idle')
	
	if Input.is_action_pressed('roll'):
		state = ROLL
	if Input.is_action_pressed('slide'):
		state = SLIDE
	if Input.is_action_just_pressed('attack') and attack_cooldown == false:
		state = ATTACK_1
	if Input.is_action_just_pressed("attack") and not is_on_floor():
		state = ATTACK_AIR

func death_state():
	velocity.x = 0
	animPlayer.play('death')
	await anim.animation_finished
	queue_free()
	get_tree().change_scene_to_file("res://all_scenes/all_menu/main_menu/main_menu.tscn")

func slide_state():
	animPlayer.play('slide')
	if Input.is_action_just_released('slide'):
		state = MOVE

func roll_state():
	velocity.x = 0
	animPlayer.play('roll')
	if Input.is_action_just_released('roll'):
		state = MOVE

func attack_1_state():
	if Input.is_action_just_pressed('attack') and combo == true:
		state = ATTACK_2
	velocity.x = 0
	animPlayer.play('attack_1')
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE

func attack_2_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK_3
	velocity.x = 0
	animPlayer.play('attack_2')
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE

func attack_3_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK_4
	velocity.x = 0
	animPlayer.play('attack_3')
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE

func attack_4_state():
	velocity.x = 0
	animPlayer.play('attack_4')
	await animPlayer.animation_finished
	state = MOVE

func attack_air_state():
	velocity.x = 0
	animPlayer.play("attack_air")
	await animPlayer.animation_finished
	state = MOVE

func combo1():
	combo = true
	await animPlayer.animation_finished
	combo = false
func attack_freeze():
	attack_cooldown = true
	await get_tree().create_timer(0.8).timeout
	attack_cooldown = false

func damage_state():
	velocity.x = 0
	animPlayer.play('hit')
	await animPlayer.animation_finished
	state = MOVE

func _on_damage_received(enemy_damage):
	health -= enemy_damage
	if health <= 0:
		health = 0
		state = DEATH
	else:
		state = DAMAGE
	emit_signal("health_changed", health)


func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("player_attack", damage)
