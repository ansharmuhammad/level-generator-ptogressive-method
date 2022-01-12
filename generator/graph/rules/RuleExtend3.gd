extends IRule

## extended cycle
class_name RuleExtend3

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
	
	graph.connectVertex(vertex2, vertex3)
	graph.connectVertex(vertex3, vertex4)
	graph.connectVertex(vertex4, vertex1)
	
	print("execute rule extend3 at" + str(vertex) + " " + str(edge))
