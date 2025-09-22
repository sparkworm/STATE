## Manual implementation of avoidance.  Detects fellow bodies within the area and calculates a 
## force pointing away from neighboring bodies, inversely proportional in magnitude to the 
## distance to neighboring bodies.
class_name AvoidanceArea
extends Area2D

@export var repulsion_coefficient: float = 100.0

func calculate_repulsion() -> Vector2:
	var repulse_vector: Vector2
	for body in get_overlapping_bodies():
		if body is Character and body != get_parent():
			# set vec to the vec from body to self
			var vec := global_position - body.global_position
			# Set vec to normal vector divided by distance to body.
			vec = vec / pow(vec.length(), 2)
			repulse_vector += vec
	repulse_vector *= repulsion_coefficient
	return repulse_vector
