extends CanvasLayer

var timer_label: Label
var xp_bar: ProgressBar
var level_label: Label
var hp_label: Label
var loadout_label: Label
var _player = null

func _ready():
	timer_label = get_node_or_null("TimerLabel")
	xp_bar = get_node_or_null("XPBar")
	level_label = get_node_or_null("LevelLabel")
	hp_label = get_node_or_null("HPLabel")
	loadout_label = get_node_or_null("LoadoutLabel")

	if loadout_label:
		loadout_label.text = "%s • %s • %s" % [
			GameManager.selected_character,
			GameManager.selected_weapon,
			GameManager.selected_difficulty
		]

	await get_tree().process_frame
	_player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if _player == null:
		return
	if timer_label:
		var remaining = max(0.0, GameManager.GAME_DURATION - GameManager.elapsed_time)
		var mins = int(remaining / 60)
		var secs = int(fmod(remaining, 60))
		timer_label.text = "%02d:%02d" % [mins, secs]
	if xp_bar:
		xp_bar.max_value = _player.stats.xp_to_level
		xp_bar.value = _player.stats.xp
	if level_label:
		level_label.text = "Lv %d" % _player.stats.level
	if hp_label:
		hp_label.text = "HP %d / %d" % [_player.stats.hp, _player.stats.max_hp]
