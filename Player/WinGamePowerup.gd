extends Powerup

var MainInstances = ResourceLoader.MainInstances

func _pickup():
    var player = MainInstances.Player
    SaverAndLoader.remove_save()
    player.won_game = true
