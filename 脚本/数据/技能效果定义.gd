extends Resource
class_name 技能效果定义

@export var 效果类型值: 效果类型.枚举 = 效果类型.枚举.伤害
@export var 数值系数: float = 0.0
@export var 基础数值: float = 0.0
@export var 关联属性: 属性类型.枚举 = 属性类型.枚举.力量
@export var 目标状态效果: 状态效果定义
@export var 附加属性修正: Array[属性修正定义] = []
@export var 位移格数: int = 0
@export var 行动进度变化值: float = 0.0
@export var 压力变化值: int = 0
@export var 光照变化值: int = 0
@export var 魔力变化值: int = 0
@export var 判定概率: float = 1.0
@export var 最小触发次数: int = 1
@export var 最大触发次数: int = 1
@export var 持续回合覆盖: int = -1
@export var 条件标签: PackedStringArray = PackedStringArray()
@export var 召唤单位编号: StringName


func 是否为状态效果() -> bool:
	return 效果类型值 == 效果类型.枚举.施加状态 or 效果类型值 == 效果类型.枚举.移除状态
