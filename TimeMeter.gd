extends Control

var PlayerStats = ResourceLoader.PlayerStats

onready var label = $HBoxContainer/Label

func _ready():
    PlayerStats.connect("player_time_changed", self, "_on_player_time_changed")
    
func _on_player_time_changed(value):
    label.text = str(value)
