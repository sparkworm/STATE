class_name Character
extends CharacterBody2D

@export var starting_item: PackedScene
@export var body: Body

@onready var item_holder: Node2D = $ItemHolder
@onready var inventory: CharacterInventory = $Inventory

func _ready() -> void:
	# set starting item
	if starting_item != null:
		body.set_item_held(starting_item.instantiate())
	# For testing purposes, give a magazine for a glock
	inventory.add_mag(Magazine.new(Globals.Weapons.GLOCK17, 17))


func get_item_held() -> Wieldable:
	return body.get_item_held()
