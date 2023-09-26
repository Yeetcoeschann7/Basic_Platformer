extends TileMap

var spawn = [0, 0]
var speed = 175

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn = self.position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().get_first_node_in_group("player").reset == true:
		self.position.x = spawn
	else:
		self.position.x += delta * speed
