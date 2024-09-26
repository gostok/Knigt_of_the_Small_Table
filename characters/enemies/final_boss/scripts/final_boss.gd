extends CharacterBody2D

@onready var player = get_parent().find_child('Player')
@onready var sprite = $Animations/AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar

var direction: Vector2
var DEF = 0

var health = 200:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child('FiniteStateMachine').change_state('Death')
		elif value <= progress_bar.max_value / 2 and DEF == 0:
			DEF = 5
			find_child('FiniteStateMachine').change_state('ArmorBuff')

func _ready():
	set_physics_process(false)
	Signals.connect("player_attack", Callable(self, "_on_damage_received"))

func _on_player_created(player_instance):
	player = player_instance

func _process(_delta):

	direction = player.position - self.position
	
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)

func _on_damage_received(player_damage):
	health -= player_damage - DEF
