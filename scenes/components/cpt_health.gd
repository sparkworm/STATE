## Component for keeping track of a character's health.
class_name HealthComponent
extends Node

signal health_depleted

## The health capacity—cannot be exceeded.
@export var max_health: float = 100
## Current amount of health.  Cannot exceed max_health
@export var health: float = 100

## Reduces health by a set ammount and emits health_depleted if health drops below 0
func take_damage(damage: float) -> void:
	if damage < 0:
		print("WARNING: negative amount of damage dealt")
		return
	health -= damage
	if health < 0:
		health_depleted.emit()

## Heals by heal_amnt, but does not exceed max_health.  Returns the amount healed by.
func heal(heal_amnt: float) -> float:
	var old_health := health
	health = min(max_health, health + heal_amnt)
	return health-old_health
