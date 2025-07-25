class_name BulletProjectile
extends Projectile

@export var trail_points: int = 10
@export var bullet_trail: PackedScene

var old_position: Vector2

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
	ray_cast.target_position = old_position - position
	if ray_cast.is_colliding():
		handle_collision()

## NOTE: Will need to make sure to get the LAST of all raycast collisions since
## the raycast is being sent backwards
func handle_collision() -> void:
	var last_collider: Object = ray_cast.get_collider()
	# find the first thing the raycast would have hit (last thing it collides with would be the
	# first thing it would have hit in this case)
	while true:
		ray_cast.add_exception_rid(ray_cast.get_collider_rid())
		ray_cast.force_raycast_update()
		var new_collider: Object = ray_cast.get_collider()
		if new_collider == null:
			break
		last_collider = new_collider
	#last_collider.hit()
	queue_free()



func _on_timer_termination_timeout() -> void:
	queue_free()
