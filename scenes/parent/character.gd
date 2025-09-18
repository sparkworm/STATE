class_name Character
extends CharacterBody2D

## The name of the character, typically a role (e.g. Police Officer, or Test Dummy)
@export var character_name: String = "Unnamed Character"
## The item that the character will start with in their hands.  Useful for NPCs who should
## spawn with a weapon
@export var starting_item: PackedScene
## The force, or more precisely, the impulse, applied to an item when dropped.
@export var item_drop_force: float
## The scene that will be spawned when Character is hit.
@export var blood_decal_scene: PackedScene = preload("res://scenes/effects/blood_decal.tscn")

## The inventory of the character, which contains all ammo
@onready var inventory: CharacterInventory = $Inventory
## The collision shape of the player.  This is rotated manually, though I can't remember why.
@onready var move_collision: CollisionShape2D = $MoveCollision
## The area in which the player may pickup DroppedItems
@onready var pickup_area: Area2D = %PickupArea
## The component keeping track of the Character's health
@onready var cpt_health: HealthComponent = %CptHealth
## Manages spawning the blood decals
@onready var decal_spawner: DecalSpawner = $DecalSpawner
## The visible body of the character, which controls the head, torso, arms and legs sprites.
## [br][br]
## The body also controls the rotation of the held item.
@onready var body: Body = %Body

func _ready() -> void:
	# set starting item
	if starting_item != null:
		body.set_item_held(starting_item.instantiate())

	cpt_health.health_depleted.connect(die)

	# DEBUG
	# For testing purposes, give a magazine for a glock
	inventory.add_mag(Globals.Wieldables.GLOCK17, Magazine.new(Globals.Wieldables.GLOCK17, 17))
	inventory.add_mag(Globals.Wieldables.GLOCK17, Magazine.new(Globals.Wieldables.GLOCK17, 17))

## Returns the item currently held
func get_item_held() -> Wieldable:
	return body.get_item_held()

## Sets the item currently held to the new_item
## TODO: Drop old item instead of merely deleting it.
func set_item_held(new_item: Wieldable) -> void:
	body.set_item_held(new_item)

## Makes the head and boddy face dir, which should be in global coords
func face_towards(dir: Vector2) -> void:
	body.head_and_torso_look_towards(dir)
	update_move_collision()

## Moves the CollisionShape to match the rotation of the torso sprite
func update_move_collision() -> void:
	move_collision.rotation = body.torso.rotation

## Handles character's attempt to reload.  Returns whether reload was successful.
## NOTE: was cut from PlayerController with modifications, so we'll need to make sure nothing
## horrible happens
func reload() -> bool:
	var weapon: WieldableGun = get_item_held()
	if weapon == null:
		print("No weapon to reload")
		return false
	if not weapon.can_reload():
		print("weapon still on cooldown")
		return false
	else:
		if not inventory.has_ammo_for_weapon(weapon):
			print("No ammo for ", weapon.item_name, " reload.")
			return false
		else:
			# spawn text above head for duration of reload indicating that a reload is occuring
			spawn_floating_text("reloading...", weapon.reload_timer.wait_time)
			# mag reload
			if weapon.mag_reloadable:
				var mag: Magazine = inventory.get_mag_for_reload(weapon)
				#print(mag)
				weapon.mag_reload(mag)
			# round reload
			else:
				#player.inventory.individual_ammo[weapon.ID] -= 1 # how did this even work?
				inventory.decrement_ammo(Globals.WeaponAmmo[weapon.ID])
				weapon.round_reload()
		## TODO: fix this so that NPCs reloading don't fuck up the HUD
		MessageBus.update_hud.emit()
		return true

## Returns an array of all the DroppedItems in the pickup area
func get_dropped_items_in_pickup_area() -> Array[DroppedItem]:
	var dropped_items: Array[DroppedItem]
	for item in pickup_area.get_overlapping_bodies():
		if item is DroppedItem:
			dropped_items.append(item)
	return dropped_items

## Adds an item from the specified DroppedItem to hand.
## [br][br]
## NOTE: This makes no use of the pickup_area, so its name may be misleading
func pickup_item(item: DroppedItem) -> void:
	var new_item: Wieldable = item.create_wieldable()
	set_item_held(new_item)
	MessageBus.update_hud.emit()
	item.queue_free()

## Creates a DroppedItem for Level to spawn, then deletes the currently held item.
func drop_item() -> void:
	var item: Wieldable = get_item_held()
	if item == null:
		return
	var new_dropped_item: DroppedItem = Globals.DroppedItemScene[item.ID].instantiate()
	if item is WieldableGun:
		new_dropped_item.wieldable_ammo = item.cpt_ammo.ammo
	# ensure that item will spawn with ammo it had previously once picked up again
	new_dropped_item.spawn_with_full_ammo = false
	new_dropped_item.position = position
	new_dropped_item.rotation = randf_range(0,2*PI)
	# push the item, as if it were "dropped"
	new_dropped_item.apply_impulse(Vector2.from_angle(body.torso.rotation)*item_drop_force)
	# spawn item in level
	MessageBus.dropped_item_spawned.emit(new_dropped_item)
	# clear item from hand
	set_item_held(null)

func take_hit(hit_data: BulletHitResource) -> void:
	var damage: float = hit_data.bullet_damage
	var direction := hit_data.bullet_dir
	#print(character_name, " took ", damage, " damage!")
	cpt_health.take_damage(damage)
	if direction == Vector2.ZERO:
		direction = Vector2.from_angle(randf_range(0,2*PI))
	decal_spawner.spawn_decals(direction)

	# TEMPORARY
	var point := hit_data.collision_point
	var spurt_particles: GPUParticles2D = \
			preload("res://scenes/effects/blood_spurt_particles.tscn").instantiate()
	spurt_particles.position = point
	#spurt_particles.rotation = (-direction).angle()
	spurt_particles.rotation = hit_data.collision_normal.angle()
	MessageBus.temporary_particles_spawned.emit(spurt_particles)

## Spawns a floating text above character to indicate an action such as reloading or dialogue
func spawn_floating_text(message: String, custom_time:=-1.0) -> void:
	var new_text: Node2D = preload("res://scenes/ui/floating_text.tscn").instantiate()
	new_text.text = message
	if custom_time != -1.0:
		new_text.lifetime = custom_time
	add_child(new_text)

## Handles death of Character before finally calling queue_free()
func die() -> void:
	drop_item()
	queue_free()
