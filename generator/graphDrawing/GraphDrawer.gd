extends Node2D

class_name GraphDrawer

var switchedEdges: Array
onready var canDraw: bool = false
var drawGraph: Graph
var i: int
#var layers: Array

func switchingEdges(graph: Graph, switchedEdge: Array):
	for e in switchedEdge:
		var tempSource: String = e.source
		var tempTarget: String = e.target
		var edge = graph.edges[graph.edges.find(e)]
		edge.source = tempTarget
		edge.target = tempSource

## implement sugiyama framework
func drawing(graph: Graph) -> Graph:
	var tempGraph: Graph = Graph.new()
	tempGraph.copy(graph)
	
	switchedEdges = cycleBreaking(tempGraph) 
#	switchingEdges(tempGraph, switchedEdges)
#	drawGraph = upwardEmbed(tempGraph)
#
#	canDraw = true
	update()
#	layers = layering(tempGraph)
	return tempGraph

func removeSink(graph: Graph):
	var sinks: Array = graph.getSinks()
	while sinks.size() > 0:
		for sink in sinks:
			graph.vertices.remove(graph.vertices.find(sink))
			var incomingEdges: Array = graph.getIncomingEdges(sink)
			for edge in incomingEdges:
				graph.edges.erase(edge)
		sinks = graph.getSinks()
	

func removeSource(graph: Graph):
	var sources: Array = graph.getSources()
	while sources.size() > 0:
		for source in sources:
			graph.vertices.erase(source)
			var outcomingEdges: Array = graph.getOutgoingEdges(source)
			for edge in outcomingEdges:
				graph.edges.erase(edge)
		sources = graph.getSources()

func removeIsolated(graph: Graph):
	var isolated = graph.getIsolated()
	for v in isolated:
		graph.vertices.erase(v)

func pickSwitch(graph: Graph) -> Array:
	var switchEdge: Array = []
	if !graph.vertices.empty():
		var vCandidate: Vertex = null
		var maxTarget: int = -100
		for v in graph.vertices:
			var targets: Array = graph.getOutgoingEdges(v)
			var sources: Array = graph.getIncomingEdges(v)
			var value: int = targets.size() - sources.size()
			if value > maxTarget:
				maxTarget = value
				vCandidate = v
		graph.vertices.erase(vCandidate)
		for e in graph.getOutgoingEdges(vCandidate):
			graph.edges.erase(e)
		for e in graph.getIncomingEdges(vCandidate):
			switchEdge.append(e)
			graph.edges.erase(e)
	return switchEdge
	

func cycleBreaking(graph: Graph) -> Array:
	var tempGraph: Graph = Graph.new()
	tempGraph.copy(graph)
	var switchEdge: Array = []
	while !graph.vertices.empty():
		removeSink(tempGraph)
		removeIsolated(tempGraph)
		removeSource(tempGraph)
		switchEdge.append_array(pickSwitch(tempGraph))
	
#	tempGraph.queue_free()
	return switchEdge

func assignPos(stackVertex: Array, pendingVertex: Array, graph: Graph, pos: String):
	var v: Vertex = stackVertex.front()
	if pos == "x": v.xPos = i
	else: v.yPos = i
	i += 1
	print("v" + str(v))
	var outgoing: Array = graph.getOutgoingVertex(v)
	print("outgoing"+str(outgoing))
	stackVertex.pop_front()
	if pos == "y": outgoing.invert()
	if outgoing.size() > 0:
		stackVertex.push_front(outgoing.front())
		if outgoing.size() > 1:
			stackVertex.append_array(outgoing.slice(1,-1))
	print("stack" + str(stackVertex))

func upwardEmbed(graph: Graph) -> Graph:
#	var tempGraph: Graph = Graph.new()
#	tempGraph.vertices.append_array(graph.vertices)
#	tempGraph.edges.append_array(graph.edges)
	
	#switch fron with source
	var source: Array = graph.getSources()
	
	#get x pos
	var stackVertex: Array
	var pendingVertex: Array
	
	for pos in ["x","y"]:
		stackVertex = []
		pendingVertex = []
		i = 0
		stackVertex.append(source.front())
		while !stackVertex.empty():
			print("i now "+ str(i))
			var v: Vertex = stackVertex.front()
			if graph.getIncomingVertex(v).size() < 2:
				assignPos(stackVertex,pendingVertex,graph, pos)
				print("incoming < 2")
				print("stack now "+ str(stackVertex))
			else:
				if pendingVertex.find(v) != -1:
					print("incoming > 2 found in pending")
					pendingVertex.erase(v)
					assignPos(stackVertex,pendingVertex,graph, pos)
					print("stack now "+ str(stackVertex))
				else:
					print("incoming > 2 to pending")
					stackVertex.pop_front()
					pendingVertex.append(v)
			print("stack is empty? "+ str(stackVertex.empty()))
	return graph

