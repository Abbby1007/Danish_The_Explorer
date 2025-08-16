extends CharacterBody2D
#animation and speed variables
const speed = 100
var current_dir = "down"

#player hitbox variables
var enemy_inattack_range  = false
var enemy_attack_cooldown = true
var health =  100
var player_alive = true

#attack variable
var attack_ip = false

#This function tells the game to have this animation ready when the game starts
func _ready():
	$AnimatedSprite2D.play("front_idle")


func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	if health <= 0:
		player_alive = false  #ADD END SCREEN(RESPAWN OR GO BACK TO MENU)
		health = 0
		print("Player has been killed")
		get_tree().reload_current_scene()
	
#controls the movement and determines where the player is facing
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	#player movement function ends --------
	# PLAYER ANIMATION START -----------------
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("d_right")
		elif movement == 0:
			if attack_ip == false:
				anim.play("d_right")
	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("d_right")
		elif movement == 0:
			if attack_ip == false:
				anim.play("d_right")
			
	elif dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("d_front")
		elif movement == 0:
			if attack_ip == false:
				anim.play("d_front")
			
	elif dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("d_back")
		elif movement == 0:
			if attack_ip == false:
				anim.play("d_back")
			
	
# PLAYER ANIMATION END ----------------------

#player hitbox functions
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
		health = health - 10
		enemy_attack_cooldown = false
		#starts timer
		$attack_cooldown.start()
		print(health)

#when player timer goes off it sets attack cooldown to true
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("d_side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("d_side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("d_front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("d_back_attack")
			$deal_attack_timer.start()
			

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
