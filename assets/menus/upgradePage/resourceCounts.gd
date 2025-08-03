extends GridContainer

func _ready() -> void:
	Resources.nubbinsChanged.connect(updateNubbins)
	Resources.nibletsChanged.connect(updateNiblets)
	Resources.nubbinsPerSecondChanged.connect(updateNubbinsPerSecond)
	Resources.nibletsPerSecondChanged.connect(updateNibletsPerSecond)
	updateNubbins()
	updateNiblets()
	updateNubbinsPerSecond()
	updateNibletsPerSecond()
	
	
	
func updateNubbins() -> void:
	var newValue : float= Resources.getResource(Resources.UpgradeResource.Nubbin);
	$NubbinsNumber.text = str(newValue);

func updateNiblets() -> void:
	var newValue : float= Resources.getResource(Resources.UpgradeResource.Niblet);
	$NibletsNumber.text = str(newValue);

func updateNubbinsPerSecond() -> void:
	var newValue : float= Resources.getResource(Resources.UpgradeResource.NubbinsPerSecond);
	$NubbinsPerSecondNumber.text = str(newValue);

func updateNibletsPerSecond() -> void:
	var newValue : float= Resources.getResource(Resources.UpgradeResource.NibletsPerSecond);
	$NibletsPerSecondNumber.text = str(newValue);
