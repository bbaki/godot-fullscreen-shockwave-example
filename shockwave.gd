extends CanvasLayer

@onready var shockwave_renderer: ColorRect = $ShockwaveRenderer

func trigger_shockwave(target_global_position: Vector2) -> void:
	shockwave_renderer.trigger_shockwave(target_global_position)
