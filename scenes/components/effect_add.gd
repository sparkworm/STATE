class_name EffectAdd
extends Effect
## Effect that applies addition or subtraction to a float

@export var magnitude: float

func _apply_effect(num: float) -> float:
	return magnitude + num
