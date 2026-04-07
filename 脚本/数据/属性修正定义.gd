extends Resource
class_name 属性修正定义

@export var 属性: 属性类型.枚举 = 属性类型.枚举.力量
@export var 最小值: float = 0.0
@export var 最大值: float = 0.0
@export var 是否百分比: bool = false


func 取随机数值(随机数生成器: RandomNumberGenerator = null) -> float:
	if 随机数生成器 == null:
		return 最小值
	return 随机数生成器.randf_range(最小值, 最大值)
