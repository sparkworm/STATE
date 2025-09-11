## A resource dedicated to storing the info regarding a bullet hitting a target.
class_name BulletHitResource
extends Resource

var bullet_damage: int
## The direction the bullet was travelling in prior to hitting the target
var bullet_dir: Vector2
## The point of contact in global coordinates
var collision_point: Vector2
## The normal vector of the collision
var collision_normal: Vector2

func _init(damage: int, dir: Vector2, col_point: Vector2, col_normal: Vector2) -> void:
	bullet_damage = damage
	bullet_dir = dir
	collision_point = col_point
	collision_normal = col_normal
