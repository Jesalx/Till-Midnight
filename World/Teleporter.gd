extends Node2D

var MainInstances = ResourceLoader.MainInstances 
var PlayerStats = ResourceLoader.PlayerStats 

onready var new_position = $Position2D

func _on_TeleportArea_body_entered(_body):
    SoundFX.play("Teleport", 1, -10)
    var player = MainInstances.Player
    player.teleport(new_position.global_position)
