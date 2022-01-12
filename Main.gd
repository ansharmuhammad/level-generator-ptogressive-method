extends Node2D

var generator: GeneratorMain
var result: Graph

func _ready():
	generator = GeneratorMain.new()
	result = generator.generate()
