extends AudioStreamPlayer

@onready var tense_music = self.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_tree().current_scene.name == "boss1":
		self.playing = false
		if not tense_music.playing:
			tense_music.playing = true
	elif get_tree().current_scene.name != "boss1":
		tense_music.playing = false
		if not self.playing:
			self.playing = true
