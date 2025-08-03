extends HBoxContainer

enum UpgradeResource{
	Nubbin,
	Niblet,
}

var _currentCost : int;
var _costMultiplier : float;
var _requiredResource : UpgradeResource;

func _ready() -> void:
	var _buttonName : String = "Name Goes Here";
	var _buttonHoverDescription : String = "Description";

	_costMultiplier = 1.07;
	var _requiredResource : UpgradeResource;

func initalSetup(buttonName : String, 
	buttonHover : String, 
	costMultiplier : float, 
	resource : UpgradeResource, 
	effect : Callable) -> void:
	$Button.text = buttonName;
	$Button.tooltip_text = buttonHover;
	$Button.button_up.connect(effect);
	
	_costMultiplier = costMultiplier;
	_requiredResource = resource;
	
	
	
