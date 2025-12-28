extends CanvasLayer

var overlay_scene: Node
var transition_time := 0.67 #>:D

func swipe_in(scene_path: String, direction := 1):
	overlay_scene = load(scene_path).instantiate()
	overlay_scene.set_meta("swipe", self)
	$holder.add_child(overlay_scene)

	var screen_width = get_viewport().get_visible_rect().size.x
	overlay_scene.position.x = direction * screen_width

	var tween = create_tween()
	tween.tween_property(
		overlay_scene,
		"position:x",
		0,
		transition_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
func swipe_out(direction := 1):
	if overlay_scene == null:
		queue_free()
		return

	var screen_width = get_viewport().get_visible_rect().size.x

	var tween = create_tween()
	tween.tween_property(
		overlay_scene,
		"position:x",
		-direction * screen_width,
		transition_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	overlay_scene.queue_free()
	queue_free()
