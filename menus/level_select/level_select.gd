extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$GridContainer/level_1.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn");


func _button_focus_entered():
	$menu_noise.play()


func _on_test_level_pressed():
	get_tree().change_scene_to_file("res://levels/test_levels/test_level1.tscn");

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://levels/level1/level1.tscn");

func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://levels/level2/level2.tscn");

func _on_level_3_pressed():
	get_tree().change_scene_to_file("res://levels/level3/level3.tscn");

func _on_level_4_pressed():
	get_tree().change_scene_to_file("res://levels/level4/level4.tscn");

func _on_level_5_pressed():
	get_tree().change_scene_to_file("res://levels/level5/level5.tscn");
