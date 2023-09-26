extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
