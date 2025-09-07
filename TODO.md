# This is a file to keep track of what is currently being worked on.

## Core game functionality


Transitional:

- Level transitions
- Cutscene support

## Characters


Implement Enemies: 

- Create Enemy state machine
	- Guarding
	- Investigating
	- Patrolling
	- Attacking


Implement death:

- Ensure HealthComponent properly kills corresponding Character when health reaches 0
- Add Death vfx
- Add dead body textures

## Items

Add DroppedItem class/scene

- The player (and eventually AI) should be able to interact with it to remove it, adding the corresponding item to the respective inventory.
- DroppedItems should spawn at the deathplace of enemies (and the player too ig)
- The player should be able to drop one of their own weapons, creating a DroppedItem (optionally in motion)

Implement Inventory system

- Allow player to switch between items.
- Allow player to drop items.
- Allow player to pick up items.

## Visuals

### Animations

Character:

- Torso sway when walking
- Arm movement when walking # it's worth noting that this might supersede the previous

### Sprites

Weapons:

- PISTOL
	- 1911
	- USP
	- Magnum Revolver
	- Five seveN
- SMG
	- p90
	- MP5
	- UMP-45
	- Thompson SMG
- RIFLE
	- M4
	- Bolt-Action Rifle M24?
- SHOTGUN
	- Mossberg 500


Characters:

- Dead body sprites for all character types
- Main player (welding mask?)
- Police
	- SWAT
	- Local Enforcers
- Military
- Secret Service
- Politicians
- Bureaucrats


Decor:

- Furniture
	- Table
	- Chair
	- Couch
- Rugs
- Bloody Footprints


Lighting:

- Muzzle flash mask
- Ceiling lights ?


### Particles


Effect particles:

- Muzzle flash particles
- Blood spurt particles
- Particles for wall being hit by bullet

Ambient Particles:

- 