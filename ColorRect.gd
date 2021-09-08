extends ColorRect

var x
var y

var node_to_call="../../../"


func _on_Button_pressed():
	var node=get_node(node_to_call)
	var i =node.list[x][y]
	match i:
		0:
			node.list[x][y]=1
			color=node.couleur2
		1:
			node.list[x][y]=0
			color=node.couleur1
