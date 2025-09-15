## Class for text that will pop over the heads of characters to indicate dialogue or activity
class_name FloatingText
extends Node2D

## Extra distance upwards that the label will spawn at, with positive values being higher up
@export var y_start: float = 10

## The length of time the FloatingText will be visible
var lifetime: float = 1.0
## The distance that FloatingText will travel upwards
var distance: float = 20.0
## Text to display
var text: String


@onready var label: Label = $Label

func _ready() -> void:
	label.text = text
	## TEST: make sure this doesn't do anything retarded...perhaps add an await or something?
	call_deferred("set_text_position")

## Sets up the label so that it's actually aligned pleasently
func set_text_position() -> void:
	position.x = - scale.x * label.size.x / 2
	position.y = -y_start
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x,position.y-distance), lifetime)
	tween.tween_callback(queue_free)
