extends Area2D
class_name Powerup

var PlayerStats = ResourceLoader.PlayerStats
onready var collider = $CollisionShape2D

func _pickup():
    collider.set_deferred("disabled", true)
    SoundFX.play("Powerup", 1, -10)
    
