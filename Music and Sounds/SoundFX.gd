extends Node

var sounds_path = "res://Music and Sounds/"

var sounds = {
    "Click" : load(sounds_path + "MenuButtonClick.wav"), # TM
    "Hover" : load(sounds_path + "MenuButtonHover.wav"), # TM
    "PlayerAttack" : load(sounds_path + "SwordSwing.wav"),
    "PlayerHurt" : load(sounds_path + "PlayerDamage.wav"),
    "EnemyDie" : load(sounds_path + "EnemyDeath.wav"), # TM
    "EnemyHurt" : load(sounds_path + "EnemyDamage.wav"), # TM
    "Jump" : load(sounds_path + "Jump.wav"), # TM
    "Pause" : load(sounds_path + "Pause.wav"), # TM
    "Powerup" : load(sounds_path + "Powerup.wav"), # TM
    "Step" : load(sounds_path + "Footsteps.wav"), # TM
    "SkeletonPunch" : load(sounds_path + "SkeletonPunch.wav"),
    "LevelComplete" : load(sounds_path + "NextLevel.wav"),
    "Teleport" : load(sounds_path + "Teleport.wav"),
    "GameOver" : load(sounds_path + "GameOver.wav"),
    "SlimeProjectile" : load(sounds_path + "SlimeProjectile.wav"),
    "SaveGrave" : load(sounds_path + "Grave.wav")
    
    
    
    
}

onready var sound_players = get_children()

func play(sound_string, pitch_scale = 1, volume_db = 0):
    for soundPlayer in sound_players:
        if not soundPlayer.playing:
            soundPlayer.pitch_scale = pitch_scale
            soundPlayer.volume_db = volume_db
            soundPlayer.stream = sounds[sound_string]
            soundPlayer.play()
            return
