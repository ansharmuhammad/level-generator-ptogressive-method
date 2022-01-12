extends IRule

## extended cycle
class_name RuleOR1

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
	var vertex3 = graph.addVertex("", VERTEX_TYPE.OBSTACLE)
	
	edge1.target = vertex3.name
	graph.connectVertex(vertex3, vertex2)
	
	print("execute rule OR1 at" + str(vertex) + " " + str(edge))
