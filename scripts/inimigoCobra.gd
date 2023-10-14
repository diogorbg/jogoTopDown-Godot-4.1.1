extends CharacterBody2D

@export var speed: float = 100.0

@onready var anim = $anim
@onready var sprite = $sprite
@onready var collision = $collision

# Status
var hp: int = 1

# Ataque
var atacar: bool = false
var _alvo: Node2D

func _init():
	Global.addInimigo(1)
	
# Para a execução do inimigo
func stop():
	set_physics_process(false) # Não executar _physics_process() do inimigo
	if hp > 0: anim.play("parado")

func _physics_process(_delta):
	if hp <= 0 || _alvo != null: return
#	if Jogador.jogador == null: return

	var dist = global_position.direction_to(Jogador.jogador.global_position)

	if dist.length() > 32:
		anim.play("parado")
	else:
		anim.play("mover")
		var dir = dist.normalized()
		if dir.x < 0: sprite.flip_h = true
		if dir.x > 0: sprite.flip_h = false
		velocity = dir * speed
		move_and_slide()

func addHit(damage: int):
	hp -= damage
	if hp <= 0:
		collision.set_deferred("disabled", true)
		anim.play("morrer")
		Global.addInimigo(-1)

# Função chamada pela animação. Quadro exato de ataque do inimigo
func anim_addHit():
	_alvo.addHit(1)

# Função chamada pela animação. Fim da animação de ataque
func anim_fimAtaque():
	if !atacar: _alvo = null

func _on_addHit_body_entered(body):
	if hp > 0 && body.is_in_group("jogador"):
		atacar = true
		_alvo = body
		anim.play("atacar")

func _on_addHit_body_exited(body):
	# Se for o mesmo body, então o ataque deve parar
	if hp > 0 && body == _alvo:
		atacar = false
