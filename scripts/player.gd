extends CharacterBody2D

var speed := 300.0
var acceleration := 1800.0
var friction := 2200.0

var stats = {
	"hp": 5,
	"max_hp": 5,
	"xp": 0,
	"xp_to_level": 10,
	"level": 1,
	"damage": 1,
	"fire_rate_mult": 1.0,
	"bullet_speed": 800.0
}

func _ready():
	add_to_group("player")
	_apply_selected_character()

func _apply_selected_character() -> void:
	var cfg = GameManager.get_character_config()
	speed = cfg.speed
	stats.max_hp = cfg.hp
	stats.hp = cfg.hp
	stats.damage = cfg.damage
	stats.fire_rate_mult = cfg.fire_rate_mult
	stats.bullet_speed = cfg.bullet_speed
	stats.xp = 0
	stats.xp_to_level = 10
	stats.level = 1

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_velocity = input_dir * speed

	if input_dir.length() > 0.01:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
		$Sprite2D.flip_h = input_dir.x < 0
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

func take_damage(amount: int):
	stats.hp -= amount
	if stats.hp <= 0:
		die()

func die():
	GameManager.running = false
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func gain_xp(amount: int):
	var xp_gain = int(round(amount * GameManager.get_difficulty_config().xp_mult))
	stats.xp += max(1, xp_gain)
	if stats.xp >= stats.xp_to_level:
		stats.xp -= stats.xp_to_level
		stats.level += 1
		stats.xp_to_level = int(stats.xp_to_level * 1.45)
		GameManager.trigger_level_up()
