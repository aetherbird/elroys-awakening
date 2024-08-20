extends CharacterBody2D

const speed = 100
var current_direc = "none"

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 200
var player_alive = true
var attack_inprog = false

@onready var attack_cooldown = $attack_cooldown
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var deal_attack_timer = $deal_attack_timer

func _ready():
	animated_sprite_2d.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	if health <= 0:
		## End screen/game over screen here
		player_alive = false
		health = 0
		print("player has been killed")
		self.queue_free()

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_direc = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direc = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direc = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_direc = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	move_and_slide()

func play_anim(movement):
	var direc = current_direc
	var anim = animated_sprite_2d
	
	if direc == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_inprog == false:
				anim.play("side_idle")
	if direc == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_inprog == false:
				anim.play("side_idle")
	if direc == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_inprog == false:
				anim.play("front_idle")
	if direc == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_inprog == false:
				anim.play("back_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var direc = current_direc
	if Input.is_action_just_pressed("attack"):
		realm.player_current_attack = true
		attack_inprog = true
		if direc == "right":
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("side_attack")
			deal_attack_timer.start()
		if direc == "left":
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("side_attack")
			deal_attack_timer.start()
		if direc == "down":
			animated_sprite_2d.play("front_attack")
			deal_attack_timer.start()
		if direc == "up":
			animated_sprite_2d.play("back_attack")
			deal_attack_timer.start()

func _on_deal_attack_timer_timeout():
	deal_attack_timer.stop()
	realm.player_current_attack = false
	attack_inprog = false

func current_camera():
	if realm.current_scene == "world_a":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
	elif realm.current_scene == "cliff_side":
		$world_camera.enabled = false
		$cliffside_camera.enabled = true
