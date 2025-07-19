class_name EffectMult
extends Effect
## Effect that applies multiplication or division to a float

@export var magnitude: float

func _apply_effect(num: float) -> float:
	return magnitude * num
