extends Control

var UPGRADES = [
	{
		"name": "More Damage",
		"desc": "+1 damage per bullet",
		"apply": func(p): p.stats.damage += 1
	},
	{
		"name": "Faster Fire",
		"desc": "+20% fire rate",
		"apply": func(p): p.stats.fire_rate_mult += 0.2
	},
	{
		"name": "Speed Boost",
		"desc": "+25 move speed",
		"apply": func(p): p.speed += 25
	},
	{
		"name": "Vitality",
		"desc": "+2 max HP and heal 2",
		"apply": func(p): p.stats.max_hp += 2; p.stats.hp = min(p.stats.hp + 2, p.stats.max_hp)
	},
	{
		"name": "Swift Bullets",
		"desc": "+120 bullet speed",
		"apply": func(p): p.stats.bullet_speed += 120
	},
]

var _chosen: Array = []
var _player = null

func _ready():
	_player = get_tree().get_first_node_in_group("player")
	_choose_upgrades()

func _choose_upgrades():
	var pool = UPGRADES.duplicate()
	pool.shuffle()
	_chosen = pool.slice(0, 3)

	var buttons = [$Button1, $Button2, $Button3]
	for i in 3:
		buttons[i].text = "%s\n%s" % [_chosen[i]["name"], _chosen[i]["desc"]]
		var idx = i
		buttons[i].pressed.connect(func(): _pick(idx), CONNECT_ONE_SHOT)

func _pick(index: int):
	if _player == null:
		queue_free()
		GameManager.resume()
		return
	_chosen[index]["apply"].call(_player)
	GameManager.resume()
	queue_free()
