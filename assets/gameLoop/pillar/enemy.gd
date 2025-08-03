extends Resource
class_name Enemy;

enum Type {
	Jlart,
	Frubie,
	Frogrogg,
	Thuwart,
	Ruube,
	Dazcys,
};

var m_name : String;
var m_health : float;
var m_damage : float;
var m_blocksProgress : bool;

func _init(type : Type, factor : float) -> void:
	m_name = Type.keys()[type];
	
	match (type):
		_: 
			m_health = 5.0;
			m_damage = 0.5;
			m_blocksProgress = true;
	
	m_health *= healthCo(factor);
	m_damage *= damageCo(factor);

func healthCo(factor : float) -> float:
	return 1.0;
func damageCo(factor : float) -> float:
	return 1.0;
