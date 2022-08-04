extends GutTest

var EnemyClass = preload("res://Entities/Enemies/Enemy.gd")
var enemy : Enemy = null

func _ready():
	enemy = EnemyClass.new()

func test_get_hit_by__health_is_reduced_by_dmg():
	var hitter = Node2D.new()
	Global.DefaultParent = hitter
	enemy.health = 30
	enemy.get_hit_by(hitter, 10)
	
	self.assert_eq(enemy.health, 20, "Health should've been reduced by 10.")
