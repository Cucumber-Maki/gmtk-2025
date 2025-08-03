extends Node
class_name Log;
static var s_instance : Log = null;

@export var maxLength : int = 50;
@onready var logParent = $SplitContainer/ScrollContainer/VBoxContainer;

func _ready() -> void:
	s_instance = self;
	clearLog();
	
func clearLog()  -> void:
	for n in logParent.get_children():
		logParent.remove_child(n);
		n.queue_free();
	
func logText(text : String) -> void:
	var label : Label;
	if (logParent.get_child_count() >= maxLength):
		label = logParent.get_child(logParent.get_child_count() - 1);
	else:
		label = Label.new();
		logParent.add_child(label);
	
	label.text = text;
	logParent.move_child(label, 0);
