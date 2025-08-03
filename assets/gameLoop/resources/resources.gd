extends Node

enum UpgradeResource{
	Nubbin,
	Niblet,
}

var currentNubbins : float;
var currentNiblets : float;

var nubbinsPerSecond : float;
var nibletsPerSecond : float;

signal nubbinsChanged
signal nibletsChanged
func addResource(amount : float, resourceType : UpgradeResource) -> void:
	match resourceType:
		UpgradeResource.Nubbin:
			currentNubbins += amount
			nubbinsChanged.emit()
		UpgradeResource.Niblet:
			currentNiblets += amount
			nibletsChanged.emit()
	


func getResource(resourceType : UpgradeResource) -> float:
	match resourceType:
		UpgradeResource.Nubbin:
			return currentNubbins;
		UpgradeResource.Niblet:
			return currentNiblets;
		_:
			return currentNubbins

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
