class_name PlayerController
extends Node

var move_dir: Vector2

@export var player: Character
@export var body: Body
@export var player_inventory: CharacterInventory
@export var cpt_velocity: VelocityComponent

func _ready() -> void:
	player_inventory.inventory_changed.connect(MessageBus.update_hud.emit)

func _physics_process(delta: float) -> void:
	body.head_and_torso_look_towards(body.get_global_mouse_position())
	## TODO: fix rotation of move collision to be more flexible.
	$"../MoveCollision".rotation = body.torso.rotation
	handle_movement(delta)
	
	var item: Wieldable = player.get_item_held()
	if item != null:
		if Input.is_action_just_pressed("fire"):
			item._start_use()
			MessageBus.update_hud.emit()
		elif Input.is_action_pressed("fire"):
			item._continue_use()
	if Input.is_action_just_pressed("reload"):
		player.reload()

func handle_movement(delta: float) -> void:
	cpt_velocity.velocity = player.get_real_velocity()
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	cpt_velocity.resolve_decel(delta)
	cpt_velocity.accel(delta, move_dir)
	player.velocity = cpt_velocity.velocity
	player.move_and_slide()
