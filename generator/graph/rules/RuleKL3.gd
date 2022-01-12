extends IRule

## cycle lock
class_name RuleKL3

# condition
func leftComponent(graph: Graph, vertex: Vertex, edge: Edge) -> bool:
	if edge == null:
		return false
	if edge.target == "" or edge.target == null:
		return false
	
	return true

# replace graph component
func rightComponent(graph: Graph, vertex: Vertex, edge: Edge):
	var vertex1 = vertex
	var edge1 = edge
	
	var vertex2 = graph.getVertexByName(edge.target)
	var vertex3 = graph.addVertex("", VERTEX_TYPE.TASK)
	var vertex4 = graph.addVertex("", VERTEX_TYPE.LOCK)
	var vertex5 = graph.addVertex("", VERTEX_TYPE.TASK)
	var vertex6 = graph.addVertex("", VERTEX_TYPE.KEY)
	
	edge1.target = vertex3.name
	graph.connectVertex(vertex3, vertex4)
	graph.connectVertex(vertex3, vertex5)
	graph.connectVertex(vertex5, vertex6)
	graph.connectVertex(vertex6, vertex1)
	
	graph.connectVertex(vertex4, vertex2)
	
	graph.connectVertex(vertex6, vertex4, EDGE_TYPE.KEY_LOCK)
	
	print("execute rule KL3 at" + str(vertex) + " " + str(edge))
