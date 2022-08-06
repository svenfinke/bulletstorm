extends KinematicBody2D
class_name Projectile

var velocity = Vector2(1,0)
var speed = 100

export var look_once = true

func _ready():
	if Global.SoundEnabled:
		$AudioStreamPlayer.play()

func _physics_process(delta):
	if Global.Pause:
		return
		
	if !$Sprite.visible:
		return
		
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	
	var collider = move_and_collide(velocity.rotated(rotation) * speed * delta)
	if collider && collider.get_collider().has_method('get_hit_by'):
		collider.get_collider().get_hit_by(self, 4 * Global.Player.level)
		_self_destroy()

func _on_VisibilityNotifier2D_screen_exited():
	_self_destroy()

func _self_destroy() -> void:
	$Sprite.visible = false
	$FreeDelay.start()
	
func _on_FreeDelay_timeout():
	queue_free()