func _draw():
	if !canDraw: return
	var padding: int = 40
	var radius: int = 2
	for edge in drawGraph.edges:
		var source: Vertex = drawGraph.getVertexByName(edge.source)
		var target: Vertex = drawGraph.getVertexByName(edge.target)
		draw_circle(Vector2(source.xPos + padding, source.yPos + padding), radius, Color.blanchedalmond)
		draw_circle(Vector2(target.xPos + padding, target.yPos + padding), radius, Color.blanchedalmond)
		draw_line(Vector2(source.xPos + padding, source.yPos + padding), Vector2(target.xPos + padding, target.yPos + padding), Color.black)

#func destroy():
#	queue_free()
#func layering(graph: Graph):
#	var tempGraph: Graph = Graph.new()
#	tempGraph.vertices.append_array(graph.vertices)
#	tempGraph.edges.append_array(graph.edges)
#
#	var sorted: Array = []
#
#	var start = tempGraph.getSinks()
#	while start.size() > 0:
#		sorted.append(start)
#		for v in start:
#			var targets: Array = tempGraph.getOutcomingEdges(v)
#			for edge in targets:
#				tempGraph.edges.remove(tempGraph.edges.find(edge))
#			tempGraph.vertices.remove(tempGraph.vertices.find(v))
#		start = tempGraph.getSinks()
#
#	return sorted

#func getPosLayer(vertex: Vertex, layers: Array) -> int:
#	for y in range(layers.size()):
#		var layer: Array = layers[y]
#		if layer.find(vertex) > -1:
#			return y
#	return -1
#
#func createVirtual(graph: Graph, layers: Array) -> Dictionary:
#	var tempGraph: Graph = Graph.new()
#	tempGraph.vertices.append_array(graph.vertices)
#	tempGraph.edges.append_array(graph.edges)
#
#	var _layers = layers
#
#	var virtualIdx: int = 0
#	for i in range(layers.size()):
#		var currentLayer = _layers[i]
#		var nextLayer = _layers[i+1]
#		for vertex in currentLayer:
#
#			var OutgoingEdgesMultiLayer: Array = []
#			for edge in tempGraph.getOutgoingEdges(vertex):
#				var target: Vertex = tempGraph.getVertexByName(edge.target)
#				if abs(getPosLayer(target, layers) - getPosLayer(vertex, layers)) > 1:
#					OutgoingEdgesMultiLayer.append(edge)
#
#			for edge in OutgoingEdgesMultiLayer:
#				var virtualName = "virtual" + str(virtualIdx)
#				virtualIdx += 1
#				tempGraph.addVertex(virtualName, -1)
#				nextLayer.append(tempGraph.getVertexByName(virtualName))
#
#				tempGraph.edges.remove(tempGraph.edges.find(edge))
#				tempGraph.connectVertexByName(edge.source, virtualName, edge.type)
#				tempGraph.connectVertexByName(virtualName, edge.target, edge.type)
#
#			var IncomingEdgesMultiLayer: Array = []
#			for edge in tempGraph.getIncomingEdges(vertex):
#				var source: Vertex = tempGraph.getVertexByName(edge.target)
#				if abs(getPosLayer(source, layers) - getPosLayer(vertex, layers)) > 1:
#					IncomingEdgesMultiLayer.append(edge)
#
#			for edge in IncomingEdgesMultiLayer:
#				var virtualName = "virtual" + str(virtualIdx)
#				virtualIdx += 1
#				tempGraph.addVertex(virtualName, -1)
#				nextLayer.append(tempGraph.getVertexByName(virtualName))
#
#				tempGraph.edges.remove(tempGraph.edges.find(edge))
#				tempGraph.connectVertexByName(virtualName, edge.target, edge.type)
#				tempGraph.connectVertexByName(edge.source, virtualName, edge.type)
#
#	return { "graphWithVirtual": tempGraph, "layersWithVirtual": layers } 
