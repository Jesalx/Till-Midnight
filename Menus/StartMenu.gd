extends Control

var PlayerStats = ResourceLoader.PlayerStats
onready var optionMenu = $OptionMenu

func _ready():
    VisualServer.set_default_clear_color(Color.black)
    Music.list_play()

func _on_StartButton_pressed():
    SoundFX.play("Click", 1, -10)
    # warning-ignore:return_value_discarded
    PlayerStats.health = PlayerStats.max_health
    PlayerStats.time = PlayerStats.default_time
    get_tree().change_scene("res://World.tscn")

func _on_LoadButton_pressed():
    SoundFX.play("Click", 1, -10)
    SaverAndLoader.is_loading = true
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://World.tscn")


func _on_QuitButton_pressed():
    get_tree().quit()


func _on_OptionButton_pressed():
    SoundFX.play("Click", 1, -10)
    optionMenu.show_and_update()


func _on_StartButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)

func _on_LoadButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)
    


func _on_OptionButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)


func _on_QuitButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)
