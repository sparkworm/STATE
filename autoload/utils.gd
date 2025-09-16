## Technically not autoloaded, but should only contain static methods
class_name Utils
extends Node

## Returns a randomly varied value such that that returned value may lie between 
## (1.0-variation) * base_value and (1.0+variation) * base_value
static func apply_variation(base_value: Variant, variation: float) -> Variant:
	return (1.0 + randf_range(-variation, +variation)) * base_value
