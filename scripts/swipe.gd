extends CanvasLayer

var current_scene: Node
var next_scene: Node
var transition_time := 0.67 #>:D

func swipe_to(scene_path: String, direction := 1):

	current_scene = get_tree().current_scene
	next_scene = load(scene_path).instantiate()

	var screen_width = get_viewport().get_visible_rect().size.x
	current_scene.get_parent().remove_child(current_scene)
	$holder.add_child(current_scene)
	$holder.add_child(next_scene)
	next_scene.position.x = direction * screen_width

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		current_scene,
		"position:x",
		-direction*screen_width,
		transition_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		next_scene,
		"position:x",
		0,
		transition_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished

	$holder.remove_child(next_scene)
	get_tree().root.add_child(next_scene)
	get_tree().current_scene=next_scene

	current_scene.queue_free()
	queue_free()
