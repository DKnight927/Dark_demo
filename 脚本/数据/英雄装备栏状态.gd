extends Resource
class_name 英雄装备栏状态

@export var 武器: 装备实例
@export var 衣服: 装备实例
@export var 饰品列表: Array[装备实例] = []


func 取全部装备() -> Array[装备实例]:
	var 结果: Array[装备实例] = []
	if 武器 != null:
		结果.append(武器)
	if 衣服 != null:
		结果.append(衣服)
	for 饰品 in 饰品列表:
		if 饰品 != null:
			结果.append(饰品)
	return 结果
