extends KinematicBody2D
class_name Player

var FloatingText = preload("res://Entities/Objects/FloatingText.tscn")
var Gun = preload("res://Entities/Weapons/Gun.tscn")
var LevelUp = preload("res://Entities/Dialogues/LevelUp.tscn")

var speed : float = 80.0
var health : int = 5
var maxHealth : int = 5
var expToNextLevel : int = 20
var level : int = 1

var closestEnemy = null

func _ready():
	Global.Player = self
	
func _process(delta):
	if Global.Exp >= expToNextLevel:
		level_up()

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1.0
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1.0
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1.0
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1.0
		
	velocity = velocity.normalized()

	move_and_slide(velocity * speed)

func shoot():
	var enemy = get_closest_enemy()
	
	if enemy:
		var gun = Global.instance_node(Gun, global_position, Global.DefaultParent)
		gun.look_once = false
		gun.look_at(enemy.global_position)

func _on_ShootTimer_timeout():
	shoot()

func hit():
	health -= 1
	var text = FloatingText.instance()
	text.amount = 1
	text.global_position = global_position
	Global.DefaultParent.add_child(text)
	
	if health <= 0:
		Global.Player = null
		queue_free()

func get_closest_enemy():
	var bodies = $AreaOfSight.get_overlapping_bodies()
	var closestBody = null
	if bodies.size() > 0:
		var minDistance = 9999.99;
		for body in bodies:
			var distance = global_position.distance_to(body.global_position)
			if distance < minDistance:
				minDistance = distance
				closestBody = body
	return closestBody

func level_up():
	Global.instance_node(LevelUp, global_position, Global.DefaultParent)
	expToNextLevel += expToNextLevel * 0.3
	Global.Exp = 0
	level += 1
