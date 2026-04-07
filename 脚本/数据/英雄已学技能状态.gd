extends Resource
class_name 英雄已学技能状态

@export var 已学技能: Array[技能定义] = []


func 是否已学会(技能: 技能定义) -> bool:
	return 已学技能.has(技能)
