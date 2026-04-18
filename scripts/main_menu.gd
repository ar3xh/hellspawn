extends Control

@onready var character_select: OptionButton = $Panel/VBoxContainer/CharacterRow/CharacterSelect
@onready var weapon_select: OptionButton = $Panel/VBoxContainer/WeaponRow/WeaponSelect
@onready var difficulty_select: OptionButton = $Panel/VBoxContainer/DifficultyRow/DifficultySelect
@onready var description_label: Label = $Panel/VBoxContainer/Description

func _ready() -> void:
	_populate_options()
	_update_description()

func _populate_options() -> void:
	for c in GameManager.CHARACTERS.keys():
		character_select.add_item(c)
	for w in GameManager.WEAPONS.keys():
		weapon_select.add_item(w)
	for d in GameManager.DIFFICULTIES.keys():
		difficulty_select.add_item(d)

	character_select.select(_find_idx(character_select, GameManager.selected_character))
	weapon_select.select(_find_idx(weapon_select, GameManager.selected_weapon))
	difficulty_select.select(_find_idx(difficulty_select, GameManager.selected_difficulty))

func _find_idx(button: OptionButton, value: String) -> int:
	for i in button.item_count:
		if button.get_item_text(i) == value:
			return i
	return 0

func _on_selection_changed(_index: int) -> void:
	_update_description()

func _update_description() -> void:
	var character = character_select.get_item_text(character_select.selected)
	var weapon = weapon_select.get_item_text(weapon_select.selected)
	var difficulty = difficulty_select.get_item_text(difficulty_select.selected)

	var c = GameManager.CHARACTERS[character]
	var w = GameManager.WEAPONS[weapon]
	var d = GameManager.DIFFICULTIES[difficulty]

	description_label.text = "Character: %s | HP %d | Speed %.0f\nWeapon: %s | %d projectile(s) | %.2fs fire rate\nDifficulty: %s | Enemy HP x%.2f | Spawn x%.2f" % [
		character,
		c.hp,
		c.speed,
		weapon,
		w.projectiles,
		w.fire_rate,
		difficulty,
		d.enemy_hp_mult,
		d.spawn_rate_mult
	]

func _on_start_pressed() -> void:
	var character = character_select.get_item_text(character_select.selected)
	var weapon = weapon_select.get_item_text(weapon_select.selected)
	var difficulty = difficulty_select.get_item_text(difficulty_select.selected)
	GameManager.set_loadout(character, weapon, difficulty)
	GameManager.reset_run_state()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
