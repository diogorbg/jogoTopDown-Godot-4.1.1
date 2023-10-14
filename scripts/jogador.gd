extends CharacterBody2D
class_name Jogador

const SPEED = 200.0

static var jogador: Jogador

@onready var sprite = $sprite
@onready var anim = $anim
@onready var anim2 = $anim2
@onready var centerSpell = $centerSpell

var direcao: Vector2
var hp: int = 100

func _init():
	jogador = self

func _physics_process(_delta):
	# Atualiza a direção do personagem com base nas entradas do teclado
	direcao = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down"),
	)
	
	# Atualiza a animação do personagem com base na direção do movimento. Se houver.
	if direcao.length() > 0.1:
		anim.play("mover")
		if direcao.x > 0: sprite.flip_h = false
		if direcao.x < 0: sprite.flip_h = true
	else:
		anim.play("parado")

	# Aplica a direção ao movimento do personagem
	velocity = direcao.normalized() * SPEED

	# Move o personagem
	move_and_slide()

func addHit(damage: int):
	if hp <= 0: return
	
	hp -= damage
	if hp <= 0:
		hp = 0
		anim.play("morrer")
		set_physics_process(false) # Não executar _physics_process() do personagem
		desativarNode(centerSpell)
		get_tree().call_group("spawner", "stop")
		get_tree().call_group("inimigo", "stop")
		HUD.showDerrota()
	HUD.setHp(hp, 100)
	anim2.play("dano")

# Desativa o processamento e gráficos de um node
func desativarNode(node: Node):
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()

# Ativar o processamento e gráficos de um node
func ativarNode(node:Node):
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()
