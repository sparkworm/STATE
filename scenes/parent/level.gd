class_name Level
extends GameScene

@onready var projectiles: Node2D = $Projectiles
@onready var effects: Node2D = $Effects

func _ready() -> void:
	MessageBus.projectile_spawned.connect(spawn_projectile)
	MessageBus.effect_spawned.connect(spawn_effect)
	MessageBus.debug_pixel_spawned.connect(spawn_debug_pixel)

func spawn_projectile(proj: Projectile) -> void:
	projectiles.add_child(proj)

func spawn_effect(eff: Node) -> void:
	effects.add_child(eff)

func spawn_debug_pixel(pos: Vector2) -> void:
	var pixel: Node2D = Globals.debug_pixel.instantiate()
	pixel.global_position = pos
	effects.add_child(pixel)
