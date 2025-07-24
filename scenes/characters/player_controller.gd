class_name PlayerController
extends Node

var move_dir: Vector2

@export var player: Character
@export var body: Body
@export var cpt_velocity: VelocityComponent

func _physics_process(delta: float) -> void:
	body.head_and_torso_look_towards(body.get_global_mouse_position())
	handle_movement(delta)

	if Input.is_action_just_pressed("fire"):
		var item: Wieldable = player.get_item_held()
		if item != null:
			item._use()

func handle_movement(delta: float) -> void:
	cpt_velocity.velocity = player.get_real_velocity()
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	cpt_velocity.resolve_decel(delta)
	cpt_velocity.accel(delta, move_dir)
	player.velocity = cpt_velocity.velocity
	player.move_and_slide()
