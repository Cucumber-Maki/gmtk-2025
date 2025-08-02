extends HBoxContainer

enum UpgradeResource{
	Nubbin,
	Niblet,
}
@export_category("Upgrade Details")
@export var buttonName : String = "Name Goes Here";
@export var buttonHoverDescription : String = "Description";
@export var requiredResource : UpgradeResource;
@export var costMultiplier : float = 1.07;
