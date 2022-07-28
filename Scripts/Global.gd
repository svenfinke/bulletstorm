extends Node

var Player
var Exp = 0
var DefaultParent = null

func instance_node(node, location, parent):
	if !parent:
		return null
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
