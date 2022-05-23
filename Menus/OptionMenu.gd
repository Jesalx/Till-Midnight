extends Control

onready var fullscreenCheckbox = $CenterContainer/VBoxContainer/Fullscreen/CheckBox
onready var musicSlider = $CenterContainer/VBoxContainer/Music/CenterContainer/MusicSlider
onready var sfxSlider = $CenterContainer/VBoxContainer/SFX/CenterContainer/SFXSlider

func _process(_delta):
    pass

func show_and_update():
    self.show()
    fullscreenCheckbox.pressed = Options.fullscreen
    musicSlider.value = db2linear(Options.music_volume_db)
    sfxSlider.value = db2linear(Options.sfx_volume_db)

func _ready():
    pass
    #fullscreenCheckbox.pressed = Options.fullscreen
    #musicSlider.value = db2linear(Options.music_volume_db)
    #sfxSlider.value = db2linear(Options.sfx_volume_db)

func _on_BackButton_pressed():
    SoundFX.play("Click", 1, -10)
    self.hide()


func _on_BackButton_mouse_entered():
    SoundFX.play("Hover", 1, -15)


func _on_CheckBox_toggled(button_pressed):
    if button_pressed:
        Options.fullscreen = true
    else:
        Options.fullscreen = false

func _on_MusicSlider_value_changed(value):
    Options.music_volume_db = value


func _on_SFXSlider_value_changed(value):
    Options.sfx_volume_db = value
