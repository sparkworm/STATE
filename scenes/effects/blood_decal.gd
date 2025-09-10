class_name BloodDecal
extends Sprite2D

@export_category("Color")
@export var final_color: Color = Color(0.369, 0.0, 0.0)
@export var darkening_time: float = 30
@export var color_variation: float = 0.1
@export_category("Scale")
@export var start_scale := Vector2(0.2,0.2)
@export var final_scale := Vector2(0.7,0.7)
@export var growth_time: float = 5
@export var scale_variation: float = 0.1


func _ready() -> void:
	var darken_tween: Tween = get_tree().create_tween()
	darken_tween.tween_property(self, "modulate", final_color, darkening_time)
	scale = start_scale
	var scale_tween: Tween = get_tree().create_tween()
	var end_scale: Vector2 = final_scale*randf_range(1-scale_variation, 1+scale_variation)
	scale_tween.tween_property(self, "scale", end_scale, growth_time)

## Sets the frame of the sprite to a random frame.
func pick_random_frame() -> void:
	frame = randi_range(0,num_frames()-1)

## Returns the total number of frames there are.
func num_frames() -> int:
	return vframes * hframes
