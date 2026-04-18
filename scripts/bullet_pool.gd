extends Node

const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const POOL_SIZE = 140

var _pool: Array = []

func _ready():
	for i in POOL_SIZE:
		var b = BULLET_SCENE.instantiate()
		b.visible = false
		b.set_process(false)
		b.monitoring = false
		add_child(b)
		_pool.append(b)

func spawn(pos: Vector2, dir: Vector2, spd: float, dmg: int, pierce_count := 0):
	for b in _pool:
		if not b.visible:
			b.global_position = pos
			b.direction = dir
			b.speed = spd
			b.damage = dmg
			b.pierce = pierce_count
			b._age = 0.0
			b.visible = true
			b.monitoring = true
			b.set_process(true)
			return
