extends CharacterBody2D

var speed = 20
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage  = true

func _physics_process(delta):
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/speed
		
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x)<0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
		

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	

#hitbox functions

func enemy():
	pass

#func for when player enters enemy hitbox
func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

#func for when player leaves slime hitbox
func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

#func for hwne player deals damage to slime
func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health = ", health)
			if health <= 0:
				global.one_enemies = global.one_enemies + 1
				self.queue_free()
		

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
