class_name BulletTrail
extends Line2D

var max_points: int = 5
## NOTE: This means that BulletTrail will only work with Bullet type projectiles.
var bullet: BulletProjectile
var has_collided: bool = false

func _ready() -> void:
	bullet.bullet_collided.connect(handle_collision)

func _process(_delta: float) -> void:
	if not has_collided:
		handle_movement()
	else:
		if points.size() > 0:
			remove_point(0)
		else:
			queue_free()

## Places a new point at the current position of the bullet
func handle_movement() -> void:
	# NOTE: the bullet should never be null
	if bullet == null:
		print("WARNING: bullet is null")
		return

	add_point(bullet.global_position)
	if points.size() > max_points:
		remove_point(0)

## Adds point to the last location of the bullet (necessary since the bullet is immediately
## deleted upon striking something)
func handle_collision(pos: Vector2) -> void:
	has_collided = true
	points[points.size()-1] = pos
