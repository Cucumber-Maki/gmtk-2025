extends HBoxContainer


var _upgradeName : String;
var _currentCost : float;
var _costMultiplier : float;
var _requiredResource : Resources.UpgradeResource;

func _ready() -> void:
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
	
	_upgradeName = buttonName;
	_currentCost = baseCost;
	_costMultiplier = costMultiplier;
	_requiredResource = resource;
	refreshCost()
	
func refreshCost():
	if _requiredResource == Resources.UpgradeResource.Niblet:
		$Cost.text = str(getCost())+" Niblets";
	elif _requiredResource == Resources.UpgradeResource.Nubbin:
		$Cost.text = str(getCost())+" Nubbins";
		
	
func completePurchase():
	Resources.addResource(-_currentCost, _requiredResource)
	_currentCost = _currentCost*_costMultiplier;
	increaseLevel()
	refreshCost()
	Log.s_instance.logText("Bought "+_upgradeName)

var _level : int = 0;
func increaseLevel():
	_level += 1;
	$Level.text = str(_level)

func _process(delta: float) -> void:
	validatePurchasable()
	
func validatePurchasable():
	if Resources.getResource(_requiredResource) >= getCost():
		$Button.disabled = false;
	else:
		$Button.disabled = true;
		
func getCost():
	return round(_currentCost);
