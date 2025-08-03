extends HBoxContainer

enum UpgradeResource{
	Nubbin,
	Niblet,
}
@export_category("Upgrade Information")
@export var buttonName : String = "Name Goes Here";
@export var buttonHoverDescription : String = "Description";

@export_category("Upgrade Values")
@export var costMultiplier : float = 1.07;
@export var requiredResource : UpgradeResource;
