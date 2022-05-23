extends ColorRect

var MainInstances = ResourceLoader.MainInstances
var PlayerStats = ResourceLoader.PlayerStats

onready var optionMenu = $OptionMenu

var paused = false setget set_paused

func set_paused(value):
    paused = value
    get_tree().paused = paused
    visible = paused
    SoundFX.play("Pause", 1, -15)
    if paused:
        Music.musicPlayer.set_stream_paused(true)
    else:
        Music.musicPlayer.set_stream_paused(false)
        optionMenu.hide()


func _process(_delta):
    var player = MainInstances.Player
    if Input.is_action_just_pressed("pause") and player != null:
        self.paused = not paused


func _on_QuitButton_pressed():
    get_tree().quit()


func _on_ResumeButton_pressed():
    SoundFX.play("Click", 1, -10)
    self.paused = false


func _on_RestartButton_pressed():
    SoundFX.play("Click", 1, -10)
    paused = false
    get_tree().paused = false
    visible = false
# warning-ignore:return_value_discarded
    get_tree().change_scene("res://World.tscn")
    PlayerStats.health = PlayerStats.max_health
    PlayerStats.time = PlayerStats.default_time


func _on_OptionButton_pressed():
    SoundFX.play("Click", 1, -10)
    optionMenu.show_and_update()
    


func _on_ResumeButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)


func _on_RestartButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)


func _on_OptionButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)


func _on_QuitButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)
