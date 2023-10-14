extends Node2D

@onready var timer = $timer

#@export var ySorted: Node2D
@export_enum("Cobra") var inimigo: int
@onready var vet: Array[Resource] = [
	preload("res://cenas/inimigoCobra.tscn"),
]

#@export_category("Valores")
@export var raio: float = 64.0
@export var tempo: float = 5.0
@export var qtdMin: int = 3
@export var qtdMax: int = 30
@export var waves: int = 10

var _wave: int = 0
var _qtd: float = 1

func _ready():
#	invokeWave()
	Global.addMaxWave(waves)
	timer.start(tempo)

func _on_timer_timeout(): invokeWave()

func invokeWave():
	Global.addWave(1)
	_wave += 1
	_qtd = lerpf(qtdMin, qtdMax, float(_wave-1) / float(waves-1))
	if _wave == waves: timer.stop()
	
	for i in range(_qtd):
		var obj = vet[inimigo].instantiate()
		obj.global_position = Vector2(randf_range(-raio, raio), randf_range(-raio, raio))
		add_child(obj)

# Para de spawnar inimigos
func stop(): timer.stop()
