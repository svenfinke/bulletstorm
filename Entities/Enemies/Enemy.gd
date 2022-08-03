extends KinematicBody2D
class_name Enemy

var Exp = preload("res://Entities/Objects/Exp.tscn")
var FloatingText = preload("res://Entities/Objects/FloatingText.tscn")

onready var  animation_mode = $AnimationTree.get("parameters/playback")

export (int) var damage = 1
export (int) var speed = 50
export (int) var health = 10
export (int) var dropExp = 10

var velocity = Vector2.ZERO
var lastVelocity = Vector2.ZERO
var canHit = true

func _physics_process(delta):
	if Global.Player == null:
		return
	
	if Global.Pause:
		return
		
	if health <= 0:
		return
		
	var angle = get_angle_to(Global.Player.global_position)
	
	velocity.x = cos(angle)
	velocity.y = sin(angle)
	
	if velocity != Vector2.ZERO:
		lastVelocity = velocity
	
	$AnimationTree.set('parameters/Walk/blend_position', lastVelocity)
	
	var collider = move_and_collide(velocity * speed * delta)
	if collider:
		if collider.collider.has_method("get_hit_by") && canHit:
			canHit = false
			$HitTimer.start()
			collider.collider.get_hit_by(self, damage)

func _on_HitTimer_timeout():
	canHit = true
	
func get_hit_by(hitter: Node, hitDamage: int) -> void:
	health -= hitDamage
	Global.show_text(String(hitDamage), global_position, Global.DefaultParent)
	
	if health <= 0:
		# Spawn loot
		Global.instance_node(Exp, global_position, Global.DefaultParent)
		$AudioStreamPlayer.play()
		$CollisionShape2D.disabled = true
		$Sprite.visible = false

func _on_AudioStreamPlayer_finished():
	queue_free()
