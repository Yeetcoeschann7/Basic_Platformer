extends Node2D

var entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$portal_area/ColorRect.visible = false

func _process(_delta):
	if entered == true:
		if Input.is_action_just_pressed("up"):
			get_tree().change_scene_to_file("res://levels/test_levels/test_level1.tscn")

func _on_portal_area_body_entered(body):
	if body.name == "player":
		$portal_area/ColorRect.visible = true
		entered = true

func _on_portal_area_body_exited(body):
	if body.name == "player":
		$portal_area/ColorRect.visible = false
		entered = false
