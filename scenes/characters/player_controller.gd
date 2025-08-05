class_name PlayerController
extends Node

var move_dir: Vector2

@export var player: Character
@export var body: Body
@export var cpt_velocity: VelocityComponent

func _physics_process(delta: float) -> void:
	body.head_and_torso_look_towards(body.get_global_mouse_position())
	$"../MoveCollision".rotation = body.torso.rotation
	handle_movement(delta)

	if Input.is_action_just_pressed("fire"):
		var item: Wieldable = player.get_item_held()
		if item != null:
			item._use()
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
			if weapon.mag_reloadable:
				var mag: Magazine = player.inventory.get_mag_for_reload(weapon)
				print(mag)
				weapon.mag_reload(mag)
			else:
				player.inventory.individual_ammo[weapon.ID] -= 1
				weapon.round_reload()

func handle_movement(delta: float) -> void:
	cpt_velocity.velocity = player.get_real_velocity()
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	cpt_velocity.resolve_decel(delta)
	cpt_velocity.accel(delta, move_dir)
	player.velocity = cpt_velocity.velocity
	player.move_and_slide()
