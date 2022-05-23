extends Node2D

onready var animationPlayer = $AnimationPlayer


func _on_SaveArea_body_entered(_body):
    SoundFX.play("SaveGrave", 1, 0)
    animationPlayer.play("Animate")
    SaverAndLoader.save_game()
