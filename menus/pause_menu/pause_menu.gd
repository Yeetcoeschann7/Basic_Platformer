extends Control

var is_paused = false : set = set_is_paused
var globs = preload("res://globals.gd")

func _process(_delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	if visible == true:
		$resume_button.grab_focus()


func _on_resume_button_pressed():
	$menu_noise.play()
	self.is_paused = false


func _on_quit_button_pressed():
	self.is_paused = false
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn");


func _on_resume_button_focus_entered():
	$menu_noise.play()


func _on_quit_button_focus_entered():
	$menu_noise.play()
