extends Node2D
class_name BaseScene


###########################################
@onready var player
@onready var mouse_on_ui : bool = false
var dragging = false  # are we currently dragging?
var selected = []  # array of selected units
var drag_start = Vector2.ZERO  # location where the drag begian
var select_rect = RectangleShape2D.new()
var gridSize: int = 16

var selection_value = "ally":
	set = set_selection_value

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Player.selection_mode == true:# and mouse_on_ui == false:

		if event.pressed:
		
			# If the mouse was clicked and nothing is selected, start dragging
			if selected.size() == 0:
			
				dragging = true
				drag_start = get_global_mouse_position()
			# Otherwise a click tells the selected units to move
			else:

				for item in selected:
					print(item)
					if is_instance_valid(item) and item.has_method("set_selected") and item.is_in_group(selection_value) and item.is_in_group(str(Player.selection_mode_type)):
						item.target = get_global_mouse_position()
						item.selected = false
				selected = []
		# If the mouse is released and is dragging, stop dragging and select the units
		elif dragging:

			dragging = false
			queue_redraw()
			var drag_end = get_global_mouse_position()
			var select_rect = Rect2(drag_start, drag_end - drag_start).abs()

			# Reset the selected array
			selected.clear()

	
			# Iterate through all nodes in the current scene
			for node in get_tree().get_nodes_in_group("selectable"):  # Assuming your selectable nodes are in a group named "selectable"
				if is_node_within_selection(node, select_rect):
					if node.has_method("set_selected"):  # Check if the node can be selected
						node.selected = true
						selected.append(node)  # Add to the selected list
			print(selected)
			for item in selected:
							
		
				if item.has_method("set_selected"):
					print("SELECTED")
					item.selected = true
			
	if event is InputEventMouseMotion and dragging:
		queue_redraw()
		# Function to check if a node is within the rectangle
		
func is_node_within_selection(node, rect):
	var pos = node.global_position
	return rect.has_point(pos)
	

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
				Color.GREEN, false, 2.0)
		
func set_selection_value(value : String):
	selection_value = value
