extends GridContainer

func _ready() -> void:
	Resources.nubbinsChanged.connect(updateNubbins)
	Resources.nibletsChanged.connect(updateNiblets)
	
	
	
func updateNubbins() -> void:
	var newValue : float= Resources.getResource(Resources.UpgradeResource.Nubbin);
	$NubbinsNumber.text = str(newValue);

func updateNiblets() -> void:
	var newValue : float= Resources.getResource(Resources.UpgradeResource.Niblet);
	$NibletsNumber.text = str(newValue);

func updateNubbinsPerSecond() -> void:
	pass; 
#	TODO

func updateNibletsPerSecond() -> void:
	pass;
#	TODO
