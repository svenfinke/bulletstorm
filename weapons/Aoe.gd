extends Position2D
class_name Aoe

var enemies = []

func _ready():
	if Global.SoundEnabled:
		$AudioStreamPlayer.play()

func _on_DmgTimer_timeout():
	do_damage()

func do_damage() -> void:
	for enemy in enemies:
		if enemy.has_method('get_hit_by'):
			enemy.get_hit_by(self, 30)

func _on_Area2D_body_entered(body):
	enemies.push_back(body)

func _on_Area2D_body_exited(body):
	var index = enemies.find(body)
	if index > -1:
		enemies.remove(index)

func _on_Lifetime_timeout():
	queue_free()
