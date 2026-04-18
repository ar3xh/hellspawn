extends Node

var base_fire_rate := 0.4
var projectile_count := 1
var spread_degrees := 0.0
var damage_mult := 1.0
var speed_mult := 1.0
var pierce := 0

var _timer := 0.0

func _ready() -> void:
	_apply_selected_weapon()

func _apply_selected_weapon() -> void:
	var cfg = GameManager.get_weapon_config()
	base_fire_rate = cfg.fire_rate
	projectile_count = cfg.projectiles
	spread_degrees = cfg.spread_degrees
	damage_mult = cfg.damage_mult
	speed_mult = cfg.speed_mult
	pierce = cfg.pierce

func _process(delta):
	_timer -= delta
	if _timer <= 0.0:
		_fire()
		_timer = base_fire_rate / get_parent().stats.fire_rate_mult

func _fire():
	var player = get_parent()
	var mouse_pos = player.get_global_mouse_position()
	var base_dir = (mouse_pos - player.global_position).normalized()
	if base_dir == Vector2.ZERO:
		base_dir = Vector2.RIGHT

	for i in projectile_count:
		var spread_offset := 0.0
		if projectile_count > 1:
			var t = float(i) / float(projectile_count - 1)
			spread_offset = lerp(-spread_degrees * 0.5, spread_degrees * 0.5, t)
		var dir = base_dir.rotated(deg_to_rad(spread_offset))
		BulletPool.spawn(
			player.global_position,
			dir,
			player.stats.bullet_speed * speed_mult,
			max(1, int(round(player.stats.damage * damage_mult))),
			pierce
		)
