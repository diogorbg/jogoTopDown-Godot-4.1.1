extends Control

@onready var butNovo = $butNovo

func _ready():
	butNovo.grab_focus()

func _on_bot_novo_pressed():
	get_tree().change_scene_to_file("res://cenas/fase1.tscn")

func _on_bot_sair_pressed():
	get_tree().quit()
