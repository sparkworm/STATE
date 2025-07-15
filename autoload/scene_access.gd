extends Node

## NOTE: Changing this enum may require a project restart, as it does not seem
## to refresh accross the whole program
enum IDX {
	MENU = -2, # makes LVL1 = 1
	CREDITS,
	TEST_LVL,
	LVL1,
	LVL2,
	LVL3,
	LVL4,
	LVL5,

}

const dict: Dictionary[IDX,PackedScene] ={
	IDX.MENU : preload("res://scenes/ui/main_menu.tscn"),
	IDX.TEST_LVL : preload("res://scenes/levels/test_level.tscn"),
}
