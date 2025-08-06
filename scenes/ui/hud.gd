class_name HUD
extends CanvasLayer

@export var player: Character

@onready var item_held_label: Label = $Control/ItemHeldPanel/ItemHeldLabel

func _ready() -> void:
	MessageBus.update_hud.connect(update_item_held_panel)

func update_item_held_panel() -> void:
	print("updating item held")
	var txt: String = ""
	var item_held: Wieldable = player.get_item_held()
	# if no item held, say so
	if item_held == null:
		txt = "No item held"
	# if item held is gun, display ammo
	elif item_held is WieldableGun:
		item_held = item_held as WieldableGun
		if item_held.mag_reloadable:
			txt = "Weapon held: %s\nAmmo in mag: %s\nTotal mags: %s" % [
					item_held.item_name,
					item_held.cpt_ammo.ammo,
					player.inventory.mag_count(item_held.ID),
					]
		else:
			txt = "Weapon held: %s\nAmmo in weapon: %s\nTotal ammo: %s" % [
					item_held.item_name,
					item_held.cpt_ammo.ammo,
					player.inindividual_ammo_count(Globals.WeaponAmmo[item_held.ID]),
					]

	item_held_label.text = txt

'''func _ready() -> void:
	MessageBus.player_item_changed.connect(update_player_item)
	MessageBus.player_health_changed.connect(update_player_health) #TODO
	MessageBus.player_inventory_changed.connect(update_player_inventory)

## TODO: remove argument, as there is now reference to player
func update_player_item(new_item: Wieldable) -> void:
	var item_name: String = new_item.item_name
	item_held_label.text = "Item held: %s" % [item_name]

## TODO: remove argument, as there is now reference to player
func update_player_health(new_health: float) -> void:
	pass

## Currently retarded
## TODO: remove argument, as there is now reference to player
func update_player_inventory(inventory: CharacterInventory) -> void:
	pass
'''
