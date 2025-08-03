class_name JigsawPieceBase
extends Area2D

enum Colours{
	red,
	blue,
	yellow,
}

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

var grabOffset : Vector2;
var currentState : PieceState;
func _ready() -> void:
	currentState = PieceState.unconnected;
	initConnectors()
	#assembleSprites()
	updateSprites();
	add_to_group("jigsawPieces")
	
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
		
func updateSprites():
	var sprites : Array[AnimatedSprite2D] = [
		$NorthSprite, $EastSprite, $SouthSprite, $WestSprite
	];
	for i in range(0, min(connectors.size(), len(sprites))):
		var connectorType = connectors[i]
		sprites[i].frame = connectorType;
		
