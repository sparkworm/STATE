# This is a file to keep track of what is currently being worked on.

## Core game functionality

- Level transitions
- Cutscene support

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

## Sprites

Weapons
- 

Characters
- Dead body sprites for all character types
- Main player (welding mask?)
- Police
	- SWAT
	- Local Enforcers
- Military
- Secret Service
- Politicians
- Bureaucrats

Decor
- Furniture
	- Table
	- Chair
	- Couch
- Rugs
- Bloody Footprints

Lighting
- Muzzle flash mask
- Ceiling lights ?

Particles
- Muzzle flash particles
- Blood spurt particles
- Particles for wall being hit by bullet
