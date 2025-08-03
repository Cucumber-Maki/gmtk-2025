class_name JigsawPieceBase
extends Area2D

enum Colors {
	red, # Health
	blue, # Attack damage
	yellow, # Attack speed
	green, # Resources?
	white, # Nubbins?
}

static var s_materials : Array[ShaderMaterial];

enum ConnectorState{
	noConnector,
	male,
	female,
}

enum PieceState{
	unconnected,
	connected,
	held,
}

# Connectors specified in clockwise order
var connectors : Array[ConnectorState] = []

var grid_position := Vector2i(0, 0);
var grid_placed := false;

@export var color : Colors = Colors.red;

var activeMultiplier : int = 1;

var grabOffset : Vector2;
var currentState : PieceState;
func _ready() -> void:
	currentState = PieceState.unconnected;
	initConnectors()
	#assembleSprites()
	updateSprites();
	add_to_group("jigsawPieces")
	
func getMaterial(color : Colors) -> ShaderMaterial:
	var materialIndex : int = color;
	
	if (materialIndex < s_materials.size() && \
		s_materials[materialIndex] != null): return s_materials[materialIndex];
	
	while (materialIndex >= s_materials.size()):
		s_materials.append(null);
		
	var mat : ShaderMaterial = preload("res://assets/jigsaw/jigsawPiece/jigsawPieceMaterial.tres").duplicate();
	mat.set_shader_parameter("u_color", [
		Color("ff0044"),
		Color("3300ee"),
		Color("ffbb33"),
		Color("55dd55"),
		Color("ffffff"),
	][color]);
	mat.set_shader_parameter("u_gridOffset", -(get_parent() as HandContainer).grid_origin);
	
	s_materials[materialIndex] = mat;
	return s_materials[materialIndex];
	
func _process(delta: float) -> void:
	match currentState:
		PieceState.unconnected:
			pass;
		PieceState.connected:
			pass;
		PieceState.held:
			var hand : HandContainer = get_parent();
			var step : Vector2 = $Collider.shape.size;
			var hstep := step / 2;
			var gridPositionOffset := hand.grid_origin + hstep;
			
			var targetPosition := get_global_mouse_position() - gridPositionOffset;# + grabOffset;
			grid_position = (targetPosition / step).round();
			updatePosition();

func updatePosition():
	var hand : HandContainer = get_parent();
	var step : Vector2 = $Collider.shape.size;
	var hstep := step / 2;
	var gridPositionOffset := hand.grid_origin + hstep;
	var gridDrawPosition := ((grid_position as Vector2) * step) + gridPositionOffset
	
	if (currentState == PieceState.held):
		hand.grid_showCantPlace(gridDrawPosition, !hand.grid_canPlace(grid_position, self));
	
	if (grid_placed || (currentState == PieceState.held && hand.grid_canPlace(grid_position, self))):
		global_position = gridDrawPosition;
	elif (currentState == PieceState.held):
		global_position = (get_global_mouse_position()).round();

signal grabbed(JigsawPieceBase);
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			grabbed.emit(self)
			grabOffset = global_position - get_global_mouse_position();
			
func getGrabbed() -> void:
	currentState = PieceState.held;
	
func getDropped() -> void:
	currentState = PieceState.unconnected;

func initConnectors():
	var rng = RandomNumberGenerator.new()
	for i in 4:
		var connectorIndex := rng.randi_range(0, ConnectorState.size() - 1)
		var connectorType: ConnectorState = ConnectorState.values()[connectorIndex]
		connectors.append(connectorType)


func assembleSprites():
	var connectorSpriteFrames = $AnimatedSprite2D.sprite_frames
	for i in range(0, connectors.size()):
		var connectorType = connectors[i]
		var texture = connectorSpriteFrames.get_frame_texture(
			"default",
			connectorType
		)
		
		var rotation = deg_to_rad(90 * i)
		var yOffset = -(texture.get_width() / 2)
		
		var sprite := Sprite2D.new()
		sprite.texture = texture
		sprite.position = Vector2(0, yOffset).rotated(rotation)
		sprite.rotate(rotation)
		self.add_child(sprite)
		
@onready var displayLabel : Label = $Label;
func updateSprites():
	var sprites : Array[AnimatedSprite2D] = [
		$NorthSprite, $EastSprite, $SouthSprite, $WestSprite
	];
	for i in range(0, min(connectors.size(), len(sprites))):
		var connectorType = connectors[i]
		sprites[i].frame = connectorType;
		sprites[i].material = getMaterial(color);
	
	displayLabel.text = "%dx" % activeMultiplier;

func calculateMultiplier():
	activeMultiplier = 1;
	
	if (!grid_placed):
		updateSprites();
		return; # TODO: Preview?
	
	var hand := get_parent() as HandContainer;
	
	var adjacent := hand.grid_getConnectedAdjacentPieces(grid_position, self);
	for piece in adjacent:
		if (piece == null): continue;
		#
		if (piece.color == color): 
			activeMultiplier += 2;
		else:
			activeMultiplier += 1;
			
	updateSprites();
