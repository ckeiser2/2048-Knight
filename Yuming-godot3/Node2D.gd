extends Node2D

var PlayerMaxHealth = 100
var PlayerHealth = 100
var PlayerAtk = 25
var PlayerAtkMultiplier = 1.0
var PlayerDef = 5
var PlayerDefMultiplier = 1.0
var EnemyMaxHealth = 50
var EnemyHealth = 50
var EnemyAtk = 10
var EnemyAtkMultiplier = 1.0
var EnemyDef = 0
var EnemyDefMultiplier = 1.0
var current_enemy = "N/A"
var battle_button_lock = false
var battle_text_queue = []
var player_recharge = false
var player_will_recharge = false

onready var pause_menu = $Camera2D/PauseMenu
var paused = false
