extends Area2D

export(bool) var entrance = false
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var collider = $Collider

export(Resource) var connection = null
export(String, FILE, "*.tscn") var new_level_path = ""
var active = true

func _ready():
    if entrance:
        sprite.set_frame(0)
        collider.disabled = true
    else:
        sprite.set_frame(13)


func _on_Door_body_entered(Player):
    SoundFX.play("LevelComplete", 1, -15)
    if active == true:
        Player.emit_signal("hit_door", self)
        active = false


func _on_VisibilityNotifier2D_screen_entered():
    if not entrance:
        animationPlayer.play("open")
    else:
        animationPlayer.play("close")
