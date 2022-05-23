extends "res://Enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var WALKING_DIRECTION

var state
var previous_state

onready var floorLeft = $FloorLeft
onready var floorRight = $FloorRight
onready var wallLeft = $WallLeft
onready var wallRight = $WallRight

func _ready():
    state = WALKING_DIRECTION
    

func _physics_process(_delta):
    match state:
        DIRECTION.RIGHT:
            motion.x = MAX_SPEED
            if not floorRight.is_colliding() or wallRight.is_colliding():
                previous_state = DIRECTION.RIGHT
                state = DIRECTION.LEFT

        DIRECTION.LEFT:
            motion.x = -MAX_SPEED
            if not floorLeft.is_colliding() or wallLeft.is_colliding():
                previous_state = DIRECTION.LEFT
                state = DIRECTION.RIGHT
    
    sprite.scale.x = sign(motion.x)
    motion = move_and_slide(motion, Vector2.UP)
