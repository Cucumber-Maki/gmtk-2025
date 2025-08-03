extends Node
class_name Battle;
static var s_instance : Battle = null;

var currentEnemy : Enemy = null;
var currentEnemyMaxHealth : float = 0.0;

@export var attackTimeBase : float = 0.8;
@onready var attackTime := _getAttackTime();
@onready var attackCooldown : float = attackTime;

@export var playerMaxHealthBase := 10.0;
@export var playerDamageBase := 1.0;
@onready var playerMaxHealth : float = _getPlayerMaxHealth();
@onready var playerHealth : float = playerMaxHealth;
@onready var playerDamage : float = _getPlayerDamage();

@export var playerRegenTime : float = 4.0;
@export var playerRegenActive : bool = false;

@export var enabled : bool = false;

func _getPlayerMaxHealth() -> float:
	var piecesMultiplier := HandContainer.s_instance.getMutliplierOfColor(JigsawPieceBase.Colors.red);
	var resourceBonus = Resources.resourceHealthBonus;
	return (playerMaxHealthBase + resourceBonus) * piecesMultiplier;
func _getPlayerDamage() -> float:
	var piecesMultiplier := HandContainer.s_instance.getMutliplierOfColor(JigsawPieceBase.Colors.blue);
	var resourceBonus = Resources.resourceAttackBonus;
	return (playerDamageBase + resourceBonus) * piecesMultiplier;
func _getAttackTime() -> float:
	var piecesMultiplier := HandContainer.s_instance.getMutliplierOfColor(JigsawPieceBase.Colors.yellow);
	var piecesExp = pow((1 / piecesMultiplier), 0.33);
	return attackTimeBase * piecesExp;

func _ready() -> void:
	s_instance = self;

func updatePlayerStats():
	var newMaxHealth := _getPlayerMaxHealth();
	playerHealth += newMaxHealth - playerMaxHealth;
	playerMaxHealth = newMaxHealth;
	playerDamage = _getPlayerDamage();
	attackTime = _getAttackTime();

func _process(delta: float) -> void:
	if (!enabled): return;
	
	if (playerRegenActive):
		attackCooldownBar.value = 0.0;
		playerRegen(delta);
	else:
		attackCooldown -= delta;
		attackCooldownBar.value = 1.0 - (attackCooldown / attackTime);
		if (attackCooldown > 0.0): return;
		#
		attackTick();
		attackCooldown = attackTime;

	updateVisuals();

func attackTick() -> void:
	if (currentEnemy == null):
		currentEnemy = Pillar.s_instance.getNextEnemy();
		currentEnemyMaxHealth = currentEnemy.m_health;
		return;
	
	playerHealth -= currentEnemy.m_damage;
	if (playerHealth <= 0):
		playerRegenActive = true;
		playerHealth = 0.0;
		if (currentEnemy.m_blocksProgress):
			return;
	
	currentEnemy.m_health -= playerDamage;
	if (currentEnemy.m_health <= 0.0): 
		enemyKilled(currentEnemy);
		currentEnemy = null;
		
func playerRegen(delta : float) -> void:
	playerHealth += playerMaxHealth * (delta / playerRegenTime);
	enemyContainer.modulate.a = enemyRegenAlpha;
	if (playerHealth >= playerMaxHealth):
		playerHealth = playerMaxHealth;
		playerRegenActive = false;
		enemyContainer.modulate.a = 1.0;
		
		
func enemyKilled(enemy : Enemy):
	Log.s_instance.logText("%s killed." % enemy.m_name);
	
	var resourceType : Resources.UpgradeResource = [ 
		Resources.UpgradeResource.NibletsPerSecond, 
		Resources.UpgradeResource.NibletsPerSecond, 
		Resources.UpgradeResource.NibletsPerSecond, 
		Resources.UpgradeResource.NubbinsPerSecond ].pick_random();
	
	var resourceDropped : float = [ 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 6, 7 ].pick_random() * Resources.getResource(resourceType);
	
	if (resourceDropped != 0):
		Resources.addResource(resourceDropped, resourceType - 2);
		Log.s_instance.logText("%s dropped %.0f %s!" % [ enemy.m_name, resourceDropped, 
		"Niblets" if resourceType == Resources.UpgradeResource.NibletsPerSecond else "Nubbins"
	]);
	

@export var enemyRegenAlpha : float = 0.3;
@onready var attackCooldownBar : ProgressBar = $VBoxContainer/AttackCooldown;
@onready var playerHealthbar : ProgressBar = $VBoxContainer/HSplitContainer/PlayerMargin/Panel/Player/ProgressBar;
@onready var enemyContainer : Container = $VBoxContainer/HSplitContainer/EnemyMargin;
@onready var enemyLabel : Label = $VBoxContainer/HSplitContainer/EnemyMargin/Enemy/Label;
@onready var enemyHealthbar : ProgressBar = $VBoxContainer/HSplitContainer/EnemyMargin/Enemy/ProgressBar;
func updateVisuals() -> void:
	if (currentEnemy == null):
		enemyLabel.text = "...";
		enemyHealthbar.visible = false;
	else:
		enemyLabel.text = currentEnemy.m_name;
		enemyHealthbar.visible = true;
		enemyHealthbar.max_value = currentEnemyMaxHealth;
		enemyHealthbar.value = currentEnemy.m_health;

	playerHealthbar.max_value = playerMaxHealth;
	playerHealthbar.value = playerHealth;
	
	Pillar.s_instance.updateVisuals();
