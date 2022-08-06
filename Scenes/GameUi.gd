extends Control

onready var HpBar : Node = $HpBar
onready var ExpBar : Node = $ExpBar
onready var LevelIndicator : Node = $CurrentLevelBg/CurrentLevel

func _process(delta):
	var player = Global.Player
	HpBar.max_value = Global.Player.maxHealth
	HpBar.value = Global.Player.health
	ExpBar.value = Global.Exp
	ExpBar.max_value = Global.Player.expToNextLevel
	LevelIndicator.text = String(Global.Player.level)
