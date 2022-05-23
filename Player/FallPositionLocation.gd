extends Node2D

var MainInstances = ResourceLoader.MainInstances

onready var timer = $Timer

func _ready():
    MainInstances.FallPositionLocation = self
    timer.start()
    
func _exit_tree():
    MainInstances.FallPositionLocation = null
    
func _process(_delta):
    var player = MainInstances.Player
    if timer.time_left == 0 and player != null and player.is_on_floor() and not player.on_moving_platform:
        update_position(player.global_position)
        timer.start()

func update_position(new_position):
    global_position = new_position
