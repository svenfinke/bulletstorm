extends KinematicBody2D

export (int) var speed = 80.0
export (PackedScene) var Gun
export (int) var health = 5

var closestEnemy = null

func _ready():
	Global.Player = self

func _physics_process(delta):
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
