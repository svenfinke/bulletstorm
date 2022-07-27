extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 50
var health = 3
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

func hit():
	health-=1;
	if health <= 0:
		queue_free()


func _on_HitTimer_timeout():
	canHit = true