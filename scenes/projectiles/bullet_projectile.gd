class_name BulletProjectile
extends Projectile

signal bullet_collided(pos: Vector2)

## The number of points that the Line2D representing the bullet trail will have
@export var trail_points: int = 10
## The specific trail scene to be used
@export var bullet_trail: PackedScene

var old_position: Vector2
var deactivated: bool = false

@onready var ray_cast: RayCast2D = $RayCast
@onready var termination_timer: Timer = $TimerTermination

func _ready() -> void:
	termination_timer.start()
	var trail: BulletTrail = bullet_trail.instantiate()
	trail.max_points = trail_points
	trail.bullet = self
	MessageBus.effect_spawned.emit(trail)

func _physics_process(delta: float) -> void:
	old_position = position
	position += delta * velocity
	# NOTE: technically this wouldn't be necessary at a solid framerate, since the distance
	# travelled would be about the same
	ray_cast.position = old_position - position
	ray_cast.target_position = position - old_position

	handle_collision()

# TODO: Add effect for bullet hitting certain objects
func handle_collision() -> void:
	ray_cast.force_raycast_update()
	var collider: Object = ray_cast.get_collider()
	if collider == null:
		return
	position = ray_cast.get_collision_point()
	bullet_collided.emit(global_position)
	# TODO: complete logic for transfering damage to collider
	#collider.hit()
	queue_free()

func _on_timer_termination_timeout() -> void:
	queue_free()
