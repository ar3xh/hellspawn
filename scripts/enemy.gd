extends CharacterBody2D

var move_speed := 60.0
var hp := 3
var xp_value := 1
var touch_damage := 1

var _player: Node2D = null
var _touch_cooldown := 0.0

func _ready():
	_player = get_tree().get_first_node_in_group("player")
	var difficulty = GameManager.get_difficulty_config()
	hp = int(round(hp * difficulty.enemy_hp_mult))
	move_speed *= difficulty.enemy_speed_mult
	$Hitbox.add_to_group("enemy_hitbox")

func _physics_process(delta):
	if _player == null:
		return

	_touch_cooldown = max(0.0, _touch_cooldown - delta)
	var dir = (_player.global_position - global_position).normalized()
	velocity = velocity.move_toward(dir * move_speed, 700.0 * delta)
	move_and_slide()

func take_damage(amount: int):
	hp -= amount
	if hp <= 0:
		_die()

func _die():
	XPOrbPool.spawn(global_position, xp_value)
	queue_free()

func _on_hitbox_area_entered(area):
	if area.is_in_group("player_hurtbox") and _touch_cooldown <= 0.0:
		_player.take_damage(touch_damage)
		_touch_cooldown = 0.45
