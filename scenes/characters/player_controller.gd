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
	$"../MoveCollision".rotation = body.torso.rotation
	handle_movement(delta)

	if Input.is_action_just_pressed("fire"):
		var item: Wieldable = player.get_item_held()
		if item != null:
			item._use()
			MessageBus.update_hud.emit()
	if Input.is_action_just_pressed("reload"):
		handle_reload()

func handle_reload() -> void:
	var weapon: WieldableGun = player.get_item_held()
	if weapon == null:
		print("No weapon to reload")
	else:
		if not player.inventory.has_ammo_for_weapon(weapon):
			print("No ammo for ", weapon.item_name, " reload.")
		else:
			# mag reload
			if weapon.mag_reloadable:
				var mag: Magazine = player.inventory.get_mag_for_reload(weapon)
				print(mag)
				weapon.mag_reload(mag)
			# round reload
			else:
				#player.inventory.individual_ammo[weapon.ID] -= 1 # how did this even work?
				player.inventory.decrement_ammo(Globals.WeaponAmmo[weapon.ID])
				weapon.round_reload()
	MessageBus.update_hud.emit()

func handle_movement(delta: float) -> void:
	cpt_velocity.velocity = player.get_real_velocity()
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	cpt_velocity.resolve_decel(delta)
	cpt_velocity.accel(delta, move_dir)
	player.velocity = cpt_velocity.velocity
	player.move_and_slide()
