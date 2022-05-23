extends "res://Enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1, ATTACK = 0}

export(DIRECTION) var WALKING_DIRECTION

var state
var previousDirection

onready var attackSpriteRight = $AttackSpriteRight
onready var attackSpriteLeft = $AttackSpriteLeft
onready var attackAnimatorRight = $AttackAnimatorRight
onready var attackAnimatorLeft = $AttackAnimatorLeft
onready var floorLeft = $FloorLeft
onready var floorRight = $FloorRight
onready var wallLeft = $WallLeft
onready var wallRight = $WallRight
onready var wallLeftTop = $WallLeftTop
onready var wallRightTop = $WallRightTop
onready var playerLeft = $PlayerLeft
onready var playerRight = $PlayerRight
onready var attackRangeLeft = $AttackRangeLeft
onready var attackRangeRight = $AttackRangeRight
onready var attackCooldownTimer = $AttackCooldownTimer

func _ready():
    state = WALKING_DIRECTION
    attackCooldownTimer.start()  
    
func _physics_process(_delta):
    match state:
        DIRECTION.RIGHT:
            motion.x = MAX_SPEED
            if attackRangeRight.is_colliding() and attackCooldownTimer.time_left == 0:
                previousDirection = state
                SoundFX.play("SkeletonPunch", 1, -10)
                state = DIRECTION.ATTACK
                attackCooldownTimer.start()
            if playerLeft.is_colliding():
                state = DIRECTION.LEFT
            if not floorRight.is_colliding() or wallRight.is_colliding() or wallRightTop.is_colliding():
                state = DIRECTION.LEFT
            move()
            
        DIRECTION.LEFT:
            motion.x = -MAX_SPEED
            if attackRangeLeft.is_colliding() and attackCooldownTimer.time_left == 0:
                previousDirection = state
                SoundFX.play("SkeletonPunch", 1, -10)
                state = DIRECTION.ATTACK
                attackCooldownTimer.start()
            if playerRight.is_colliding():
                state = DIRECTION.RIGHT
            if not floorLeft.is_colliding() or wallLeft.is_colliding() or wallLeftTop.is_colliding():
                state = DIRECTION.RIGHT
            move()
        DIRECTION.ATTACK:
            perform_attack()
            
    #var player = MainInstances.Player
    #sprite.scale.x = sign(motion.x)
    #motion = move_and_slide(motion, Vector2.UP)
  
func move():
    sprite.scale.x = sign(motion.x)
    motion = move_and_slide(motion, Vector2.UP)   

func perform_attack():
    sprite.hide()
    if sprite.scale.x == 1:
        attackSpriteRight.show()
        attackAnimatorRight.play("Attack")
        yield(attackAnimatorRight, "animation_finished")
        attackSpriteRight.hide()
    else:
        attackSpriteLeft.show()
        attackAnimatorLeft.play("Attack")
        yield(attackAnimatorLeft, "animation_finished")
        attackSpriteLeft.hide()
    sprite.show()
    state = previousDirection












