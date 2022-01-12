class_name GeneratorSpace

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

func isElement(vertex: Vertex) -> bool:
	var element: Array = [
		VERTEX_TYPE.KEY,
		VERTEX_TYPE.LOCK,
		VERTEX_TYPE.OBSTACLE,
		VERTEX_TYPE.REWARD
		]
	if element.find(vertex.type) != -1:
		return true
	return false

func isPlace(vertex: Vertex) -> bool:
	var element: Array = [
		VERTEX_TYPE.TASK,
		VERTEX_TYPE.SECRET
		]
	if element.find(vertex.type) != -1:
		return true
	return false

func createEntrance(graph:Graph, vertex: Vertex):
	#create entrance
	if vertex.type == VERTEX_TYPE.START:
		var newVertex: Vertex = graph.addVertex()
		vertex.subOf = newVertex
		vertex.type = VERTEX_TYPE.ENTRANCE
		for edge in graph.getEdgesOf(vertex):
			if edge.source == vertex.name:
				edge.source = newVertex.name
			elif edge.target == vertex.name:
				edge.target = newVertex.name
		print("execute rule createEntrance at" + str(vertex))
		print("new "+str(newVertex))

func createGoal(graph:Graph, vertex: Vertex):
	#create goal
	if vertex.type == VERTEX_TYPE.GOAL:
		var newVertex: Vertex = graph.addVertex()
		vertex.subOf = newVertex
		for edge in graph.getEdgesOf(vertex):
			if edge.source == vertex.name:
				edge.source = newVertex.name
			elif edge.target == vertex.name:
				edge.target = newVertex.name
		print("execute rule createGoal at" + str(vertex))
		print("new "+str(newVertex))

func createSecret(graph:Graph, vertex: Vertex):
	#create goal
	if vertex.type == VERTEX_TYPE.SECRET:
		var newVertex: Vertex = graph.addVertex()
		vertex.subOf = newVertex
		for edge in graph.getEdgesOf(vertex):
			if edge.source == vertex.name:
				edge.source = newVertex.name
			elif edge.target == vertex.name:
				edge.target = newVertex.name
		print("execute rule createSecret at" + str(vertex))
		print("new "+str(newVertex))

func addElementBeforePlace(graph: Graph):
	var matchVertices: Array = []
	for vertex1 in graph.vertices:
		for vertex2 in graph.getOutgoingVertex(vertex1, EDGE_TYPE.PATH):
			if isPlace(vertex1) and isElement(vertex2):
				matchVertices.append([vertex1, vertex2])
	
	if matchVertices.size() > 0:
		randomize()
		var choosenMatch = matchVertices[randi() % matchVertices.size()]
		choosenMatch[1].subOf = choosenMatch[0]
		for edge in graph.getEdgesOf(choosenMatch[1], EDGE_TYPE.PATH):
			if edge.source == choosenMatch[0].name and edge.target == choosenMatch[1].name:
				graph.edges.erase(edge)
			elif edge.source == choosenMatch[1].name:
				edge.source = choosenMatch[0].name
			elif edge.target == choosenMatch[1].name:
				edge.target = choosenMatch[0].name
		
		print("execute rule addElementBeforePlace at" + str(choosenMatch[0]) + str(choosenMatch[1]))

func addLockAfterPlace(graph: Graph):
	var matchVertices: Array = []
	for vertex1 in graph.vertices:
		for vertex2 in graph.getOutgoingVertex(vertex1, EDGE_TYPE.PATH):
			if vertex1.type == VERTEX_TYPE.LOCK and isPlace(vertex2):
				matchVertices.append([vertex1, vertex2])
	
	if matchVertices.size() > 0:
		randomize()
		var choosenMatch = matchVertices[randi() % matchVertices.size()]
		choosenMatch[0].subOf = choosenMatch[1]
		for edge in graph.getEdgesOf(choosenMatch[0], EDGE_TYPE.PATH):
			if edge.source == choosenMatch[0].name and edge.target == choosenMatch[1].name:
				graph.edges.erase(edge)
			elif edge.source == choosenMatch[0].name:
				edge.source = choosenMatch[1].name
			elif edge.target == choosenMatch[0].name:
				edge.target = choosenMatch[1].name
		print("execute rule addLockAfterPlace at" + str(choosenMatch[0]) + str(choosenMatch[1]))

func placeKeyElement(graph: Graph):
	var matchVertices: Array = []
	for vertex1 in graph.vertices:
		for vertex2 in graph.getOutgoingVertex(vertex1, EDGE_TYPE.PATH):
			if vertex1.type == VERTEX_TYPE.KEY and isPlace(vertex2):
				matchVertices.append([vertex1, vertex2])
	
	if matchVertices.size() > 0:
		randomize()
		var choosenMatch = matchVertices[randi() % matchVertices.size()]
		var newVertex: Vertex = graph.addVertex()
		choosenMatch[0].subOf = newVertex
		for edge in graph.getEdgesOf(choosenMatch[0], EDGE_TYPE.PATH):
			if edge.source == choosenMatch[0].name:
				edge.source = newVertex.name
			elif edge.target == choosenMatch[0].name:
				edge.target = newVertex.name
		print("execute rule addLockAfterPlace at" + str(choosenMatch[0]) + str(choosenMatch[1]))

func addElementAfterPlace(graph: Graph):
	var matchVertices: Array = []
	for vertex1 in graph.vertices:
		for vertex2 in graph.getOutgoingVertex(vertex1, EDGE_TYPE.PATH):
			for vertex3 in graph.getOutgoingVertex(vertex2, EDGE_TYPE.PATH):
				if isElement(vertex1) and isElement(vertex2) and isPlace(vertex3):
					matchVertices.append([vertex1, vertex2, vertex3])
	
	if matchVertices.size() > 0:
		randomize()
		var choosenMatch = matchVertices[randi() % matchVertices.size()]
		choosenMatch[1].subOf = choosenMatch[2]
		for edge in graph.getEdgesOf(choosenMatch[1], EDGE_TYPE.PATH):
			if edge.source == choosenMatch[1].name and edge.target == choosenMatch[2].name:
				graph.edges.erase(edge)
			if edge.source == choosenMatch[1].name:
				edge.source = choosenMatch[2].name
			elif edge.target == choosenMatch[1].name:
				edge.target = choosenMatch[2].name
		print("execute rule addLockAfterPlace at" + str(choosenMatch[0]) + str(choosenMatch[1]) + str(choosenMatch[2]))

func outsideElementExist(graph: Graph) -> bool:
	for vertex in graph.vertices:
		if isElement(vertex) and vertex.subOf == null:
			return true
	return false

func transform(graph: Graph) -> Graph:
	#create place rule
	for vertex in graph.vertices:
		createEntrance(graph, vertex)
		createGoal(graph, vertex)
		createSecret(graph, vertex)
	
#	#clean outside element rule
	while outsideElementExist(graph):
		var execute: int = randi() % 4
		match execute:
			0: addElementBeforePlace(graph)
			1: addLockAfterPlace(graph)
			2: placeKeyElement(graph)
			3: addLockAfterPlace(graph)
	
	#transformative rule
	
	return graph
