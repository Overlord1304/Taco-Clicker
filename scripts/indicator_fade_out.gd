extends Label

func _on_timer_timeout() -> void:
	var spawn_pos = position
	spawn_pos.x += randf_range(-10, 10)

	
	spawn_pos.y -= 25  
	position = spawn_pos

	var tween = create_tween()

	
	var target_pos = Vector2(position.x, position.y - 50)
	tween.tween_property(self, "position", target_pos, 0.5)

	
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(Callable(self, "queue_free"))
