extends Resource
class_name PlayerStats

var max_health = 5
var default_time = 600
var health = max_health setget set_health
var time = default_time setget set_time

signal player_health_changed(value)
signal player_time_changed(value)
signal player_died

func set_health(value):
    if value < health:
        Events.emit_signal("add_screenshake", 0.5, 0.5)
    health = clamp(value, 0, max_health)
    SaverAndLoader.custom_data.health_value = health
    emit_signal("player_health_changed", health)
    if health == 0:
        emit_signal("player_died")

func set_time(value):
    time = clamp(value, 0, default_time + 120) # Player can't have more than 11 minutes in the 'bank'
    emit_signal("player_time_changed", time)
    SaverAndLoader.custom_data.time_value = time
    if time == 0:
        self.health = 0
        emit_signal("player_died")
