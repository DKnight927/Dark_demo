extends Resource
class_name 行动意图

@export var 行动者标识: StringName
@export var 施放技能: 技能定义
@export var 目标阵营: 目标阵营类型.枚举 = 目标阵营类型.枚举.敌方单体
@export var 目标槽位列表: PackedInt32Array = PackedInt32Array()
@export var 施法站位: int = 1
