class_name Level
extends GameScene

@onready var projectiles: Node2D = $Projectiles
@onready var effects: Node2D = $Effects

func _ready() -> void:
	MessageBus.projectile_spawned.connect(spawn_projectile)
	MessageBus.effect_spawned.connect(spawn_effect)

func spawn_projectile(proj: Projectile) -> void:
	print("spawning projectile")
	projectiles.add_child(proj)

func spawn_effect(eff: Node) -> void:
	print("spawning effect")
	effects.add_child(eff)
