class_name Edge

var source: String
var target: String
var type: int

enum EDGE_TYPE {
	PATH,
	KEY_LOCK
}

func _typeString(_type: int) -> String:
	var text: String
	match _type:
		EDGE_TYPE.PATH: text = "PATH"
		EDGE_TYPE.KEY_LOCK: text = "KEY_LOCK"
	return text

func _init(_source: String, _target: String,  _type: int):
	source = _source
	target = _target
	type = _type

func _to_string() -> String:
	var formatString ="{source: %s, target: %s, type: %s}"
	return formatString %[source, target, _typeString(type)]
