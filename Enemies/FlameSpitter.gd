extends StaticBody2D

onready var fireTimer = $FireTimer
onready var animationPlayer = $AnimationPlayer
    
func _process(_delta):
    if fireTimer.time_left == 0:
        animationPlayer.play("fire")

func _on_AnimationPlayer_animation_finished(_anim_name):
    fireTimer.start()
