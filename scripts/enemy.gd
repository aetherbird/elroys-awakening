extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var take_damage_cooldown = $take_damage_cooldown

var speed = 47
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true

var knockback_direction = Vector2.ZERO
var knockback_timer = 0.0
var knockback_duration = 0.3  # Duration of the knockback effect

func _ready():
	animated_sprite_2d.play("idle")

func _physics_process(delta):
	deal_with_damage()

	# Handle knockback
	if knockback_timer > 0:
		var knockback_step = knockback_direction * (delta / knockback_duration)
		position += knockback_step
		knockback_timer -= delta

	if player_chase and knockback_timer <= 0:
		position += (player.position - position) / speed
		animated_sprite_2d.play("walk")
		if (player.position.x - position.x) < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.play("idle")

	update_health()

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and realm.player_current_attack == true:
		if can_take_damage == true:
			health -= 20
			start_knockback()  # Start the knockback effect
			take_damage_cooldown.start()
			can_take_damage = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()

func start_knockback():
	knockback_direction = (position - player.position).normalized() * 20  # Adjust the strength
	knockback_timer = knockback_duration

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
