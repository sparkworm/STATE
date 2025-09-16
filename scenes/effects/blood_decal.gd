class_name BloodDecal
extends Sprite2D

@export_group("Color")
## The final modulate value after darkening_time has passed
@export var final_color: Color = Color(0.369, 0.0, 0.0)
## The amount of time it takes to go from the current modulation to final_color
@export var darkening_time: float = 30
## The amount by which final_color may vary, ranging on
## [(1-variation) * base, (1+variation) * base]
@export var color_variation: float = 0.1
@export_group("Scale")
@export var start_scale := Vector2(0.2,0.2)
@export var final_scale := Vector2(0.7,0.7)
## The amount by which final_scale may vary, ranging on
## [(1-variation) * base, (1+variation) * base]
@export var scale_variation: float = 0.1
@export var growth_time: float = 5
## The amount by which growth_time may vary, ranging on
## [(1-variation) * base, (1+variation) * base]
@export var growth_time_variation: float = 0.25



func _ready() -> void:
	# create tween for changing color
	var darken_tween: Tween = get_tree().create_tween()
	# randomize color
	var true_final_color = Utils.apply_variation(final_color, color_variation)
	darken_tween.tween_property(self, "modulate", final_color, darkening_time)
	# set initial scale
	scale = start_scale
	# create tween for scaling
	var scale_tween: Tween = get_tree().create_tween()
	# randomize end_scale
	var end_scale: Vector2 = Utils.apply_variation(final_scale, scale_variation)
	# randomize growth_time
	var true_growth_time = Utils.apply_variation(growth_time, growth_time_variation)
	scale_tween.tween_property(self, "scale", end_scale, true_growth_time)\
			.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

## Sets the frame of the sprite to a random frame.
func pick_random_frame() -> void:
	frame = randi_range(0,num_frames()-1)

## Returns the total number of frames there are.
func num_frames() -> int:
	return vframes * hframes
