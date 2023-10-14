extends Node2D

@export var fase: int = 1

# Garante que será chadado antes de todos os scripts _ready()
func _init():
	Global.reset()

# Só pode setar o número da fase após carregar corretamente a cena
func _ready():
	Global.fase = fase
