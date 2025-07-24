class_name BulletProjectile
extends Projectile

@export var trail_points: int = 10
@export var bullet_trail: PackedScene

var old_position: Vector2

@onready var ray_cast: RayCast2D = $RayCast

func _ready() -> void:
	var trail: BulletTrail = bullet_trail.instantiate()
	trail.max_points = trail_points
	trail.bullet = self
	MessageBus.effect_spawned.emit(trail)

func _physics_process(delta: float) -> void:
	old_position = position
	position += delta * velocity
	ray_cast.target_position = old_position - position
	if ray_cast.is_colliding():
		handle_collision(ray_cast.get_collider())

## NOTE: Will need to make sure to get the LAST of all raycast collisions since
## the raycast is being sent backwards
func handle_collision(col: Object) -> void:
	pass
