extends VBoxContainer


var upgradeRowPreload = preload("res://assets/menus/upgradePage/upgradeRow.tscn");

func _ready() -> void:
	
	#upgrade rows
	addUpgradeRow("Nubbin Gatherer", "A lil guy to gather you nubbins", 10, 1.2, Resources.UpgradeResource.Nubbin, func(): Resources.addResource(1, Resources.UpgradeResource.NubbinsPerSecond));
	addUpgradeRow("Niblet Miner", "A stongy boi to get you some niblets", 100, 1.4, Resources.UpgradeResource.Nubbin, func(): Resources.addResource(1, Resources.UpgradeResource.NibletsPerSecond));
	addUpgradeRow("Battle", "Lets you poke dudes to get more stuff", 5, 1, Resources.UpgradeResource.Niblet, func(s):Battle.s_instance.enabled = true; s.queue_free());
	addUpgradeRow("Stik Embiggener", "Bigger stik hurt more", 300, 1.5, Resources.UpgradeResource.Nubbin, func(): pass);
	addUpgradeRow("Pluk Intensifier", "More pluk make you die less", 15, 1.5, Resources.UpgradeResource.Niblet, func(): pass);

func addUpgradeRow(buttonName : String, 
	buttonHover : String, 
	baseCost: float,
	costMultiplier : float, 
	resource : Resources.UpgradeResource, 
	effect : Callable):
	var upgradeRow = upgradeRowPreload.instantiate();
	upgradeRow.initialSetup(buttonName, buttonHover, baseCost,costMultiplier, resource, effect)
	add_child(upgradeRow)
	
