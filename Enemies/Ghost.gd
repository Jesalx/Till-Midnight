extends "res://Enemies/Enemy.gd"

# TODO: Make it so that if the ghost is within a certain distance to the player the ghost becomes visible

export (int) var ACCELERATION = 100

var isVisible = true
var nearPlayer = false

onready var animationPlayer = $AnimationPlayer
onready var visibilityTimer = $VisibilityTimer

func _ready():
    set_physics_process(false)

func _physics_process(delta):
    var player = MainInstances.Player
    if player != null:
        chase_player(delta, player)
        
func chase_player(delta, player):
    var direction = ((player.global_position + Vector2(0, -13)) - global_position).normalized()
    var playerDirection = player.sprite.scale.x
    if sign(direction.x) == sign(playerDirection) and isVisible and visibilityTimer.time_left == 0 and not nearPlayer:
        visibilityTimer.start()
        animationPlayer.play("Fade Out")
        isVisible = false   
    elif sign(direction.x) != sign(playerDirection) and not nearPlayer:
        if !isVisible:
            visibilityTimer.start()
            animationPlayer.play("Fade In")
            isVisible = true
        else:
            visibilityTimer.start()
    elif nearPlayer and !isVisible:
        visibilityTimer.start()
        animationPlayer.play("Fade In")
        isVisible = true
        
    motion += direction * ACCELERATION * delta
    motion = motion.clamped(MAX_SPEED)
    sprite.flip_h = global_position > player.global_position
    motion = move_and_slide(motion)


func _on_VisibilityNotifier2D_screen_entered():
    set_physics_process(true)
    visibilityTimer.start()


func _on_PlayerChecker_area_entered(_area):
    nearPlayer = true


func _on_PlayerChecker_area_exited(_area):
    nearPlayer = false
