extends Node

func _ready() -> void:
	refreshJigsawConnections();
		

func refreshJigsawConnections():
	for piece in get_tree().get_nodes_in_group("jigsawPieces"):
		#if is_connected(piece.grabbed)
		piece.grabbed.connect(grabPiece);
		
var currentlyHeldPiece : JigsawPiece;
var actionTaken : bool = false;
func grabPiece(piece : JigsawPiece):
	if currentlyHeldPiece == null and !actionTaken:
		currentlyHeldPiece = piece;
		currentlyHeldPiece.getGrabbed();
		actionTaken = true;
	elif !actionTaken:
		currentlyHeldPiece.getDropped();
		currentlyHeldPiece = null;
		actionTaken = true;

func _process(delta: float) -> void:
	actionTaken = false;
