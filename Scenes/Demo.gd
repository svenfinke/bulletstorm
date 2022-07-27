extends Node2D

var Enemy01 = preload("res://Enemies/Enemy.tscn")

func _on_EnemySpawnTimer_timeout():
	
	var screenWidth = get_viewport_rect().size.x
	var screenHeight = get_viewport_rect().size.y
	
	var left = $Knight.global_position.x - (screenWidth / 2)
	var right = $Knight.global_position.x + (screenWidth / 2)
	var top = $Knight.global_position.y - (screenHeight / 2)
	var down = $Knight.global_position.y + (screenHeight / 2)
	
	var posX = rand_range(left - 100, right + 100)
	var posY = rand_range(top - 100, down + 100)
	
	while((posX > left and posX < right) and (posY > top and posY < down)):
		posX = rand_range(left - 100, right + 100)
		posY = rand_range(top - 100, down + 100)

	Global.instance_node(Enemy01, Vector2(posX, posY), get_parent())
