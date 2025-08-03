extends Container
class_name HandContainer;
static var s_instance;

@export var backgroundMat : ShaderMaterial;

func _ready() -> void:
	s_instance = self;
	backgroundMat.set_shader_parameter("u_gridOffset", -grid_origin.round());
	refreshJigsawConnections();

func refreshJigsawConnections() -> void:
	for piece in get_tree().get_nodes_in_group("jigsawPieces"):
		#if is_connected(piece.grabbed)
		piece.grabbed.connect(grabPiece);
		
var currentlyHeldPiece : JigsawPieceBase;
var targetHeldPiece : JigsawPieceBase;
func grabPiece(piece : JigsawPieceBase) -> void:
	if currentlyHeldPiece != null:
		targetHeldPiece = null;
	elif (targetHeldPiece == null || targetHeldPiece.z_index < piece.z_index):
		targetHeldPiece = piece;

func _process(delta: float) -> void:
	if (currentlyHeldPiece == targetHeldPiece): return;
	
	if (currentlyHeldPiece != null):
		currentlyHeldPiece.getDropped();
		currentlyHeldPiece.z_index = 2;
		grid_place(currentlyHeldPiece.grid_position, currentlyHeldPiece);
		move_child(currentlyHeldPiece, get_child_count() - 1);
		$CantPlace.visible = false;
		currentlyHeldPiece = null;
		
	if (targetHeldPiece != null): 
		currentlyHeldPiece = targetHeldPiece;
		currentlyHeldPiece.getGrabbed();
		grid_pickup(currentlyHeldPiece);
		currentlyHeldPiece.z_index = 3;
		move_child(currentlyHeldPiece, 0);

func getPiecesOfColor(color : JigsawPieceBase.Colors) -> Array[JigsawPieceBase]:
	var pieces : Array[JigsawPieceBase] = [];
	for child in get_children():
		if (child is not JigsawPieceBase): continue;
		if (child.color == color):
			pieces.append(child as JigsawPieceBase);
	return pieces;

######################################################################################################
	
var grid_origin := Vector2(10, 10);
var drag_active := false;	
var drag_offset := Vector2(0, 0);	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		var mousePos := get_global_mouse_position();
		if (event.is_pressed() && get_global_rect().has_point(mousePos)):
			drag_active = true;
			drag_offset = grid_origin - mousePos;
		elif (event.is_released()):
			drag_active = false;
	elif event is InputEventMouseMotion:
		var mousePos := get_global_mouse_position();
		if (drag_active):
			grid_origin = mousePos + drag_offset;
			backgroundMat.set_shader_parameter("u_gridOffset", -grid_origin.round());
			for mat : ShaderMaterial in JigsawPieceBase.s_materials:
				mat.set_shader_parameter("u_gridOffset", -grid_origin.round());
			for child in get_children():
				if (child is not JigsawPieceBase): continue;
				child.updatePosition();

######################################################################################################

var grid_placedPieces : Dictionary = {};

# Validation function.
func grid_canPlace(pos : Vector2i, piece : JigsawPieceBase) -> bool:
	if (piece.grid_placed || grid_placedPieces.has(pos)):
		return false;
		
	# Check if connections are compatible.
	var adjacentPieces = grid_getAdjacentPieces(pos);
	for connectionIndex : int in range(len(adjacentPieces)):
		var adjacentPiece : JigsawPieceBase = adjacentPieces[connectionIndex];
		if (adjacentPiece == null): continue;
		var adjacentConnectionIndex := (connectionIndex + 2) % 4;
		
		var otherConnector := adjacentPiece.connectors[adjacentConnectionIndex];
		match (piece.connectors[connectionIndex]):
			JigsawPieceBase.ConnectorState.noConnector:
				if (otherConnector == JigsawPieceBase.ConnectorState.male):
					return false;
			JigsawPieceBase.ConnectorState.male:
				if (otherConnector != JigsawPieceBase.ConnectorState.female):
					return false;
			JigsawPieceBase.ConnectorState.female:
				pass;
	
	# All is well.
	return true;

func grid_place(pos : Vector2i, piece : JigsawPieceBase) -> bool:
	if (!grid_canPlace(pos, piece)):
		return false;
	
	grid_placedPieces[pos] = piece;
	piece.grid_placed = true;
	piece.updatePosition();
	piece.z_index = 0;
	
	piece.calculateMultiplier();
	for p in grid_getAdjacentPieces(pos):
		if (p == null): continue;
		p.calculateMultiplier();
	
	return true;

func grid_pickup(piece : JigsawPieceBase) -> void:
	var pos := piece.grid_position;
	if (!piece.grid_placed ||
		(grid_placedPieces.has(pos) && grid_placedPieces[pos] != piece)): return;
	
	grid_placedPieces.erase(pos);
	piece.grid_placed = false;
	piece.z_index = max(piece.z_index, 2);
	
	piece.calculateMultiplier();
	for p in grid_getAdjacentPieces(pos):
		if (p == null): continue;
		p.calculateMultiplier();
	
func grid_showCantPlace(globalPos : Vector2i, show : bool) -> void:
	$CantPlace.visible = show;
	$CantPlace.global_position = globalPos;
	
	
# Helpers <3

func grid_getAdjacentPieces(pos: Vector2i) -> Array[JigsawPieceBase]:
	var adjacentCheck : Array[Vector2i] = [ 
		pos + Vector2i(0, -1), pos + Vector2i(1, 0), 
		pos + Vector2i(0, 1), pos + Vector2i(-1, 0) 
	];
	
	var pieces : Array[JigsawPieceBase] = [];
	for connectionIndex : int in range(len(adjacentCheck)):
		var adjacentPos := adjacentCheck[connectionIndex];
		if (!grid_placedPieces.has(adjacentPos)): 
			pieces.append(null);
			continue;
		pieces.append(grid_placedPieces[adjacentPos]);
		
	return pieces;

func grid_getConnectedAdjacentPieces(pos: Vector2i, piece : JigsawPieceBase) -> Array[JigsawPieceBase]:
	var adjacentPieces = grid_getAdjacentPieces(pos);
	for connectionIndex : int in len(adjacentPieces):
		var adjacentPiece : JigsawPieceBase = adjacentPieces[connectionIndex];
		if (adjacentPiece == null): continue;
		var adjacentConnectionIndex := (connectionIndex + 2) % 4;
		
		if (piece.connectors[connectionIndex] != JigsawPieceBase.ConnectorState.male &&
			adjacentPiece.connectors[adjacentConnectionIndex] != JigsawPieceBase.ConnectorState.male):
			adjacentPieces[connectionIndex] = null;
		
	return adjacentPieces;
