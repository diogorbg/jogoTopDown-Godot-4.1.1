extends CanvasLayer
class_name HUD

@onready var slider = $slider as HSlider
@onready var numInimigos = %numInimigos as Label
@onready var sliderHp = $sliderHp as HSlider
@onready var labelHp = $sliderHp/labelHp as Label

@onready var timer = $timer as Timer
@onready var rectPause = $rectPause as ColorRect
@onready var butContinuar = %butContinuar as Button
@onready var rectVitoria = $rectVitoria as ColorRect
@onready var butProxima = %butProxima as Button
@onready var rectDerrota = $rectDerrota as ColorRect
@onready var butReiniciar = %butReiniciar as Button

static var _self: HUD = null
var podePausar: bool = true

func _ready():
	_self = self
	HUD.setWave(0, 1)
	HUD.setInimigos(0)
	HUD.setHp(100, 100)

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		if podePausar && get_tree().paused==false:
			showPause()
		elif podePausar && get_tree().paused==true:
			_on_butContinuar_pressed()

# Quando a fase encerrar
func _exit_tree():
	_self = null
	get_tree().paused = false

static func setWave(wave: int, maxWave: int):
	if _self:
		_self.slider.value = float(wave) / float(maxWave) * 100

static func setInimigos(inimigos: int):
	if _self:
		_self.numInimigos.text = str(inimigos)

static func setHp(hp: int, maxHp: int):
	if _self:
		_self.sliderHp.value = float(hp) / float(maxHp) * 100
		_self.labelHp.text = str("HP: %d" % hp)

func showPause():
	get_tree().paused = true
	rectPause.show()
	butContinuar.grab_focus()

static func showVitoria(): _self._showVitoria()
func _showVitoria():
	podePausar = false
	# aguarda 1 segundo
	timer.start(1)
	await timer.timeout
	# mostra a tela de vitória
	get_tree().paused = true
	rectVitoria.show()
	butProxima.grab_focus()

static func showDerrota(): _self._showDerrota()
func _showDerrota():
	podePausar = false
	# aguarda 1 segundo
	timer.start(1)
	await timer.timeout
	# mostra a tela de derrota
	get_tree().paused = true
	rectDerrota.show()
	butReiniciar.grab_focus()

func _on_butProxima_pressed():
	if Global.fase == 1:
		get_tree().change_scene_to_file("res://cenas/fase2.tscn")
	else:
		get_tree().change_scene_to_file("res://cenas/fase1.tscn")

func _on_butReiniciar_pressed():
	if Global.fase == 1:
		get_tree().change_scene_to_file("res://cenas/fase1.tscn")
	else:
		get_tree().change_scene_to_file("res://cenas/fase2.tscn")


func _on_butHome_pressed():
	get_tree().change_scene_to_file("res://cenas/menu.tscn")

func _on_butContinuar_pressed():
	get_tree().paused = false
	rectPause.hide()
