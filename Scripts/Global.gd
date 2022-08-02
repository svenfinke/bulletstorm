extends Node

var FloatingText = load("res://Entities/Objects/FloatingText.tscn")

var Player : Node = null
var Exp : int = 0
var DefaultParent : Node = null
var Pause : bool = false

func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		Pause = !Pause

func instance_node(scene: PackedScene, location: Vector2, parent: Node) -> Node:
	if !parent:
		return null
		
	var node_instance = scene.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func show_text(text: String, location: Vector2, parent: Node, color: Color = Color("eb0606")) -> void:
	var floatingText = FloatingText.instance()
	floatingText.text = text
	floatingText.global_position = location
	parent.add_child(floatingText)

func get_closest_body(character: Node, areaOfSight: Area2D) -> Node:
	var bodies = areaOfSight.get_overlapping_bodies()
	var closestBody = null
	if bodies.size() > 0:
		var minDistance = 9999.99;
		for body in bodies:
			var distance = character.global_position.distance_to(body.global_position)
			if distance < minDistance:
				minDistance = distance
				closestBody = body
	return closestBody
