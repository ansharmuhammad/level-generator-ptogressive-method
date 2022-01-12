## interface for rule class
class_name IRule

var graph: Graph

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

# condition
func leftComponent(graph: Graph, vertex: Vertex, edge: Edge) -> bool:
	return false

# replace graph component
func rightComponent(graph: Graph, vertex: Vertex, edge: Edge):
	pass

# execute rule
func execute(graph: Graph):
	var matchVertices: Array
	var edges: Array
	for vertex in graph.vertices:
		edges = graph.getOutgoingEdges(vertex)
		if edges.size() <= 0:
			if leftComponent(graph, vertex, null):
				matchVertices.append([vertex, null])
			
		else: 
			for edge in graph.getOutgoingEdges(vertex):
				if leftComponent(graph, vertex, edge):
					matchVertices.append([vertex, edge])
	if matchVertices.size() > 0:
		randomize()
		var chosenComponent = matchVertices[randi() % matchVertices.size()]
		rightComponent(graph, chosenComponent[0], chosenComponent[1])
