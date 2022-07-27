extends Node2D

var Enemy01 = preload("res://Enemies/Enemy.tscn")

func _on_EnemySpawnTimer_timeout():
	var minPosX = $Knight/MainCamera.global_position.x - 50
	var maxPosX = $Knight/MainCamera.global_position.x + get_viewport_rect().size.x + 50
	var minPosY = $Knight/MainCamera.global_position.y - 50
	var maxPosY = $Knight/MainCamera.global_position.y + + get_viewport_rect().size.y + 50
	
	var posX = rand_range(minPosX, maxPosX)
	var posY = rand_range(minPosY, maxPosY)
	
	while(posX in range($Knight/MainCamera.global_position.x, $Knight/MainCamera.global_position.x + get_viewport_rect().size.x) 
		and posY in range($Knight/MainCamera.global_position.y, $Knight/MainCamera.global_position.y + + get_viewport_rect().size.y)
	):
		posX = rand_range(minPosX, maxPosX)
		posY = rand_range(minPosY, maxPosY)

	Global.instance_node(Enemy01, Vector2(posX, posY), get_parent())
