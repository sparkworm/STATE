class_name Character
extends CharacterBody2D

@export var starting_item: PackedScene
@export var body: Body

@onready var item_holder: Node2D = $ItemHolder
@onready var inventory: CharacterInventory = $Inventory
@onready var move_collision: CollisionShape2D = $MoveCollision

func _ready() -> void:
	# set starting item
	if starting_item != null:
		body.set_item_held(starting_item.instantiate())
	# For testing purposes, give a magazine for a glock
	inventory.add_mag(Globals.Weapons.GLOCK17, Magazine.new(Globals.Weapons.GLOCK17, 17))


func get_item_held() -> Wieldable:
	return body.get_item_held()

func update_move_collision() -> void:
	move_collision.rotation = body.torso.rotation

## Handles character's attempt to reload.  Returns whether reload was successful.
## NOTE: was cut from PlayerController with modifications, so we'll need to make sure nothing
## horrible happens
func reload() -> bool:
	var weapon: WieldableGun = get_item_held()
	if weapon == null:
		print("No weapon to reload")
		return false
	else:
		if not inventory.has_ammo_for_weapon(weapon):
			print("No ammo for ", weapon.item_name, " reload.")
			return false
		else:
			# mag reload
			if weapon.mag_reloadable:
				var mag: Magazine = inventory.get_mag_for_reload(weapon)
				print(mag)
				weapon.mag_reload(mag)
			# round reload
			else:
				#player.inventory.individual_ammo[weapon.ID] -= 1 # how did this even work?
				inventory.decrement_ammo(Globals.WeaponAmmo[weapon.ID])
				weapon.round_reload()
		MessageBus.update_hud.emit()
		return true
