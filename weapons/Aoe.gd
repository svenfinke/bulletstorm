extends Position2D
class_name Aoe

var enemies = []

var dmg : int = 30

func do_damage() -> void:
	for enemy in enemies:
		if enemy.has_method('get_hit_by'):
			enemy.get_hit_by(self, dmg)

func do_upgrade(upgrade: WeaponUpgradeResource) -> void:
	dmg += upgrade.dmgInc
	pass

func _on_Area2D_body_entered(body):
	enemies.push_back(body)

func _on_Area2D_body_exited(body):
	var index = enemies.find(body)
	if index > -1:
		enemies.remove(index)

func _on_Lifetime_timeout():
	queue_free()

func _on_DmgTimer_timeout():
	do_damage()
	
func _ready():
	if Global.SoundEnabled:
		$AudioStreamPlayer.play()
