class_name BulletTrail
extends Line2D

var max_points: int = 5
var bullet: Projectile

func _process(delta: float) -> void:
	if bullet != null:
		add_point(bullet.position)
		if points.size() > max_points:
			remove_point(0)
	else:
		queue_free()
