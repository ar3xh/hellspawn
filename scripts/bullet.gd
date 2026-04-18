extends Area2D

var direction := Vector2.RIGHT
var speed := 300.0
var damage := 1
var pierce := 0
var lifetime := 2.0
var _age := 0.0

func _process(delta):
	global_position += direction * speed * delta
	_age += delta
	if _age >= lifetime:
		_reset()

func _on_area_entered(area):
	if area.is_in_group("enemy_hitbox"):
		var enemy = area.get_parent()
		if enemy and enemy.has_method("take_damage"):
			enemy.take_damage(damage)
		_register_hit()

func _register_hit() -> void:
	if pierce > 0:
		pierce -= 1
		return
	_reset()

func _reset():
	_age = 0.0
	visible = false
	monitoring = false
	set_process(false)
