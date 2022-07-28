extends Area2D

export (int) var amount = 5

func _on_Area2D_body_entered(body):
	Global.Exp += amount
	queue_free()
