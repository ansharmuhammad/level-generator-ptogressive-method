class_name Vertex

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

var name: String
var type: int

var xPos: int
var yPos: int

var subOf: Vertex
var subXPos: int
var subYPos: int

func _typeString(_type: int) -> String:
	var text: String
	match _type:
		VERTEX_TYPE.INIT: text = "INIT"
		VERTEX_TYPE.START: text = "START"
		VERTEX_TYPE.TASK: text = "TASK"
		VERTEX_TYPE.SECRET: text = "SECRET"
		VERTEX_TYPE.OBSTACLE: text = "OBSTACLE"
		VERTEX_TYPE.REWARD: text = "REWARD"
		VERTEX_TYPE.KEY: text = "KEY"
		VERTEX_TYPE.LOCK: text = "LOCK"
		VERTEX_TYPE.GOAL: text = "GOAL"
	return text

func _init(_name: String, _type: int):
	name = _name
	type = _type

func _to_string() -> String:
	if xPos == null or yPos == null:
		var formatString ="{ name: %s, type: %s, id: %s}"
		return formatString %[name, _typeString(type), self.get_instance_id()]
	elif subOf == null or subXPos == null or subYPos == null:
		var formatString ="{name: %s, type: %s, pos:[%s , %s], id: %s}"
		return formatString %[name, _typeString(type), str(xPos), str(yPos), self.get_instance_id()]
	var formatString ="{name: %s, type: %s, pos:[%s , %s], subof: %s, subPos:[%s , %s], id: %s}"
	return formatString %[name, _typeString(type), str(xPos), str(yPos), subOf.name, str(subXPos), str(subYPos), self.get_instance_id()]
