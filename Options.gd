extends Node

var fullscreen = false setget set_fullscreen
var music_volume_db = linear2db(0.5) setget set_music_volume
var sfx_volume_db = linear2db(0.5) setget set_sfx_volume

func _ready():
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume_db)
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume_db)

func set_fullscreen(value):
    fullscreen = value
    OS.set_window_fullscreen(fullscreen)
    
func set_music_volume(value):
    music_volume_db = linear2db(value)
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume_db)

func set_sfx_volume(value):
    sfx_volume_db = linear2db(value)
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume_db)
