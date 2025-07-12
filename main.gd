extends Node2D

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var click_position = get_global_mouse_position()
		Shockwave.trigger_shockwave(click_position)
