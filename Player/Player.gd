extends KinematicBody2D

const DustEffect = preload("res://Effects/DustEffect.tscn")

var PlayerStats = ResourceLoader.PlayerStats
var MainInstances = ResourceLoader.MainInstances

#export (int) var ACCELERATION = 512
#export (int) var MAX_SPEED = 64
#export (float) var FRICTION = 0.25
#export (int) var GRAVITY = 250
#export (int) var WALL_SLIDE_SPEED = 48
#export (int) var MAX_WALL_SLIDE_SPEED = 125 # Same as Jump force for now
#export (int) var JUMP_FORCE = 125
#export (int) var MAX_SLOPE_ANGLE = 46

#export (int) var ACCELERATION = 512
#export (int) var MAX_SPEED = 64
#export (float) var FRICTION = 0.25
#export (int) var GRAVITY = 220
#export (int) var WALL_SLIDE_SPEED = 48
#export (int) var MAX_WALL_SLIDE_SPEED = 145 # Same as Jump force for now
#export (int) var JUMP_FORCE = 145
#export (int) var MAX_SLOPE_ANGLE = 46

var ACCELERATION = 512
var MAX_SPEED = 96
var FRICTION = 0.25
#var GRAVITY = 220
var WALL_SLIDE_SPEED = 48
var MAX_WALL_SLIDE_SPEED = 145 # Same as Jump force for now
#var JUMP_FORCE = 145
var MAX_SLOPE_ANGLE = 46

# Potential
#var GRAVITY = 308
#var JUMP_FORCE = 190

var GRAVITY = 330
var JUMP_FORCE = 190

enum {
    MOVE,
    WALL_SLIDE,
    ATTACK  
}

var state = MOVE
var invincible = false setget set_invincible
var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var just_jumped = false
var double_jump_enabled = false
var double_jump = false
var won_game = false
var on_moving_platform = false

onready var sprite = $Sprite
onready var attackSpriteRight = $AttackSpriteRight
onready var attackAnimatorRight = $AttackAnimatorRight
onready var attackSpriteLeft = $AttackSpriteLeft
onready var attackAnimatorLeft = $AttackAnimatorLeft
onready var spriteAnimator = $SpriteAnimator
onready var coyoteJumpTimer = $CoyoteJumpTimer
onready var blinkAnimator = $BlinkAnimator
onready var powerupDetector = $PowerUpDetector
onready var cameraFollow = $CameraFollow
onready var gameTimer = $GameTimer
onready var hurtboxCollider = $Hurtbox/Collider
onready var hurtbox = $Hurtbox

# warning-ignore:unused_signal
signal hit_door(door)

func save():
    var save_dictionary = {
        "filename": get_filename(),
        "parent": get_parent().get_path(),
        "position_x": position.x,
        "position_y": position.y     
    }
    return save_dictionary

func assign_world_camera():
    cameraFollow.remote_path = MainInstances.WorldCamera.get_path()

func set_invincible(value):
    invincible = value
    
func _ready():
    gameTimer.start()
    PlayerStats.connect("player_died", self, "_on_died")
    PlayerStats.health = SaverAndLoader.custom_data.health_value
    PlayerStats.time = SaverAndLoader.custom_data.time_value
    MainInstances.Player = self
    call_deferred("assign_world_camera")

func queue_free():
    MainInstances.Player = null
    .queue_free()
    
func check_reload():
    if Input.is_action_just_pressed("reload"):
        SaverAndLoader.is_loading = true
        # warning-ignore:return_value_discarded
        get_tree().change_scene("res://World.tscn")

func _physics_process(delta):
    just_jumped = false
    check_reload()
    if gameTimer.time_left == 0:
        PlayerStats.time -= 1
        gameTimer.start()
    
    match state:
        MOVE: 
            var input_vector = get_input_vector()
            apply_horizontal_force(input_vector, delta)
            apply_friction(input_vector)
            update_snap_vector()
            jump_check() 
            apply_gravity(delta)
            update_animations(input_vector)
            move()
            attack_check()
            wall_slide_check()
        WALL_SLIDE:
            spriteAnimator.play("Wall Slide")
            var wall_axis = get_wall_axis()
            if wall_axis != 0:
                sprite.scale.x = wall_axis
            wall_slide_jump_check(wall_axis)
            wall_slide_drop(delta)
            move()
            wall_detach(delta, wall_axis)
            #wall_slide_input_check()
        ATTACK:
            apply_gravity(delta)
            apply_attack_motion()
            perform_attack()


func create_dust_effect():
    SoundFX.play("Step", rand_range(0.6, 1.2), -20)
    var dust_position = global_position
    dust_position.x += rand_range(-4, 4)
    Utils.instance_scene_on_main(DustEffect, dust_position)

func get_input_vector():
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    return input_vector
    
    
func apply_horizontal_force(input_vector, delta):
    if input_vector.x != 0:
        motion.x += input_vector.x * ACCELERATION * delta
        motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
    
    
