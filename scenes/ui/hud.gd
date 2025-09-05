class_name HUD
extends CanvasLayer

@export var player: Character

@onready var item_held_label: Label = $Control/ItemHeldPanel/ItemHeldLabel

func _ready() -> void:
	MessageBus.update_hud.connect(update_item_held_panel)

## Updates HUD panel to display the most recent information on the weapon held, the amount of ammo
## therein, and the amount of ammo in inventory.
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
