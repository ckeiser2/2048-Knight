extends Node2D

onready var model = $HumanSprite
onready var weapon = $Swing
onready var health_bar = $HealthBar
var hideweapon = false
var melee_transform = 500

func _ready():
	SignalBus.connect("regular_enemy_attack", self, "on_regular_enemy_attack")
	weapon.frame = model.frame
	
	SignalBus.connect("display_battle", self, "_on_battle_health_bar")	
	SignalBus.connect("player_health_changed", self, "_on_player_health_changed")
	GlobalNode.PlayerHealth = GlobalNode.PlayerMaxHealth
	health_bar.value = GlobalNode.PlayerHealth
	
	
func on_regular_enemy_attack():
	yield(get_tree().create_timer(.3), "timeout")
	$DamageAudio.play()
	yield(get_tree().create_timer(.1), "timeout")
	model.play("dmg")

func _process(delta):
	if (weapon.visible):
		model.frame = weapon.frame
		
func _on_HumanSprite_animation_finished():
	var finished_animation = model.animation
	
	match finished_animation:
		"slash":
			slash(true)
		"clobber":
			clobber(true)
		"smite":
			smite(true)
		"heat expulsion":
			heat_expulsion(true)
		"dmg":
			model.play("idle")
			hideweapon = false
		_:
			pass
			
#HealthBar display
func _on_battle_health_bar(show, enemy_type):
	if show:
		GlobalNode.PlayerHealth = GlobalNode.PlayerMaxHealth
		health_bar.value = GlobalNode.PlayerHealth
		health_bar.show()
	else:
		health_bar.hide()
func _on_player_health_changed(new_health):
	health_bar.value = new_health
			

func atk_enemy(baseDamage):
	var dmg = calc_damage(baseDamage)
	GlobalNode.EnemyHealth -= dmg
	SignalBus.emit_signal("enemy_health_changed", GlobalNode.EnemyHealth)
	
	var text = "Enemy has taken " + str(dmg) + " damage..."
	yield(get_tree().create_timer(.3), "timeout")
#	SignalBus.emit_signal("update_battle_text",  text) -- No need to state damage w/ healthbar
	
func calc_real_atk(baseDamage):
	return floor(GlobalNode.PlayerAtk * GlobalNode.PlayerAtkMultiplier * baseDamage)
	
func calc_real_def():
	return floor(GlobalNode.EnemyDef * GlobalNode.EnemyDefMultiplier)  

func get_move_text(attack_name):
	return "You used " + attack_name + "..."
	
func calc_damage(baseDamage):
	var dmg = calc_real_atk(baseDamage) - calc_real_def()
	if (dmg > GlobalNode.EnemyHealth):
		dmg = GlobalNode.EnemyHealth
	elif (dmg <= 0):
		dmg = 1	
	return dmg
			
func slash(finished):
	if (finished):
		position.x -= melee_transform
		model.play("idle")
	else:
		var baseDamage = 1
		model.visible = false
		weapon.visible = false
		yield(get_tree().create_timer(.5), "timeout")
		position.x += melee_transform
		weapon.play("nothing")
		model.play("slash")
		SignalBus.emit_signal("update_battle_text",  get_move_text("Slash"))
		atk_enemy(baseDamage)
		model.visible = true
		$SwordStrikeAudio.play()
		
func clobber(finished):
	if (finished):
		position.x -= melee_transform
		model.play("idle")
		weapon.visible = false
	else:
		var baseDamage = 2
		model.visible = false
		weapon.visible = false
		yield(get_tree().create_timer(.5), "timeout")
		position.x += melee_transform
		model.play("clobber")
		weapon.play("clobber")
		weapon.frame = 0
		model.visible = true
		weapon.visible = true
		SignalBus.emit_signal("update_battle_text",  get_move_text("Clobber"))
		atk_enemy(baseDamage)
		$SwordStrikeAudio.play()
		
func smite(finished):
	if (finished):
		position.x -= melee_transform
		model.play("idle")
	else:
		var baseDamage = 1
		model.visible = false
		weapon.visible = false
		yield(get_tree().create_timer(.5), "timeout")
		position.x += melee_transform
		weapon.play("nothing")
		model.play("smite")
		SignalBus.emit_signal("update_battle_text",  get_move_text("Smite"))
		var randDmg = (randi() % 50) + 25
		atk_enemy(baseDamage)
		model.visible = true
		$SwordStrikeAudio.play()
		
func heat_expulsion(finished):
	if (finished):
		position.x -= melee_transform
		model.play("idle")
		weapon.visible = false
	else:
		var baseDamage = 2
		model.visible = false
		weapon.visible = false
		yield(get_tree().create_timer(.5), "timeout")
		position.x += melee_transform
		model.play("heat expulsion")
		weapon.play("heat expulsion")
		weapon.frame = 0
		model.visible = true
		weapon.visible = true
		SignalBus.emit_signal("update_battle_text",  get_move_text("Heat Expulsion"))
		atk_enemy(baseDamage)
		$SwordStrikeAudio.play()
		yield(get_tree().create_timer(1), "timeout")
		if (GlobalNode.current_enemy == "Skeleton"):
			SignalBus.emit_signal("update_secondary_text",  "It was super effective...")
		else:
			pass
#			SignalBus.emit_signal("update_secondary_text",  "It was super effective...")
func player_recharge():
	SignalBus.emit_signal("update_battle_text",  "Player must recharge...")

func _on_Move1_pressed():
	if (!GlobalNode.battle_button_lock):
		if (!GlobalNode.player_will_recharge):
			slash(false)
			hideweapon = true
			GlobalNode.battle_button_lock = true
		else:
			hideweapon = true
			GlobalNode.battle_button_lock = true
			GlobalNode.player_recharge = true
			GlobalNode.player_will_recharge = false
			player_recharge()
	
func _on_Move2_pressed():
	if (!GlobalNode.battle_button_lock):
		clobber(false)
		hideweapon = false
		GlobalNode.player_will_recharge = true
		GlobalNode.battle_button_lock = true
	
func _on_Move3_pressed():
	if (!GlobalNode.battle_button_lock):
		smite(false)
		hideweapon = true
		GlobalNode.battle_button_lock = true
	
func _on_Move4_pressed():
	if (!GlobalNode.battle_button_lock):
		heat_expulsion(false)
		hideweapon = false
		GlobalNode.battle_button_lock = true
	
