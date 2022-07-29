extends Area2D

var FloatingText = preload("res://Entities/Objects/FloatingText.tscn")

export (int) var amount = 5

func _on_Area2D_body_entered(body):
	Global.Exp += amount
	var text = FloatingText.instance()
	text.amount = amount
	text.textColor = Color("43eb06")
	text.global_position = global_position
	Global.DefaultParent.add_child(text)
	queue_free()
