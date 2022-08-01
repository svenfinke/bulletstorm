extends KinematicBody2D

var Exp = preload("res://Entities/Objects/Exp.tscn")
var FloatingText = preload("res://Entities/Objects/FloatingText.tscn")

var velocity = Vector2.ZERO
var speed = 50
var health = 10
var canHit = true
var damage = 1

func _physics_process(delta):
	if Global.Player == null:
		return
		
	var angle = get_angle_to(Global.Player.global_position)
	
	velocity.x = cos(angle)
	velocity.y = sin(angle)
	
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
		queue_free()
