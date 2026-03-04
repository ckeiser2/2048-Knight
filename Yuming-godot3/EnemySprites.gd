extends Node2D

onready var model = get_node("GreenBlob/GreenBlobSprite")
onready var body = $GreenBlob
onready var health_bar = $EnemyHealthBar
var melee_transform = 560
var move1 = "" # temporary before using func ref

func _ready():
	SignalBus.connect("player_move_complete", self, "_on_player_move_complete")
	SignalBus.connect("display_battle", self, "on_display_battle")
	SignalBus.connect("enemy_health_changed", self, "_on_enemy_health_changed")
	health_bar.value = 100
func _process(delta):
	pass
	
func init_enemy_stats(health, atk, def, move_slot_1):
	GlobalNode.EnemyMaxHealth = health
	GlobalNode.EnemyHealth = health
	GlobalNode.EnemyAtk = atk
	GlobalNode.EnemyDef = def
	GlobalNode.EnemyAtkMultiplier = 1
	GlobalNode.EnemyDefMultiplier = 1
	move1 = move_slot_1
	
func on_display_battle(show, enemy_type):
	GlobalNode.current_enemy = enemy_type
	if show:
		match enemy_type:
			"Green Blob":
				init_enemy_stats(50, 10, 0, "Goop")
				model = get_node("GreenBlob/GreenBlobSprite")
			"Blue Blob":
				init_enemy_stats(50, 5, 0, "Goop")
				model = get_node("BlueBlob/BlueBlobSprite")
			"Skeleton":
				init_enemy_stats(100, 20, 0, "Bone Rush")
				model = get_node("Skeleton/SkeletonSprite")
			_:
				pass
		model.show()
		model.play("idle")
		print("-----x-----")
		health_bar.max_value = 100
		health_bar.value = health_bar.max_value
		health_bar.show()
	else:
		model.hide()
		model.stop()

func _on_player_move_complete(): #TODO: add if atk did no damage
	print("on_player_move_complete")
	yield(get_tree().create_timer(.2), "timeout")
	if (GlobalNode.player_recharge):
		model.play("idle")
		yield(get_tree().create_timer(2.5), "timeout")
		GlobalNode.player_recharge = false
		basic_attack(false)
	else:
		model.play("dmg")
			
func die():
	yield(get_tree().create_timer(.5), "timeout")
	model.play("death")
			
#HealthBar display

func _on_enemy_health_changed(new_health):
	health_bar.value = new_health / GlobalNode.EnemyMaxHealth * 100

func atk_player(baseDamage):
	var dmg = calc_damage(baseDamage)
	GlobalNode.PlayerHealth -= dmg
	SignalBus.emit_signal("player_health_changed", GlobalNode.PlayerHealth)

	var text = "You have taken " + str(dmg) + " damage..."
	SignalBus.emit_signal("update_battle_text_enemy", get_move_text(move1))
	yield(get_tree().create_timer(2), "timeout")
	
func calc_real_atk(baseDamage):
	return floor(GlobalNode.EnemyAtk * GlobalNode.EnemyAtkMultiplier * baseDamage)
	
func calc_real_def():
	return floor(GlobalNode.PlayerDef * GlobalNode.PlayerDefMultiplier)  

func calc_damage(baseDamage):
	var dmg = calc_real_atk(baseDamage) - calc_real_def()
	if (dmg >= GlobalNode.PlayerHealth):
		dmg = GlobalNode.PlayerHealth
	elif (dmg <= 0):
		dmg = 1	
	return dmg
	
func get_move_text(attack_name):
	return GlobalNode.current_enemy + " used " + attack_name + "..."
			
func basic_attack(finished):
	if (finished):
		position.x += melee_transform
		model.play("idle")
		yield(get_tree().create_timer(.5), "timeout")
	else:
		var baseDamage = 1
		model.visible = false
		yield(get_tree().create_timer(.5), "timeout")
		position.x -= melee_transform
		model.play("attack")
		atk_player(baseDamage)
		model.visible = true
		SignalBus.emit_signal("regular_enemy_attack")
		
func basic_attack_finished():
	var finished_animation = model.animation
	match finished_animation:
		"attack":
			basic_attack(true)
		"death":
			yield(get_tree().create_timer(1), "timeout")
			var battle_msg = GlobalNode.current_enemy + " has been slain..."
			SignalBus.emit_signal("update_battle_text_enemy", battle_msg)
			yield(get_tree().create_timer(.1), "timeout")
			print(model)
			print(GlobalNode.current_enemy)
			model.hide()
			model.play("idle")
			yield(get_tree().create_timer(2), "timeout")
			SignalBus.emit_signal("display_battle", false, "N/A")
		"dmg":
			model.play("idle")
			yield(get_tree().create_timer(1), "timeout")
			if (GlobalNode.EnemyHealth <= 0):
				die()
				GlobalNode.battle_button_lock = true
			else:
				yield(get_tree().create_timer(1.5), "timeout")
				basic_attack(false)
		_:
			pass
	pass

func _on_GreenBlobSprite_animation_finished():
	basic_attack_finished()

func _on_BlueBlobSprite_animation_finished():
	basic_attack_finished()

func _on_SkeletonSprite_animation_finished():
	basic_attack_finished()
