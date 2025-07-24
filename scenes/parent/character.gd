class_name Character
extends CharacterBody2D

@export var starting_item: PackedScene
@export var body: Body

@onready var item_holder: Node2D = $ItemHolder

func _ready() -> void:
	body.set_item_held(starting_item.instantiate())

func get_item_held() -> Wieldable:
	return body.get_item_held()
