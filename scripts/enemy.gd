extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var take_damage_cooldown = $take_damage_cooldown

var speed = 47
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true

func _ready():
	animated_sprite_2d.play("idle")

func _physics_process(delta):
	deal_with_damage()
	if player_chase:
		position += (player.position - position)/speed
		animated_sprite_2d.play("walk")
		if(player.position.x - position.x) < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and realm.player_current_attack == true:
		if can_take_damage == true:
			health = health -20
			take_damage_cooldown.start()
			can_take_damage = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
