extends KinematicBody2D
class_name Enemy

var Exp = preload("res://objects/Exp.tscn")
var FloatingText = preload("res://popups/FloatingText.tscn")

onready var  animation_mode = $AnimationTree.get("parameters/playback")

export (int) var damage : int = 1
export (int) var speed : int = 50
export (int) var health : int = 10
export (int) var dropExp : int = 10
export (float) var stunThreshold : float = .5
export (float) var stunRecovery : float = .1


var velocity : Vector2 = Vector2.ZERO
var lastVelocity : Vector2 = Vector2.ZERO
var canHit : bool = true
var stunValue : float = 0

func _physics_process(delta):
	if Global.Player == null:
		return
	
	if Global.Pause:
		return
		
	if health <= 0:
		return
		
	_recover_stun()
	
	if _is_stunned():
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
	
func get_hit_by(hitter: Node, hitDamage: int, stunDmg: float = 2) -> void:
	health -= hitDamage
	stunValue += stunDmg
	
	Global.show_text(String(hitDamage), global_position, Global.DefaultParent)
	
	if health <= 0:
		# Spawn loot
		Global.instance_node(Exp, global_position, Global.DefaultParent)
		if Global.SoundEnabled:
			$AudioStreamPlayer.play()
		$CollisionShape2D.disabled = true
		$Sprite.visible = false

func _on_AudioStreamPlayer_finished():
	queue_free()

func _recover_stun() -> void:
	if stunValue > 0:
		stunValue -= stunRecovery
		if stunValue < 0:
			stunValue = 0

func _is_stunned() -> bool:
	if stunValue > stunThreshold:
		return true
	return false
