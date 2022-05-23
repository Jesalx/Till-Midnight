extends Powerup

onready var animationPlayer = $AnimationPlayer

func _pickup():
    ._pickup()
    PlayerStats.health = PlayerStats.health + 1
    animationPlayer.play("Fade Out")
    yield(animationPlayer, "animation_finished")
    queue_free()
