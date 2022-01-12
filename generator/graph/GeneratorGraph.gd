class_name GeneratorGraph

signal drawGraph

var populate: int
var steps: Array
var graphs: Array

func _init(_populate: int, _steps: Array):
	populate = _populate
	steps = _steps

func getVariation(graph: Graph) -> float:
	var edges: Array
	edges.append_array(graph.edges)
#	remove start and goal
	edges.pop_front()
	edges.pop_back()
	var Ed: float = 0
	for edge in edges:
		var VSource = graph.getVertexByName(edge.source)
		var VTarget = graph.getVertexByName(edge.target)
		if VSource.type != VTarget.type:
			Ed += 1
	var E: float = edges.size()
	var fe = Ed/E
	return fe

func generate() -> Graph:
	var resultGraph: Graph
	var shortestPath: ShortestPath = ShortestPath.new()
	for n in populate:
		var graph = Graph.new()
		graph.addVertex("",0)
		for step in steps:
			for repeat in step.repeat:
				randomize()
				var random = randi() % step.rules.size()
				var rule = step.rules[random]
				rule.execute(graph)
				emit_signal("drawGraph", graph)
		var path: Array = shortestPath.getPath(graph)
		var variation = getVariation(graph)
		graphs.append({
			"graph": graph,
			"shortesPath": path.size(),
			"exploration": graph.vertices.size(),
			"variation": variation
		})
#	shortestPath.queue_free()
	
	#choose graph by fitness
	resultGraph = graphs[0].graph
	graphs.remove(0)
	for graph in graphs:
		var temp = graph
		graphs.erase(temp)
#		temp.destroy()
#		temp.queue_free()
		if !is_instance_valid(temp): print("temp graph alive")
	
	return resultGraph

# shortest path = sum of vertex sorthest path from start to goal
# exploration = sum of all vertex
# variation = edge which connecting different type of vertex (exclude start and goal)
