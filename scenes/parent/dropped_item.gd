## Class for Wieldable items that are on the ground and can be picked up.  Will be overwritten
## in a unique scene for each Wieldable
class_name DroppedItem
extends RigidBody2D

## The scene that this DroppedItem should load into its new wielder's hand when picked up
@export var wieldable_scene: PackedScene

## TODO: Add ItemPickupArea that can detect dropped items and initiate a pickup

func _ready() -> void:
	if wieldable_scene == null:
		print("WARNING, DroppedItem with null wieldable_scene!")
