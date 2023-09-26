extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$play_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		$menu_noise.play()

func _on_quit_button_pressed():
	$quit_timer.start()

func _on_play_button_pressed():
	$play_timer.start()

func _on_play_button_focus_entered():
	$menu_noise.play()


func _on_quit_button_focus_entered():
	$menu_noise.play()


func _on_play_timer_timeout():
	get_tree().change_scene_to_file("res://levels/level1/level1.tscn")


func _on_quit_timer_timeout():
	get_tree().quit()

func _on_test_timer_timeout():
	get_tree().change_scene_to_file("res://menus/level_select/level_select.tscn")


func _on_level_button_pressed():
	$test_timer.start()


func _on_level_button_focus_entered():
	$menu_noise.play()
