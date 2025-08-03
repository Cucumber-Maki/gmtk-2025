extends HBoxContainer



var _currentCost : float;
var _costMultiplier : float;
var _requiredResource : Resources.UpgradeResource;

func _ready() -> void:
#	default value
	_costMultiplier = 1.07;
	$Button.button_up.connect(completePurchase);
	

func initialSetup(buttonName : String, 
	buttonHover : String, 
	baseCost : float,
	costMultiplier : float, 
	resource : Resources.UpgradeResource, 
	effect : Callable) -> void:
	$Button.text = buttonName;
	$Button.tooltip_text = buttonHover;
	$Button.button_up.connect(effect);
	
	_currentCost = baseCost;
	_costMultiplier = costMultiplier;
	_requiredResource = resource;
	refreshCost()
	
func refreshCost():
	if _requiredResource == Resources.UpgradeResource.Niblet:
		$Cost.text = str(_currentCost)+" Niblets";
	elif _requiredResource == Resources.UpgradeResource.Nubbin:
		$Cost.text = str(_currentCost)+" Nubbins";
		
	
func completePurchase():
	Resources.addResource(-_currentCost, _requiredResource)
	_currentCost = _currentCost*_costMultiplier;
	refreshCost()

func _process(delta: float) -> void:
	validatePurchasable()
	
func validatePurchasable():
	if Resources.getResource(_requiredResource) >= _currentCost:
		$Button.disabled = false;
	else:
		$Button.disabled = true;
		
