extends Area2D

var MainInstances = ResourceLoader.MainInstances 
var PlayerStats = ResourceLoader.PlayerStats   

func _on_FallZone_body_entered(_body):
    var player = MainInstances.Player
    PlayerStats.health = PlayerStats.health - 1
    player.hit_fallzone()
