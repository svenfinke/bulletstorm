extends KinematicBody2D
class_name Player

var FloatingText = preload("res://popups/FloatingText.tscn")
var Fireball = preload("res://weapons/Fireball.tscn")
var ExplosionPool = preload("res://weapons/ExplosionPool.tscn")
var LevelUp = preload("res://popups/LevelUp.tscn")

onready var  animation_mode = $AnimationTree.get("parameters/playback")

const speed : int = 80

# Attributes
var maxHealth : int = 5
var health : int = 5
var currentExp : int = 0
var expToNextLevel : int = 20
var level : int = 1
var armor : int = 0

# Modifiers
var attackPowerMod : float = 1.0
var attackSpeedMod : float = 1.0
var armorMod : float = 1.0
var movementSpeedMod : float = 1.0
var aoeDelay : int = 5

var lastVelocity = Vector2.ZERO
var currentAoeDelay : int = 0

func _ready():
	Global.Player = self
	
func _process(_delta):
	if Global.Exp >= expToNextLevel:
		level_up()

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	
	if Global.Pause:
		return
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1.0
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1.0
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1.0
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1.0
		
	velocity = velocity.normalized()
	if velocity != Vector2.ZERO:
		lastVelocity = velocity
		animation_mode.travel("Walk")
	else:
		animation_mode.travel("Idle")
	
	$AnimationTree.set('parameters/Walk/blend_position', lastVelocity)
	$AnimationTree.set('parameters/Idle/blend_position', lastVelocity)

	move_and_slide(velocity * speed * movementSpeedMod)

func _on_ShootTimer_timeout():
	if !Global.Pause:
		shoot()

func shoot() -> void:
	var enemy = Global.get_closest_body(self, $EnemyDetectionArea)
	
	if enemy != null:
		var fireball = Global.instance_node(Fireball, global_position, Global.DefaultParent)
		fireball.look_once = false
		fireball.look_at(enemy.global_position)
	
	if currentAoeDelay <= 0:
		Global.instance_node(ExplosionPool, get_random_positon_in_detection_area(), Global.DefaultParent)
		currentAoeDelay = aoeDelay
	else:
		currentAoeDelay -= 1

func level_up() -> void:
	Global.instance_node(LevelUp, global_position, Global.DefaultParent)
	expToNextLevel += expToNextLevel * 0.3
	Global.Exp = 0
	level += 1

func get_hit_by(hitter: Node, damage: int) -> void:
	var dmg : int = damage - (armor * armorMod)
	health -= dmg
	Global.show_text(String(dmg), global_position, Global.DefaultParent)
	
	if health <= 0:
		Global.Player = null
		queue_free()

func attrackt_object(obj: Node) -> void:
	if obj.has_method("attract"):
		obj.attract()

func _on_ObjectMagnetArea_body_entered(body):
	attrackt_object(body)

func get_random_positon_in_detection_area() -> Vector2:
	var radius = $EnemyDetectionArea/CollisionShape2D.shape.radius * 0.6
	var x : int = rand_range(global_position.x - radius, global_position.x + radius)
	var y : int = rand_range(global_position.y - radius, global_position.y + radius)
	
	var minVector : Vector2 = Vector2(global_position.x - 10, global_position.y - 10)
	var maxVector : Vector2 = Vector2(global_position.x + 10, global_position.y + 10)
	
	while (x > minVector.x and x < maxVector.x) or (y > minVector.y and y < maxVector.y):
		x = rand_range(global_position.x - radius, global_position.x + radius)
		y = rand_range(global_position.y - radius, global_position.y + radius)
	
	return Vector2(x,y)
