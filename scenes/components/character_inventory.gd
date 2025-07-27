class_name CharacterInventory
extends Node

## Stores all wieldables held by character
@export var wieldables: Array[Wieldable]

## Stores all kinds of ammo
@export var ammo: Dictionary[Globals.AmmoTypes,int]
