extends Node

# Load the XP orb scene we made earlier
const XP_ORB_SCENE = preload("res://scenes/xp_orb.tscn")
const POOL_SIZE = 50

var _pool: Array = []

func _ready():
	# At game start, create 50 orbs — all hidden and inactive
	for i in POOL_SIZE:
		var orb = XP_ORB_SCENE.instantiate()
		orb.visible = false
		orb.set_process(false)
		add_child(orb)
		_pool.append(orb)

# Call this when an enemy dies
# pos = where the enemy was, value = how much XP to give
func spawn(pos: Vector2, value: int):
	for orb in _pool:
		if not orb.visible:
			orb.setup(pos, value)
			return
	# If all 50 are in use, do nothing (rare edge case)
