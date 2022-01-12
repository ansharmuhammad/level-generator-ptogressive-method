extends IRule

## add secret
class_name RuleSecret

# condition
func leftComponent(graph: Graph, vertex: Vertex, edge: Edge) -> bool:	
	var vertex1 = vertex
	if vertex1.type == VERTEX_TYPE.TASK:
		return true
	return false

# replace graph component
func rightComponent(graph: Graph, vertex: Vertex, edge: Edge):
	var vertex1 = vertex
	var vertex2 = graph.addVertex("", VERTEX_TYPE.SECRET)
	
	graph.connectVertex(vertex1, vertex2)
	
	print("execute rule secret at" + str(vertex) + " " + str(edge))
