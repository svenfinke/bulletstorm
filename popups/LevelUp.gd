extends Control

func _on_AnimationPlayer_animation_finished(anim_name):
	pass


func _on_AudioStreamPlayer_finished():
	queue_free()
