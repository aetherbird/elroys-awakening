extends CharacterBody3D

@export var default_speed := 4.0
@export var speed := default_speed
@export var jump_velocity := 5.0
@export var gravity := 9.8

var current_dir = "down"  # Ensure the correct idle animation plays at the start
var is_attacking = false
var is_jumping = false  # Track if the character is in the air
var is_falling = false  # Track if the character is falling

func _ready():
	current_dir = "down"
	$AnimatedSprite3D.play("front_idle")
	$AnimatedSprite3D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta: float) -> void:
	player_movement(delta)
	check_attack()

func player_movement(delta: float) -> void:
	if is_attacking:
		move_and_slide()
		return
	
	var previous_dir = current_dir
	var direction := Vector3.ZERO
	
	if Input.is_action_pressed("ui_up"):
		speed = default_speed * 0.4
		current_dir = "up"
		direction -= transform.basis.z
	elif Input.is_action_pressed("ui_down"):
		speed = default_speed * 0.4
		current_dir = "down"
		direction += transform.basis.z
	elif Input.is_action_pressed("ui_left"):
		speed = default_speed
		current_dir = "left"
		direction -= transform.basis.x
	elif Input.is_action_pressed("ui_right"):
		speed = default_speed
		current_dir = "right"
		direction += transform.basis.x
	
	direction = direction.normalized()

	# Allow movement while in the air
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Check if the direction has changed
	if previous_dir != current_dir:
		if is_jumping or is_falling:
			update_jump_animation()
		else:
			play_anim(1)

	# Update the animation if there's no directional input
	if direction == Vector3.ZERO and not is_jumping and not is_falling:
		play_anim(0)

	if not is_on_floor():
		if not is_jumping and not is_falling:
			# Character is falling
			is_falling = true
			update_jump_animation()
		velocity.y -= gravity * delta
	else:
		if is_jumping or is_falling:  # Check if the character has just landed
			is_jumping = false
			is_falling = false
			if direction == Vector3.ZERO:
				play_anim(0)  # Play idle animation upon landing
			else:
				play_anim(1)  # Play walking animation upon landing
		if Input.is_action_just_pressed("jump"):
			jump()

	move_and_slide()

func check_attack() -> void:
	# Disable attacking while in the air (jumping or falling)
	if is_on_floor() and not is_jumping and not is_falling and Input.is_action_just_pressed("ui_attack") and not is_attacking:
		attack()

func attack() -> void:
	is_attacking = true
	match current_dir:
		"up":
			$AnimatedSprite3D.play("back_attack")
		"down":
			$AnimatedSprite3D.play("front_attack")
		"left", "right":
			$AnimatedSprite3D.play("side_attack")

func jump() -> void:
	is_jumping = true  # Set jumping state
	update_jump_animation()  # Play the appropriate jump/fall animation
	velocity.y = jump_velocity

func update_jump_animation() -> void:
	var anim = $AnimatedSprite3D
	match current_dir:
		"up":
			anim.play("jump_back")
		"down":
			anim.play("jump_front")
		"left":
			anim.flip_h = true
			anim.play("jump_side")
		"right":
			anim.flip_h = false
			anim.play("jump_side")

func _on_animation_finished() -> void:
	is_attacking = false
	if not is_jumping and not is_falling:  # Only play idle or walk animations if not jumping or falling
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			play_anim(1)
		else:
			play_anim(0)

func play_anim(movement: int) -> void:
	var dir = current_dir
	var anim = $AnimatedSprite3D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
		
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
		
	if dir == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
		
	if dir == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
