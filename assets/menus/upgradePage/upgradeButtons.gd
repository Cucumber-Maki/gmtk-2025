extends VBoxContainer


var upgradeRowPreload = preload("res://assets/menus/upgradePage/upgradeRow.tscn");

func _ready() -> void:
	
	#upgrade rows
	addUpgradeRow("Nubbin Gatherer", "A lil guy to gather you nubbins", 10, 1.07, Resources.UpgradeResource.Nubbin, func():pass);
	
func addUpgradeRow(buttonName : String, 
	buttonHover : String, 
	baseCost: float,
	costMultiplier : float, 
	resource : Resources.UpgradeResource, 
	effect : Callable):
	var upgradeRow = upgradeRowPreload.instantiate();
	upgradeRow.initialSetup(buttonName, buttonHover, baseCost,costMultiplier, resource, effect)
	add_child(upgradeRow)
	
