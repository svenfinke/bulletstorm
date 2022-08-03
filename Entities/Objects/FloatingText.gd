extends Position2D

export (String) var text = "0"
export (Color) var textColor = Color("eb0606")

func _ready():
	$Label.text = text
	$Label.set("custom_colors/font_color", textColor)
	
	$Tween.interpolate_property(self, 'scale', scale, Vector2(0.6,0.6), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property(self, 'scale', Vector2(0.6,0.6), Vector2(0.1,0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 1)
	$Tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
