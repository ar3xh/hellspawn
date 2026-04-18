extends Node

signal level_up_triggered
signal game_won
signal game_over

const GAME_DURATION := 1200.0  # 20 minutes in seconds

const DIFFICULTIES := {
	"Easy": {
		"enemy_hp_mult": 0.8,
		"enemy_speed_mult": 0.9,
		"spawn_rate_mult": 0.85,
		"xp_mult": 1.1
	},
	"Normal": {
		"enemy_hp_mult": 1.0,
		"enemy_speed_mult": 1.0,
		"spawn_rate_mult": 1.0,
		"xp_mult": 1.0
	},
	"Hard": {
		"enemy_hp_mult": 1.35,
		"enemy_speed_mult": 1.2,
		"spawn_rate_mult": 1.2,
		"xp_mult": 0.9
	}
}

const CHARACTERS := {
	"Scarlet": {
		"speed": 330.0,
		"hp": 5,
		"damage": 1,
		"fire_rate_mult": 1.0,
		"bullet_speed": 850.0
	},
	"Diamond": {
		"speed": 270.0,
		"hp": 7,
		"damage": 2,
		"fire_rate_mult": 0.85,
		"bullet_speed": 760.0
	}
}

const WEAPONS := {
	"Revolver": {
		"fire_rate": 0.38,
		"projectiles": 1,
		"spread_degrees": 0.0,
		"damage_mult": 1.0,
		"speed_mult": 1.0,
		"pierce": 0
	},
	"Shotgun": {
		"fire_rate": 0.8,
		"projectiles": 5,
		"spread_degrees": 24.0,
		"damage_mult": 0.7,
		"speed_mult": 0.85,
		"pierce": 0
	}
}

var elapsed_time := 0.0
var running := true

var selected_difficulty := "Normal"
var selected_character := "Scarlet"
var selected_weapon := "Revolver"

const UPGRADE_SCREEN = preload("res://scenes/upgrade_screen.tscn")

func _ready():
	reset_run_state()

func _process(delta):
	if not running:
		return
	elapsed_time += delta
	if elapsed_time >= GAME_DURATION:
		running = false
		emit_signal("game_won")

func reset_run_state():
	elapsed_time = 0.0
	running = true
	get_tree().paused = false

func set_loadout(character_name: String, weapon_name: String, difficulty_name: String):
	if CHARACTERS.has(character_name):
		selected_character = character_name
	if WEAPONS.has(weapon_name):
		selected_weapon = weapon_name
	if DIFFICULTIES.has(difficulty_name):
		selected_difficulty = difficulty_name

func get_difficulty_config() -> Dictionary:
	return DIFFICULTIES[selected_difficulty]

func get_character_config() -> Dictionary:
	return CHARACTERS[selected_character]

func get_weapon_config() -> Dictionary:
	return WEAPONS[selected_weapon]

func trigger_level_up():
	running = false
	get_tree().paused = true

	var screen = UPGRADE_SCREEN.instantiate()
	get_tree().root.add_child(screen)
	emit_signal("level_up_triggered")

func resume():
	running = true
	get_tree().paused = false
