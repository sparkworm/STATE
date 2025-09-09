class_name BulletProjectile
extends Projectile

## Alerts bullet trail that the bullet has collided.  May eventually also be used to trigger
## bullet collided particles.
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
	# start the timer that will prevent the bullet from flying infinitely
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

	test_for_collision()

## Emits bullet_collided and kills projectile.
## TODO: Call hit on any collider collided with (if possible)
## TODO: Add effect for bullet hitting certain objects
func test_for_collision() -> void:
	ray_cast.force_raycast_update()
	var collider: Object = ray_cast.get_collider()
	if collider == null:
		return
	collide()

## Handle a collision if it has occured.
func collide() -> void:
	position = ray_cast.get_collision_point()
	bullet_collided.emit(global_position)
	# TODO: complete logic for transfering damage to collider
	var collider: Object = ray_cast.get_collider()
	if collider.has_method("take_hit"):
		collider.take_hit(damage)
	queue_free()

## Called when the termination timer reaches zero, killing the bullet
func _on_timer_termination_timeout() -> void:
	queue_free()
