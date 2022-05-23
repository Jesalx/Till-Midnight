extends Control

onready var optionMenu = $OptionMenu
onready var scoreLabel = $CenterContainer/VBoxContainer/ScoreLabel
var PlayerStats = ResourceLoader.PlayerStats

func _ready():
    PlayerStats.connect("player_time_changed", self, "_on_player_time_changed")
        
    
func _on_player_time_changed(value):
    scoreLabel.text = "time left: " + str(value)

func _on_OptionButton_pressed():
    SoundFX.play("Click", 1, -10)
    optionMenu.show_and_update()


func _on_QuitButton_pressed():
    get_tree().quit()


func _on_StartButton_pressed():
    SoundFX.play("Click", 1, -10)
    # warning-ignore:return_value_discarded
    get_tree().paused = false
    get_tree().change_scene("res://Menus/StartMenu.tscn")


func _on_OptionButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)


func _on_QuitButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)


func _on_StartButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)
