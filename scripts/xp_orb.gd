extends Area2D

var xp_value := 1
var magnet_speed := 120.0
var _player = null
var _active := false

func setup(pos: Vector2, value: int):
	global_position = pos
	xp_value = value
	visible = true
	_player = get_tree().get_first_node_in_group("player")
	_active = true
	set_process(true)

func _process(delta):
	if _player == null or not _active:
		return
	# Magnetic pull when player is close
	var dist = global_position.distance_to(_player.global_position)
	if dist < 150.0:
		var dir = (_player.global_position - global_position).normalized()
		global_position += dir * magnet_speed * delta

func _on_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		var player = area.get_parent()
		player.gain_xp(xp_value)
		_reset()

func _reset():
	_active = false
	visible = false
	set_process(false)
