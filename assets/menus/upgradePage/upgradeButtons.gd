extends VBoxContainer

enum UpgradeResource{
	Nubbin,
	Niblet,
}

var upgradeRowPreload = preload("res://assets/menus/upgradePage/upgradeRow.tscn");

func _ready() -> void:
	pass;
	#upgrade rows
	
	
func addUpgradeRow(buttonName : String, buttonHover : String, costMultiplier : float, resource : UpgradeResource, effect : Callable):
	var upgradeRow = upgradeRowPreload.instantiate();
	upgradeRow.initialSetup(buttonName, buttonHover, costMultiplier, resource, effect)
	add_child(upgradeRow)
	
