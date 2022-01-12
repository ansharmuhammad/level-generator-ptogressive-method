class_name Graph

var vertices: Array
var edges: Array

func _to_string() -> String:
	var string = str(vertices) + "\n" + str(edges)
	return string

## default type = 2. mean TASK
## if name not assigned, then name is "node <index of vertex in vertices>"
func addVertex(name: String = "", type: int = 2) -> Vertex:
	var vertexName = "vertex" + str(vertices.size())  if name == "" else name
	var newVertex = Vertex.new(vertexName, type)
	vertices.append(newVertex)
	return newVertex

func getVerticesName() -> Array:
	var names: Array
	for vertex in vertices:
		names.append(vertex.name)
	return names

## default type = 0. mean PATH
func connectVertex(source: Vertex, target: Vertex, type: int = 0):
	var newEdge = Edge.new(source.name, target.name, type)
	edges.append(newEdge)

func connectVertexByName(source: String, target: String, type: int = 0):
	var newEdge = Edge.new(source, target, type)
	edges.append(newEdge)

func getVertexByName(vertexName: String) -> Vertex:
	for vertex in vertices:
		if vertex.name == vertexName:
			return vertex
	return null

func getOutgoingEdges(vertex: Vertex, type: int = -1) -> Array:
	var listEdge: Array
	for edge in edges:
		if type == -1:
			if (edge.source == vertex.name) :
				listEdge.append(edge)
		else:
			if edge.source == vertex.name and edge.type == type:
				listEdge.append(edge)
	return listEdge

func getIncomingEdges(vertex: Vertex, type: int = -1) -> Array:
	var listEdge: Array
	for edge in edges:
		if type == -1:
			if (edge.target == vertex.name) :
				listEdge.append(edge)
		else:
			if (edge.target == vertex.name) and edge.type == type :
				listEdge.append(edge)
	return listEdge

func getEdgesOf(vertex: Vertex, type: int = -1) -> Array:
	var listEdge: Array
	for edge in edges:
		if type == -1:
			if edge.source == vertex.name or edge.target == vertex.name:
				listEdge.append(edge)
		else:
			if edge.source == vertex.name or edge.target == vertex.name and edge.type == type:
				listEdge.append(edge)
	return listEdge

func getIndegree(vertex: Vertex, typeEdge: int = -1) -> int:
	return getIncomingEdges(vertex, typeEdge).size()

func getOutdegree(vertex: Vertex, typeEdge: int = -1) -> int:
	return getOutgoingEdges(vertex, typeEdge).size()

func getDegree(vertex: Vertex, typeEdge: int = -1) -> int:
	return getEdgesOf(vertex, typeEdge).size()

func getIncomingVertex(vertex: Vertex, typeEdge: int = -1) -> Array:
	var listVertex: Array = []
	var _edges: Array = getIncomingEdges(vertex, typeEdge)
	for edge in _edges:
		var sourceVertex: Vertex = getVertexByName(edge.source)
		if listVertex.find(sourceVertex) == -1:
			listVertex.append(sourceVertex)
	return listVertex

func getOutgoingVertex(vertex: Vertex, typeEdge: int = -1) -> Array:
	var listVertex: Array = []
	var _edges: Array = getOutgoingEdges(vertex, typeEdge)
	for edge in _edges:
		var targetVertex: Vertex = getVertexByName(edge.target)
		if listVertex.find(targetVertex) == -1:
			listVertex.append(targetVertex)
	return listVertex

func getNeighboors(vertex: Vertex, typeEdge: int = -1) -> Array:
	var listVertex: Array = []
	var _edges: Array
	
	_edges = getIncomingEdges(vertex, typeEdge)
	for edge in _edges:
		var sourceVertex: Vertex = getVertexByName(edge.source)
		if listVertex.find(sourceVertex) == -1:
			listVertex.append(sourceVertex)
	
	_edges = getOutgoingEdges(vertex, typeEdge)
	for edge in _edges:
		var targetVertex: Vertex = getVertexByName(edge.target)
		if listVertex.find(targetVertex) == -1:
			listVertex.append(targetVertex)
	return listVertex

func getIsolated(typeEdge: int = -1) -> Array:
	var listVertex: Array = []
	for v in vertices:
		if getDegree(v, typeEdge) == 0:
			 listVertex.append(v)
	return listVertex

func getSinks(typeEdge: int = -1) -> Array:
	var listVertex: Array = []
	for v in vertices:
		if getOutdegree(v, typeEdge) == 0:
			 listVertex.append(v)
	return listVertex

func getSources(typeEdge: int = -1) -> Array:
	var listVertex: Array = []
	for v in vertices:
		if getIndegree(v, typeEdge) == 0:
			 listVertex.append(v)
	return listVertex

func copy(graph: Graph):
	vertices.append_array(graph.vertices)
	edges.append_array(graph.edges)

func destroy():
	for vertex in vertices:
		vertex.free()
	for edge in edges:
		edge.free()
