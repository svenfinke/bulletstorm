extends KinematicBody2D
class_name Gun

var velocity = Vector2(1,0)
var speed = 250

export var look_once = true

func _physics_process(delta):
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	
	var collider = move_and_collide(velocity.rotated(rotation) * speed * delta)
	if collider:
		collider.get_collider().hit()
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
