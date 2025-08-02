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
var connectors = []

var currentState : PieceState;
func _ready() -> void:
	currentState = PieceState.unconnected;
	add_to_group("jigsawPieces")
	
func _process(delta: float) -> void:
	match currentState:
		PieceState.unconnected:
			pass;
		PieceState.connected:
			pass;
		PieceState.held:
			global_position = get_global_mouse_position();
			
signal grabbed(JigsawPieceBase);
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			grabbed.emit(self)
			
func getGrabbed() -> void:
	currentState = PieceState.held;
	
func getDropped() -> void:
	currentState = PieceState.unconnected;
