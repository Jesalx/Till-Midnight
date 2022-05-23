extends KinematicBody2D

const HitEffect = preload("res://Effects/HitEffect.tscn")
const DeathEffect = preload("res://Effects/DeathEffect.tscn")

onready var sprite = $Sprite
export(int) var MAX_SPEED = 15
var motion = Vector2.ZERO
var MainInstances = ResourceLoader.MainInstances 

onready var stats = $EnemyStats

func _on_Hurtbox_hit(damage):
    var player = MainInstances.Player
    var player_direction = player.global_position.x - global_position.x
    create_hit_effect(player_direction)
    SoundFX.play("EnemyHurt", 1, -10)
    stats.health -= damage

func _on_EnemyStats_enemy_died():
    Utils.instance_scene_on_main(DeathEffect, sprite.global_position)
    queue_free()

func create_hit_effect(direction):
    var position = sprite.global_position
    var hit_effect = Utils.instance_scene_on_main(HitEffect, position)
    hit_effect.scale.x = -sign(direction)
