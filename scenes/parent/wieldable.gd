class_name Wieldable
extends Node2D

## The identifier of the Wieldable.  Used in various dictionaries in Globals to access certain
## attributes of the Wieldable.
@export var ID: Globals.Wieldables
## The name of the item for UI purposes.
@export var item_name: String = "unnamed item"

## Called when the use button is just pressed
func _start_use() -> void:
	pass

## Called when the use button is held down
func _continue_use() -> void:
	pass
