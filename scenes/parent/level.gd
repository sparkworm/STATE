class_name Level
extends GameScene

@onready var projectiles: Node2D = $Projectiles
@onready var effects: Node2D = $Effects
@onready var dropped_items: Node2D = $DroppedItems
@onready var decals: Node2D = $Decals

func _ready() -> void:
	MessageBus.projectile_spawned.connect(spawn_projectile)
	MessageBus.effect_spawned.connect(spawn_effect)
	MessageBus.debug_pixel_spawned.connect(spawn_debug_pixel)
	MessageBus.dropped_item_spawned.connect(spawn_dropped_item)
	MessageBus.decal_spawned.connect(spawn_decal)

## Adds specified projectile as a child of projectiles
func spawn_projectile(proj: Projectile) -> void:
	projectiles.add_child(proj)

## Adds specified effect as a child of effects
func spawn_effect(eff: Node) -> void:
	effects.add_child(eff)

## Creates a singular white pixel for debugging purposes.
func spawn_debug_pixel(pos: Vector2) -> void:
	var pixel: Node2D = Globals.debug_pixel.instantiate()
	pixel.global_position = pos
	effects.add_child(pixel)

## Spawns the specified DroppedItem in dropped_items
func spawn_dropped_item(dropped_item: DroppedItem) -> void:
	dropped_items.add_child(dropped_item)

## Spawns the specified Node2D in decals
func spawn_decal(decal: Node2D) -> void:
	decals.add_child(decal)
