extends Node

enum UpgradeResource{
	Nubbin,
	Niblet,
	NubbinsPerSecond,
	NibletsPerSecond,
}

var currentNubbins : float = 0;
var currentNiblets : float = 0;

var nubbinsPerSecond : float = 0;
var nibletsPerSecond : float = 0;

signal nubbinsChanged
signal nibletsChanged
signal nubbinsPerSecondChanged
signal nibletsPerSecondChanged
func addResource(amount : float, resourceType : UpgradeResource) -> void:
	match resourceType:
		UpgradeResource.Nubbin:
			currentNubbins += amount
			nubbinsChanged.emit()
		UpgradeResource.Niblet:
			currentNiblets += amount
			nibletsChanged.emit()
		UpgradeResource.NubbinsPerSecond:
			nubbinsPerSecond += amount;
			nubbinsPerSecondChanged.emit()
		UpgradeResource.NibletsPerSecond:
			nibletsPerSecond += amount;
			nibletsPerSecondChanged.emit()

func getResource(resourceType : UpgradeResource) -> float:
	match resourceType:
		UpgradeResource.Nubbin:
			return round(currentNubbins);
		UpgradeResource.Niblet:
			return round(currentNiblets);
		UpgradeResource.NubbinsPerSecond:
			return round(nubbinsPerSecond)
		UpgradeResource.NibletsPerSecond:
			return round(nibletsPerSecond)
	return -1

var timer : float;
func _process(delta: float) -> void:
	timer += delta
	if timer > 1:
		addResource(nubbinsPerSecond, UpgradeResource.Nubbin)
		addResource(nibletsPerSecond, UpgradeResource.Niblet)
		timer -= 1;

func _ready() -> void:
	currentNiblets = 0;
	currentNubbins = 0;
	nubbinsPerSecond = 5;
