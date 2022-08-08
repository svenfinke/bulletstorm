extends Resource
class_name WeaponResource

enum DIRECTION { nearest, random, left, top, right, cross, x, left_right, top_bottom }

export(Script) var weaponScript : Script
export(PackedScene) var weaponScene : PackedScene
export(int) var currentLevel : int = 1
export(DIRECTION) var direction = DIRECTION.nearest
export(bool) var pierceEnemies : bool = false
export(Array, Resource) var upgrades

func level_up() -> void:
	currentLevel += 1
	var upgrade = _get_current_upgrade()
	weaponScript.do_upgrade(upgrade)
	pass
	
func shoot(playerNode: Node, detectionArea: Area2D) -> void:
	var enemy = Global.get_closest_body(playerNode, detectionArea)
	
	if enemy != null:
		var fireball = Global.instance_node(weaponScene, playerNode.global_position, Global.DefaultParent)
		fireball.look_once = false
		fireball.look_at(enemy.global_position)

func _get_current_upgrade() -> WeaponUpgradeResource:	
	for upgrade in upgrades:
		if upgrade.level == currentLevel:
			return upgrade
	
	return null