func apply_friction(input_vector):
    if input_vector.x == 0 and is_on_floor():
        motion.x = lerp(motion.x, 0, FRICTION)
        
func update_snap_vector():
    if is_on_floor():
        snap_vector = Vector2.DOWN

func jump_check():
    if is_on_floor() or coyoteJumpTimer.time_left > 0:
        if Input.is_action_just_pressed("ui_up"):
            jump(JUMP_FORCE)
            just_jumped = true
    else:
        if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
            motion.y = -JUMP_FORCE/2
            
        if Input.is_action_just_pressed("ui_up") and double_jump:
            jump(JUMP_FORCE * 0.75)
            double_jump = false
                
func jump(force):
    SoundFX.play("Jump", rand_range(0.6, 1.0), -0)
    motion.y = -force
    snap_vector = Vector2.ZERO
    create_dust_effect()
    

func apply_gravity(delta):
    if not is_on_floor():
        motion.y += GRAVITY * delta
        motion.y = min(motion.y, JUMP_FORCE)
    
func update_animations(input_vector):
    if input_vector.x != 0:
        sprite.scale.x = sign(input_vector.x)
        spriteAnimator.play("Run")
    else:
        spriteAnimator.play("Idle")
    
    if not is_on_floor():
        spriteAnimator.play("Jump")

func move():
    var was_in_air = not is_on_floor()
    var was_on_floor = is_on_floor()
    var last_motion = motion
    var last_position = position
    
    motion = move_and_slide_with_snap(motion, snap_vector * 4, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))
    
    # Landing
    if was_in_air and is_on_floor():
        motion.x = last_motion.x
        if double_jump_enabled:
            double_jump = true
        create_dust_effect()
    
    # Just left ground
    if was_on_floor and not is_on_floor() and not just_jumped:
        motion.y = 0
        position.y = last_position.y
        coyoteJumpTimer.start()
    
    # Prevent Sliding
    if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
        position.x = last_position.x
    

func wall_slide_check():
    if not is_on_floor() and is_on_wall():
        state = WALL_SLIDE
        # This determines if you get your double jump back after wall sliding (If enabled, of course)
        if double_jump_enabled:
            double_jump = true

func get_wall_axis():
    var is_right_wall = test_move(transform, Vector2.RIGHT) # Returns true if collision there
    var is_left_wall = test_move(transform, Vector2.LEFT)
    return int(is_left_wall) - int(is_right_wall) # Returns integer value between [-1, 0]
    
func wall_slide_jump_check(wall_axis):
    if Input.is_action_just_pressed("ui_up"):
        SoundFX.play("Jump", rand_range(0.6, 1.0), -0)
        motion.x = wall_axis * MAX_SPEED
        motion.y = -JUMP_FORCE / 1.25 # less jump force when jumping off the wall
        state = MOVE
        
func wall_slide_drop(delta):
    var max_slide_speed = WALL_SLIDE_SPEED
    if Input.is_action_pressed("ui_down"):
        max_slide_speed = MAX_WALL_SLIDE_SPEED
    motion.y = min(motion.y + GRAVITY * delta, max_slide_speed)


func wall_detach(delta, wall_axis):
    if Input.is_action_just_pressed("ui_right"):
        motion.x = ACCELERATION * delta
        state = MOVE
    if Input.is_action_just_pressed("ui_left"):
        motion.x = -ACCELERATION * delta
        state = MOVE
    if is_on_floor() or wall_axis == 0:  # We will detach from walls with this current logic if we are between to close walls
        state = MOVE

func wall_slide_input_check():
    if not (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
        state = MOVE
        
func attack_check():
    if is_on_floor() and Input.is_action_just_pressed("attack"):
        SoundFX.play("PlayerAttack", rand_range(0.9, 1), -10)
        state = ATTACK
        
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
    state = MOVE
    
func apply_attack_motion():
    motion = move_and_slide_with_snap(Vector2.ZERO, snap_vector * 4, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))

func _on_Hurtbox_hit(damage):
    if not invincible:
        SoundFX.play("PlayerHurt", rand_range(0.9, 1.0), -5)
        PlayerStats.health -= damage
        set_invincible(true)
        blinkAnimator.play("Blink")

func _on_died():
    queue_free()

func _on_PowerUpDetector_area_entered(area):
    if area is Powerup:
        area._pickup()

func hit_fallzone():
    var fallLocation = MainInstances.FallPositionLocation
    self.global_position = fallLocation.global_position
    if not invincible:
        SoundFX.play("PlayerHurt", rand_range(0.9, 1.0), -5)
        blinkAnimator.play("Blink")
    
func teleport(new_position):
    self.global_position = new_position    


func _on_PlatformDetector_area_entered(_area):
    on_moving_platform = true


func _on_PlatformDetector_area_exited(_area):
    on_moving_platform = false
