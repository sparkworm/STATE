class_name Camera
extends Camera2D

## The subject that will be followed by the camera
@export var subject: Node2D
## Affects how much moving the mouse affects the displacement of the camera.  A value of 0 means
## that the camera will do nothing when the mouse is moved
@export var look_strength: float

func _physics_process(delta: float) -> void:
	follow_subject()
	apply_offset()

func follow_subject() -> void:
	position = subject.position

func apply_offset() -> void:
	offset = (get_local_mouse_position()-get_screen_center_position()) * look_strength
