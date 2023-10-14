extends Node

var inimigos: int = 0
var waves : int = 0
var maxWaves: int = 0

var fase: int = 1

func vitoria():
	HUD.showVitoria()

func reset():
	inimigos = 0
	waves = 0
	maxWaves = 0

func addInimigo(num: int):
	inimigos += num
	HUD.setInimigos(inimigos)
	if num<0 && inimigos==0 && waves==maxWaves:
		vitoria()

func addMaxWave(num: int):
	maxWaves += num
	HUD.setWave(waves, maxWaves)

func addWave(num: int):
	waves += num
	HUD.setWave(waves, maxWaves)
