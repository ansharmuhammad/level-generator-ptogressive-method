class_name ShortestPath

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

var graph: Graph

func solve(startVertex: Vertex) -> Dictionary:
	var queue: Array
	queue.push_back(startVertex)
	
	var visitedDict: Dictionary = {}
	var prevDict: Dictionary = {}
	for name in graph.getVerticesName():
		visitedDict[name] = false if name != startVertex.name else true
		prevDict[name] = null
	
	while !queue.empty():
		var vertex = queue.front()
		queue.pop_front()
		var edges: Array = graph.getOutgoingEdges(vertex)
		
		for edge in edges:
			if !visitedDict[edge.target] and edge.type == EDGE_TYPE.PATH:
				queue.push_back(graph.getVertexByName(edge.target))
				visitedDict[edge.target] = true
				prevDict[edge.target] = vertex.name
	return prevDict

func reconstrucPath(startVertex: Vertex, goalVertex: Vertex, prevDict: Dictionary) -> Array:
	var path: Array = []
	var at = goalVertex.name
	while at != null:
		path.append(at)
		at = prevDict[at]
	
	path.invert()
	
	if path[0] == startVertex.name:
		return path
	return []

func getPath(_graph: Graph) -> Array:
	graph = _graph
	
	var start: Vertex = null
	var goal: Vertex = null
	
	for vertex in graph.vertices:
		if start == null or goal == null:
			if vertex.type == VERTEX_TYPE.START:
				start = vertex
			if vertex.type == VERTEX_TYPE.GOAL:
				goal = vertex
		else:
			break
	
	var prev: Dictionary = solve(start)
	
	return reconstrucPath(start, goal, prev)
