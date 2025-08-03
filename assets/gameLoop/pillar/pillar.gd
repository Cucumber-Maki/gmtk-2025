extends Node
class_name Pillar;
static var s_instance : Pillar;

var currentFloor = 0;
var currentEnemy = 0;
@export var floors : Array[Floor] = [];

@export var highlightStyleBox : StyleBox;

@onready var pillarParent = $VSplitContainer/ScrollContainer/VBoxContainer;


func _ready() -> void:
	s_instance = self;
	#
	progressBar = ProgressBar.new();
	progressBar.set_anchors_preset(Control.PRESET_FULL_RECT);
	progressBar.add_theme_font_size_override("font_size", 11);
	progressBar.max_value = 1.0;
	#
	clearVisuals();
	updateVisuals();
	

var progressBar : ProgressBar = null;
func updateVisuals():
	while (pillarParent.get_child_count() <= currentFloor):
		var label : Label = Label.new(); # TODO: Progress bar?
		label.text = "Floor %d" % (pillarParent.get_child_count() + 1);
		pillarParent.add_child(label);
		pillarParent.move_child(label, 0);
	
	var progressIndex : float = currentEnemy  as float;
	if (Battle.s_instance != null && Battle.s_instance.currentEnemy != null):
		progressIndex -= (Battle.s_instance.currentEnemy.m_health / Battle.s_instance.currentEnemyMaxHealth);
	
	progressBar.value = progressIndex / (floors[currentFloor].enemies.size() as float); 

	for i : int in range(pillarParent.get_child_count()):
		var label : Label = pillarParent.get_child(i) as Label;
		if (i == 0):
			if (progressBar.get_parent() != label):
				if (progressBar.get_parent() != null):
					progressBar.get_parent().remove_child(progressBar);
				label.add_child(progressBar);
			label.add_theme_stylebox_override("normal", highlightStyleBox)
		else:
			label.remove_theme_stylebox_override("normal");
	
func clearVisuals():
	for n in pillarParent.get_children():
		pillarParent.remove_child(n);
		n.queue_free();

func getNextEnemy() -> Enemy:
	if (floors[currentFloor].enemies.size() <= currentEnemy):
		goUpFloor();
	
	var enemy : Enemy = Enemy.new(floors[currentFloor].enemies[currentEnemy], currentFloor); 
	currentEnemy += 1;
	
	updateVisuals();
	
	return enemy;

func goUpFloor() -> void:
	if (currentFloor < floors.size() - 1):
		currentFloor += 1;
	currentEnemy = 0;
