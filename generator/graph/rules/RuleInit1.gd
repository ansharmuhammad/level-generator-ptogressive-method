extends IRule

## initial cycle
class_name RuleInit1

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
	var vertex3 = graph.addVertex("", VERTEX_TYPE.GOAL)
	var vertex4 = graph.addVertex("", VERTEX_TYPE.TASK)
	
	graph.connectVertex(vertex1, vertex2)
	graph.connectVertex(vertex2, vertex3)
	graph.connectVertex(vertex3, vertex4)
	graph.connectVertex(vertex4, vertex1)
	
	print("execute rule init1 at" + str(vertex) + " " + str(edge))
