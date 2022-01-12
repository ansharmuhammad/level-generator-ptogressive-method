extends IRule

## extended branch
class_name RuleExtend2

# condition
func leftComponent(graph: Graph, vertex: Vertex, edge: Edge) -> bool:
	if edge == null:
		return false
	if edge.target == "" or edge.target == null:
		return false
	
	var vertex1 = vertex
	var edge1 = edge
	
	var vertex2 = graph.getVertexByName(edge.target)
	
	if edge.source == vertex1.name and edge.target == vertex2.name and edge.type == EDGE_TYPE.PATH:
		return true
	return false

# replace graph component
func rightComponent(graph: Graph, vertex: Vertex, edge: Edge):
	var vertex1 = vertex
	var edge1 = edge
	
	var vertex2 = graph.getVertexByName(edge.target)
	var vertex3 = graph.addVertex("", VERTEX_TYPE.TASK)
	var vertex4 = graph.addVertex("", VERTEX_TYPE.TASK)
	
	graph.connectVertex(vertex1, vertex4)
	graph.connectVertex(vertex4, vertex3)
	graph.connectVertex(vertex3, vertex2)
	
	print("execute rule extend2 at" + str(vertex) + " " + str(edge))
