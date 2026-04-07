extends Resource
class_name 战斗单位运行时

@export var 单位标识: StringName
@export var 英雄状态来源: 英雄战役状态
@export var 敌人定义来源: 敌人定义
@export var 当前槽位: int = 1
@export var 当前生命值: int = 0
@export var 当前魔法值: int = 0
@export var 当前压力值: int = 0
@export var 当前行动进度: float = 0.0
@export var 行动阈值: float = 100.0
@export var 当前属性: Array[属性修正定义] = []
@export var 已施加状态: Array[已施加状态实例] = []
@export var 持有效果词缀: Array[怪物词缀定义] = []
@export var 技能冷却映射: Dictionary = {}


func 可行动() -> bool:
	return 当前行动进度 >= 行动阈值 and 当前生命值 > 0


func 取技能剩余冷却(技能: 技能定义) -> int:
	if 技能 == null:
		return 0
	return int(技能冷却映射.get(String(技能.技能编号), 0))


func 设置技能冷却(技能: 技能定义, 剩余回合: int) -> void:
	if 技能 == null:
		return
	var 键: String = String(技能.技能编号)
	if 剩余回合 <= 0:
		技能冷却映射.erase(键)
		return
	技能冷却映射[键] = 剩余回合


func 推进自身技能冷却() -> void:
	var 新映射: Dictionary = {}
	for 键值: Variant in 技能冷却映射.keys():
		var 键: String = String(键值)
		var 剩余回合: int = int(技能冷却映射[键]) - 1
		if 剩余回合 > 0:
			新映射[键] = 剩余回合
	技能冷却映射 = 新映射