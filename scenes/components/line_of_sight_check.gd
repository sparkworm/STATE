## Class for detecting whether there is line of sight from one position to another
class_name LineOfSightCheck
extends RayCast2D

## Returns whether the ray cast from origin to target hits target before anything else
func check_line_of_sight(origin: Node2D, target: Node2D) -> bool:
	global_position = origin.global_position
	target_position = target.global_position - global_position
	force_raycast_update()
	var first_hit: Node2D = get_collider()
	return first_hit == target
