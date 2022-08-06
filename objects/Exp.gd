extends KinematicBody2D

var FloatingText = preload("res://popups/FloatingText.tscn")

export (int) var amount : int = 5
export(bool) var attracted : bool = false

export (int) var speed : int = 150

func _on_Area2D_body_entered(body):
	Global.Exp += amount
	Global.show_text(String(amount), global_position, Global.DefaultParent, Color("43eb06"))
	queue_free()
	
func attract():
	$Particles.emitting = true
	attracted = true

func _physics_process(delta):
	if !attracted:
		return
		
	var angle = get_angle_to(Global.Player.global_position)
	var velocity : Vector2 = Vector2.ZERO
	
	velocity.x = cos(angle)
	velocity.y = sin(angle)
	
	move_and_slide(velocity * speed * 1)
