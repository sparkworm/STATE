# This is a file to keep track of what is currently being worked on.

## Core game functionality

## Characters

Implement Enemies
- Create Enemy state machine
	- Guarding
	- Investigating
	- Patrolling
	- Attacking

Implement death
- Ensure HealthComponent properly kills corresponding Character when health reaches 0
- Add Death vfx
- Add dead body textures

## Items

Add DroppedItem class/scene
- The player (and eventually AI) should be able to interact with it to remove it, adding the 
corresponding item to the respective inventory.
- DroppedItems should spawn at the deathplace of enemies (and the player too ig)
- The player should be able to drop one of their own weapons, creating a DroppedItem (optionally in
motion)

Implement Inventory system
- Allow player to switch between items.
- Allow player to drop items.
- Allow player to pick up items.
