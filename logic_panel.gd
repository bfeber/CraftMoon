extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		var gadget := get_tree().get_first_node_in_group("Dragging") as Gadget
		if gadget:
			# Place Gadget
			gadget.get_parent().remove_child(gadget)
			add_child(gadget)
			gadget.remove_from_group("Dragging")
			gadget.position = get_local_mouse_position() - gadget.size / 2
			gadget.position = gadget.position.clamp(Vector2.ZERO, size - gadget.size)
			#gadget.position = gadget.position.snapped(Vector2(128, 128))
			gadget.mouse_filter = Control.MOUSE_FILTER_STOP
