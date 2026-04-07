extends Resource
class_name 技能定义

@export var 技能编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 可用站位: PackedInt32Array = PackedInt32Array([1, 2, 3, 4])
@export var 可选目标站位: PackedInt32Array = PackedInt32Array([1, 2, 3, 4])
@export var 目标阵营: 目标阵营类型.枚举 = 目标阵营类型.枚举.敌方单体
@export var 魔法消耗: int = 0
@export var 冷却回合: int = 0
@export var 速度修正: float = 0.0
@export var 命中修正: float = 0.0
@export var 暴击修正: float = 0.0
@export var 是否基础攻击: bool = false
@export var 技能标签: PackedStringArray = PackedStringArray()
@export var 是否专属技能: bool = false
@export var 效果列表: Array[技能效果定义] = []


func 可从站位发动(当前位置: int) -> bool:
	return 可用站位.has(当前位置)


func 目标站位合法(目标站位: int) -> bool:
	return 可选目标站位.has(目标站位)