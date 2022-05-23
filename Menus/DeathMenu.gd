extends ColorRect

onready var optionMenu = $OptionMenu

var MainInstances = ResourceLoader.MainInstances
var PlayerStats = ResourceLoader.PlayerStats
    

func _on_QuitButton_pressed():
    get_tree().quit()


func _on_ContinueButton_pressed():
    SoundFX.play("Click", 1, -10)
    Music.musicPlayer.set_stream_paused(false)
    SaverAndLoader.is_loading = true
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://World.tscn")


func _on_OptionButton_pressed():
    SoundFX.play("Click", 1, -10)
    optionMenu.show_and_update()


func _on_RestartButton_pressed():
# warning-ignore:return_value_discarded
    SoundFX.play("Click", 1, -10)
    Music.musicPlayer.set_stream_paused(false)
    get_tree().change_scene("res://World.tscn")
    PlayerStats.health = PlayerStats.max_health
    PlayerStats.time = PlayerStats.default_time


func _on_ContinueButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)


func _on_RestartButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)


func _on_OptionButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)


func _on_QuitButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)
