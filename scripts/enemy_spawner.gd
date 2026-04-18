extends Node

const ENEMY_SCENE = preload("res://scenes/enemy.tscn")

var _timer := 1.5
var _spawn_radius := 700.0

func _process(delta):
	_timer -= delta
	if _timer <= 0:
		_spawn()
		var t = GameManager.elapsed_time
		var diff = GameManager.get_difficulty_config()
		_timer = max(0.2, (1.5 - t * 0.008) / diff.spawn_rate_mult)

func _spawn():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var angle = randf() * TAU
	var pos = player.global_position + Vector2.from_angle(angle) * _spawn_radius
	var e = ENEMY_SCENE.instantiate()
	e.global_position = pos
	get_parent().add_child(e)
	var t = GameManager.elapsed_time
	e.move_speed = 62.0 + t * 0.55
	e.hp = 3 + int(t / 120.0)
