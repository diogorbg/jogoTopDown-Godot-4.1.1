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
	Global.addInimigo(1) # Adiciona na contagem de inimigos spawnados
	
# Para a execução do inimigo
func stop():
	set_physics_process(false) # Não executar _physics_process() do inimigo
	if hp > 0: anim.play("parado")

func _physics_process(_delta):
	if hp <= 0 || _alvo != null: return
#	if Jogador.jogador == null: return

	anim.play("mover")
	var distancia = global_position.direction_to(Jogador.jogador.global_position)
	var direcao = distancia.normalized()
	if direcao.x < 0: sprite.flip_h = true
	if direcao.x > 0: sprite.flip_h = false
	velocity = direcao * speed
	move_and_slide()

# Função onde o inimigo recebe dano
func addHit(dano: int):
	hp -= dano
	if hp <= 0:
		collision.set_deferred("disabled", true)
		anim.play("morrer")
		Global.addInimigo(-1)

# Função chamada pela animação. Quadro exato de ataque do inimigo
func anim_addHit():
	_alvo.addHit(1)
	# Aguarda o fim da animação de ataque
	await anim.animation_finished
	if hp > 0 && atacar:
		anim.play("atacar")
	else:
		_alvo = null

# Ao entrar na área que causa dabo
func _on_addHit_body_entered(body):
	if hp > 0 && body.is_in_group("jogador"):
		atacar = true
		_alvo = body
		anim.play("atacar")

# Ao sair da área de dano
func _on_addHit_body_exited(body):
	# Se for o mesmo _alvo, então o ataque deve parar
	if body == _alvo:
		atacar = false
