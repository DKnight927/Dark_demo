extends Resource
class_name 技能效果定义

@export var 效果类型值: 效果类型.枚举 = 效果类型.枚举.伤害
@export var 数值系数: float = 0.0
@export var 关联属性: 属性类型.枚举 = 属性类型.枚举.力量
@export var 目标状态效果: 状态效果定义
@export var 附加属性修正: Array[属性修正定义] = []
@export var 位移格数: int = 0
@export var 行动进度变化值: float = 0.0
@export var 压力变化值: int = 0
@export var 光照变化值: int = 0


func 是否为状态效果() -> bool:
	return 效果类型值 == 效果类型.枚举.施加状态 or 效果类型值 == 效果类型.枚举.移除状态
