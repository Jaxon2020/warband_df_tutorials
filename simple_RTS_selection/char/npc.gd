extends CharacterBody2D

const speed = 300.0
var target

var selected = false:
	set = set_selected

func _physics_process(delta):
	if target != null:
		simple_movetoposition(target, 20, self)

func simple_movetoposition(target, range, body):
	var _direction_to_target = target - body.global_position
	if _direction_to_target.length() >= range:
		var direction_to_target = body.global_position.direction_to(target)
	# Calculate the velocity towards the target
		body.velocity = direction_to_target * body.speed
		body.move_and_slide()
		
	elif _direction_to_target.length() < range:
		body.velocity = Vector2.ZERO

func set_selected(value):
	selected = value
	var troops = get_tree().get_first_node_in_group("selected_troops")
	if selected:
		add_to_group("selected_troops")
		print("SELECTED")
	else:
		print("UNSELECTED")
		remove_from_group("selected_troops")
		
