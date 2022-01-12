extends IRule

## initial extended cycle
class_name RuleInit2

# condition
func leftComponent(graph: Graph, vertex: Vertex, edge: Edge) -> bool:
	var vertex1 = vertex
	var edge1 = edge
	if vertex1.type == VERTEX_TYPE.INIT and edge1 == null:
		return true
	return false

# replace graph component
func rightComponent(graph: Graph, vertex: Vertex, edge: Edge):
	var vertex1 = vertex
	vertex1.type = VERTEX_TYPE.START
	
	var vertex2 = graph.addVertex("", VERTEX_TYPE.TASK)
	var vertex3 = graph.addVertex("", VERTEX_TYPE.TASK)
	var vertex4 = graph.addVertex("", VERTEX_TYPE.TASK)
	var vertex5 = graph.addVertex("", VERTEX_TYPE.GOAL)
	var vertex6 = graph.addVertex("", VERTEX_TYPE.TASK)
	
	graph.connectVertex(vertex1, vertex2)
	graph.connectVertex(vertex2, vertex3)
	graph.connectVertex(vertex3, vertex4)
	graph.connectVertex(vertex4, vertex5)
	graph.connectVertex(vertex4, vertex6)
	graph.connectVertex(vertex6, vertex2)
	
	print("execute rule init2 at" + str(vertex) + " " + str(edge))
