extends KinematicBody2D

var Exp = preload("res://Entities/Objects/Exp.tscn")
var FloatingText = preload("res://Entities/Objects/FloatingText.tscn")

var velocity = Vector2.ZERO
var speed = 50
var health = 10
var canHit = true

func _physics_process(delta):
	if Global.Player == null:
		return
		
	var angle = get_angle_to(Global.Player.global_position)
	
	velocity.x = cos(angle)
	velocity.y = sin(angle)
	
	var collider = move_and_collide(velocity * speed * delta)
	if collider:
		if collider.collider.has_method("hit") && canHit:
			canHit = false
			$HitTimer.start()
			collider.collider.hit()

func hit(dmg:int):
	health-=dmg;
	var text = FloatingText.instance()
	text.amount = dmg
	text.global_position = global_position
	Global.DefaultParent.add_child(text)
	if health <= 0:
		Global.instance_node(Exp, global_position, Global.DefaultParent)
		queue_free()


func _on_HitTimer_timeout():
	canHit = true
