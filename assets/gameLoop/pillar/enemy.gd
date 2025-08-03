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
	
	m_health = 1.0;
	m_damage = 1.0;
	m_blocksProgress = false;
	
	match (type):
		Type.Jlart:
			m_health = 5.0;
			m_damage = 0.6;
		Type.Frubie:
			m_health = 4.0;
			m_damage = 2.6;
		Type.Frogrogg:
			m_health = 7.0;
			m_damage = 1.6;
		Type.Thuwart:
			m_health = 65.0;
			m_damage = 0.4;
			m_blocksProgress = true;
		Type.Ruube:
			m_health = 20.0;
			m_damage = 6.5;
		Type.Dazcys:
			m_health = 80.0;
			m_damage = 1.5;
			m_blocksProgress = true;
			
	m_health *= healthCo(factor);
	m_damage *= damageCo(factor);

func healthCo(factor : float) -> float:
	return pow(1.2, factor);
func damageCo(factor : float) -> float:
	return pow(1.3, factor);
	
	
static func getEnemyWeight(type : Enemy.Type) -> float:
	match (type):
		Type.Jlart:
			return 2;
		Type.Frubie:
			return 5;
		Type.Frogrogg:
			return 3;
		Type.Thuwart:
			return 9;
		Type.Ruube:
			return 10;
		Type.Dazcys:
			return 15;
	return 1000000;
