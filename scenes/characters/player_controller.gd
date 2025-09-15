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
	player.face_towards(body.get_global_mouse_position())
	handle_movement(delta)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("fire"):
		var item: Wieldable = player.get_item_held()
		if item != null:
			if Input.is_action_just_pressed("fire"):
				item._start_use()
			else:
				item._continue_use()
			MessageBus.update_hud.emit()


	if Input.is_action_just_pressed("reload"):
		player.reload()

	if Input.is_action_just_pressed("pickup_item"):
		var items: Array[DroppedItem] = player.get_dropped_items_in_pickup_area()
		if items.size() > 0:
			player.drop_item()
			player.pickup_item(items[0])
	
	if Input.is_action_just_pressed("debug_button_1"):
		player.spawn_floating_text("debug 1 pressed, spawning floating text")

## Handles player movements based on user inputs
func handle_movement(delta: float) -> void:
	cpt_velocity.velocity = player.get_real_velocity()
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	cpt_velocity.resolve_decel(delta)
	cpt_velocity.accel(delta, move_dir)
	player.velocity = cpt_velocity.velocity
	player.move_and_slide()
