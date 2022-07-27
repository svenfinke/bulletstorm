extends KinematicBody2D

export (int) var speed = 80.0
export (PackedScene) var Gun
export (int) var health = 5

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
	Global.instance_node(Gun, global_position, get_parent())


func _on_ShootTimer_timeout():
	shoot()

func hit():
	health -= 1
	if health <= 0:
		Global.Player = null
		queue_free()
