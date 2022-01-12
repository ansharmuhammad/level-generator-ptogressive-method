class_name Step

var rules: Array
var repeat: int

func _init(_rules: Array, _repeat: int):
	rules = _rules
	repeat = _repeat
#
#func destroy():
#	for rule in rules:
#		rule.queue_free()
