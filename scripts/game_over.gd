extends Control

func _on_retry_pressed() -> void:
	get_tree().paused = false
	GameManager.elapsed_time = 0.0
	GameManager.running = true
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
