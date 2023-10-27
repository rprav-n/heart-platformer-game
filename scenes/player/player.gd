class_name Player

extends CharacterBody2D

const SPEED: int = 90
const ACCELERATION: int = 800
const FRICTION: int = 1000
const JUMP_SPEED: int = -270
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	

func _physics_process(delta: float):
	apply_gravity(delta)
	handle_jump()
	
	var input_axis: float = Input.get_axis("move_left", "move_right")
	
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	
	update_animation(input_axis)
	
	move_and_slide()


func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_SPEED
	else:
		if Input.is_action_just_released("jump") and velocity.y < JUMP_SPEED / 2.0:
			velocity.y = JUMP_SPEED / 2.0


func handle_acceleration(input_axis: float, delta: float):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)


func apply_friction(input_axis: float, delta: float):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)


func update_animation(input_axis: float):
	if input_axis != 0:
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

	if not is_on_floor():
		animated_sprite_2d.play("jump")
