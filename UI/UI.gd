extends CanvasLayer

var MainInstances = ResourceLoader.MainInstances

onready var deathWaitTimer = $DeathWaitTimer
onready var musicWaitTimer = $MusicWaitTimer
onready var healthMeter = $VBoxContainer/HealthMeter
onready var timeMeter = $VBoxContainer/TimeMeter
onready var winMenu = $WinMenu

func _process(_delta):
    var player = MainInstances.Player
    if player == null and deathWaitTimer.is_stopped():
        deathWaitTimer.start()
        musicWaitTimer.start()
    elif player != null and player.won_game:
        get_tree().paused = true
        timeMeter.hide()
        healthMeter.hide()
        winMenu.show()
        


func _on_DeathWaitTimer_timeout():
# warning-ignore:return_value_discarded
    get_tree().change_scene("res://Menus/DeathMenu.tscn")


func _on_MusicWaitTimer_timeout():
    Music.musicPlayer.set_stream_paused(true)
    SoundFX.play("GameOver", 1, -20)
