extends Powerup

onready var animationPlayer = $AnimationPlayer

func _pickup():
    ._pickup()
    PlayerStats.time += 20
    animationPlayer.play("Fade Out")
    yield(animationPlayer, "animation_finished")
    queue_free()
