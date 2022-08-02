extends KinematicBody2D
class_name Player

var FloatingText = preload("res://Entities/Objects/FloatingText.tscn")
var Gun = preload("res://Entities/Weapons/Gun.tscn")
var LevelUp = preload("res://Entities/Dialogues/LevelUp.tscn")

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

var _closestEnemy = null
var lastVelocity = Vector2.ZERO

func _ready():
	Global.Player = self
	
func _process(_delta):
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
	if velocity != Vector2.ZERO:
		lastVelocity = velocity
		animation_mode.travel("Walk")
	else:
		animation_mode.travel("Idle")
	
	$AnimationTree.set('parameters/Walk/blend_position', lastVelocity)
	$AnimationTree.set('parameters/Idle/blend_position', lastVelocity)

	move_and_slide(velocity * speed * movementSpeedMod)

func _on_ShootTimer_timeout():
	shoot()

func shoot() -> void:
	var enemy = Global.get_closest_body(self, $AreaOfSight)
	
	if enemy:
		var gun = Global.instance_node(Gun, global_position, Global.DefaultParent)
		gun.look_once = false
		gun.look_at(enemy.global_position)

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
