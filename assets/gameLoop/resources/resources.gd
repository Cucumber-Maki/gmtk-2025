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
			return round(nubbinsPerSecond * effectNubPS)
		UpgradeResource.NibletsPerSecond:
			return round(nibletsPerSecond * effectNibPS)
	return -1

var effectNubPS : float = 1.0;
var effectNibPS : float = 1.0;

var timer : float;
func _process(delta: float) -> void:
	timer += delta
	if timer > 1:
		addResource(getResource(UpgradeResource.NubbinsPerSecond), UpgradeResource.Nubbin);
		addResource(getResource(UpgradeResource.NibletsPerSecond), UpgradeResource.Niblet);
		timer -= 1;

func calcStuff():
	if (HandContainer.s_instance == null):
		return;
	effectNubPS = HandContainer.s_instance.getMutliplierOfColor(JigsawPieceBase.Colors.green);
	effectNibPS = HandContainer.s_instance.getMutliplierOfColor(JigsawPieceBase.Colors.white);
	nubbinsPerSecondChanged.emit()
	nibletsPerSecondChanged.emit()


func _ready() -> void:
	currentNiblets = 0;
	currentNubbins = 10;
	nubbinsPerSecond = 0;
	nibletsPerSecond = 0;
	calcStuff();
