class_name GeneratorMain

var file: File
enum VERTEX_TYPE {
	INIT,
	START,
	TASK,
	SECRET,
	OBSTACLE,
	REWARD,
	KEY,
	LOCK,
	GOAL
}

enum EDGE_TYPE {
	PATH,
	KEY_LOCK
}

var steps: Array
var _result

func _init():
	file = File.new()
	steps = []

func recipe() -> Array:
	var _steps: Array = []
	
	var stepInit = Step.new([RuleInit1.new(), RuleInit2.new()], 1)
	_steps.append(stepInit)
	
	var stepExtend = Step.new([RuleExtend1.new(), RuleExtend2.new(), RuleExtend3.new()], 3)
	_steps.append(stepExtend)
	
	var stepSecret = Step.new([RuleSecret.new()],1)
	_steps.append(stepSecret)
	
#	var stepOR = Step.new([RuleOR1.new(), RuleOR2.new()],5)
#	contraint obstacle 3 reward 2
#	steps.append(stepOR)

	var stepO = Step.new([RuleOR1.new()], 3)
	_steps.append(stepO)
	var stepR = Step.new([RuleOR2.new()], 2)
	_steps.append(stepR)
	
	var stepKL = Step.new([RuleKL1.new(), RuleKL2.new(), RuleKL3.new(), RuleKL4.new()],3)
	_steps.append(stepKL)
	
	return _steps

func vertexString(vertex: Vertex) -> String:
	var type: String = ""
	var result: String
	match vertex.type:
		VERTEX_TYPE.INIT: type = "I"
		VERTEX_TYPE.START: type = "S"
		VERTEX_TYPE.TASK: type = "T"
		VERTEX_TYPE.OBSTACLE: type = "O"
		VERTEX_TYPE.REWARD: type = "O"
		VERTEX_TYPE.SECRET: type = "St"
		VERTEX_TYPE.LOCK: type = "L"
		VERTEX_TYPE.KEY: type = "K"
		VERTEX_TYPE.GOAL: type = "G"
		_: type = "T"
	var name: String = vertex.name
	result = name.substr(6) +":"+ type
	return result

func toDot(graph):
	file.open("res://logResult.txt", File.READ_WRITE)
	file.seek_end()
	file.store_line("digraph G {")
	file.store_line('node [shape="circle"]')
	for edge in graph.edges:
		var vertex1: Vertex = graph.getVertexByName(edge.source)
		var vertex2: Vertex = graph.getVertexByName(edge.target)
		if vertex1 != null and vertex2 != null:
			if edge.type == EDGE_TYPE.PATH:
				file.store_line('"'+vertexString(vertex1)+'"' + " -> " + '"'+vertexString(vertex2)+'"')
			else:
				file.store_line('"'+vertexString(vertex1)+'"' + " -> " + '"'+vertexString(vertex2)+'" [ style=dashed ]')
	for vertex in graph.vertices:
		if vertex.type == VERTEX_TYPE.START:
			file.store_line('"'+vertexString(vertex)+'"' + " [peripheries=2]")
		if vertex.type == VERTEX_TYPE.GOAL:
			file.store_line('"'+vertexString(vertex)+'"' + " [peripheries=2]")
	file.store_line("}")
	file.store_line("==============================================================================")
	file.close()

func generate() -> Graph:
#	build recipe
	var recipe: Array
	if steps.size() > 0:
		recipe = steps
	else:
		recipe = recipe()
	
	var generatorGraph = GeneratorGraph.new(1, recipe)
	generatorGraph.connect("drawGraph", self, "toDot")
	
	file.open("res://logResult.txt", File.WRITE)
	file.store_line("==============================================================================")
	file.close()
	
	_result = generatorGraph.generate()
	
#	for step in recipe:
#		step.destroy()
#		step.queue_free()
	
#	var generatorSpace = GeneratorSpace.new([])
#	_result = generatorSpace.transform(_result)

#	var newGraph = Graph.new()
#	var newVertices: Array = []
#	var newEdges: Array = []
#	for vertex in _result.vertices:
#		if vertex.subOf == null:
#			newVertices.append(vertex)
#		for edge in _result.getEdgesOf(vertex):
#			if newEdges.find(edge) == -1:
#				newEdges.append(edge)
#
#	newGraph.vertices = newVertices
#	newGraph.edges = newEdges
#	toDot(newGraph)
#	file.close()
	return _result
