extends Area2D

var FloatingText = preload("res://Entities/Objects/FloatingText.tscn")

export (int) var amount = 5

func _on_Area2D_body_entered(body):
	Global.Exp += amount
	Global.show_text(String(amount), global_position, Global.DefaultParent, Color("43eb06"))
	queue_free()
