extends CharacterBody2D

const SPEED = 125.0
const JUMP_VELOCITY = -300.0
const MIN_JUMP_VELOCITY = -100.0 # <----(For variable jump height)

# Coyote time & Buffering settings
const COYOTE_TIME = 0.1 
const JUMP_BUFFER_TIME = 0.1

var coyote_timer = 0.0
var jump_buffer_timer = 0.0

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME

	# Jump buffering
	if Input.is_action_just_pressed("Jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta

	# Jump logic (Coyote + Buffer)
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0
		coyote_timer = 0

	# Variable jump height
	if Input.is_action_just_released("Jump") and velocity.y < MIN_JUMP_VELOCITY:
		velocity.y = MIN_JUMP_VELOCITY

	# Movement and Idle/Run animations
	var direction := Input.get_axis("Move_Left", "Move_Right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			$AnimatedSprite2D.play("run")
			$AnimatedSprite2D.flip_h = direction < 0
		elif !is_on_floor():
			$AnimatedSprite2D.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
		elif !is_on_floor():
			$AnimatedSprite2D.play("jump")

	move_and_slide()
