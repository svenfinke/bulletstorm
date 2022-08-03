extends Node2D

var enemySkeleton = preload("res://Entities/Enemies/Skeleton.tscn")
var enemyPriest = preload("res://Entities/Enemies/Priest.tscn")

func _ready():
	Global.DefaultParent = self
	Global.Player = $Player
	$CanvasLayer/GameUI.visible = true

func _on_EnemySpawnTimer_timeout():
	if Global.Pause:
		return
	
	var screenWidth = get_viewport_rect().size.x
	var screenHeight = get_viewport_rect().size.y
	
	var left = $Player.global_position.x - (screenWidth / 2)
	var right = $Player.global_position.x + (screenWidth / 2)
	var top = $Player.global_position.y - (screenHeight / 2)
	var down = $Player.global_position.y + (screenHeight / 2)
	
	var posX = rand_range(left - 100, right + 100)
	var posY = rand_range(top - 100, down + 100)
	
	while((posX > left and posX < right) and (posY > top and posY < down)):
		posX = rand_range(left - 100, right + 100)
		posY = rand_range(top - 100, down + 100)

	Global.instance_node(_get_random_enemy(), Vector2(posX, posY), Global.DefaultParent)

func _on_Knight_tree_exiting():
	get_tree().change_scene("res://Scenes/Dead.tscn")

func _on_BackgroundLoop_finished():
	$BackgroundLoop.play()

func _get_random_enemy()->PackedScene:
	var randomInt = rand_range(0,10)
	
	if randomInt <= 3:
		return enemyPriest
	else:
		return enemySkeleton
