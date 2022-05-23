extends "res://Enemies/Enemy.gd"

const EnemyBullet = preload("res://Enemies/EnemyBullet.tscn")

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var WALKING_DIRECTION
export(int) var BULLET_SPEED = 35
export(float) var SPREAD = 5


var state
var firingEnabled = false

onready var floorLeft = $FloorLeft
onready var floorRight = $FloorRight
onready var wallLeft = $WallLeft
onready var wallRight = $WallRight
onready var bulletSpawnPoint = $BulletSpawnPoint
onready var fireBulletTimer = $FireBulletTimer

func _ready():
    state = WALKING_DIRECTION    
    fireBulletTimer.start()
        
func fire_bullet(player):
    SoundFX.play("SlimeProjectile", 1, -15)
    var bullet = Utils.instance_scene_on_main(EnemyBullet, bulletSpawnPoint.global_position)
    var velocity = ((player.global_position + Vector2(0, -13)) - global_position).normalized() * BULLET_SPEED
    velocity = velocity.rotated(deg2rad(rand_range(-SPREAD/2, SPREAD/2)))
    bullet.velocity = velocity
    fireBulletTimer.start()

func _physics_process(_delta):
    match state:
        DIRECTION.RIGHT:
            motion.x = MAX_SPEED
            if not floorRight.is_colliding() or wallRight.is_colliding():
                state = DIRECTION.LEFT
            
        DIRECTION.LEFT:
            motion.x = -MAX_SPEED
            if not floorLeft.is_colliding() or wallLeft.is_colliding():
                state = DIRECTION.RIGHT
            
    var player = MainInstances.Player
    if player != null and fireBulletTimer.time_left == 0 and firingEnabled:
        fire_bullet(player)
    sprite.scale.x = sign(motion.x)
    motion = move_and_slide(motion, Vector2.UP)


func _on_VisibilityNotifier2D_screen_entered():
    firingEnabled = true


func _on_VisibilityNotifier2D_screen_exited():
    firingEnabled = false


func _on_PlayerChecker_area_entered(_area):
    firingEnabled = false


func _on_PlayerChecker_area_exited(_area):
    firingEnabled = true
