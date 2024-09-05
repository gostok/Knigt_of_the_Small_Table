extends CharacterBody2D

enum {
	MOVE, ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_4, ATTACK_AIR, SLIDE,
	ROLL, CLIMB, DEATH, HEALTH
}
var state = MOVE
var gold = 0
var health = 100
const SPEED = 40
const JUMP = -300.0
@onready var anim = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting('physics/2d/default_gravity')

func _ready() -> void:
	anim.play('Idle')

func _physics_process(delta):
	match  state:
		MOVE: move_state()
		ATTACK_1: pass
		ATTACK_2: pass
		ATTACK_3: pass
		ATTACK_4: pass
		ATTACK_AIR: pass
		SLIDE: pass
		ROLL: pass
		DEATH: death_state()
		HEALTH: pass
		CLIMB: pass

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP
		anim.play('jump')

	move_and_slide()


func move_state():
	var direction = Input.get_axis('ui_left', 'ui_right')
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
		anim.play('Idle')

func death_state():
	if health <= 0:
		health = 0
		anim.play('death')
		await anim.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://all_scenes/all_menu/main_menu/main_menu.tscn")

func slide_state():
	pass

func roll_state():
	pass
