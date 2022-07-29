extends Control

func _process(delta):
	var player = Global.Player
	$HpBar.max_value = Global.Player.maxHealth
	$HpBar.value = Global.Player.health
	$ExpBar.value = Global.Exp
