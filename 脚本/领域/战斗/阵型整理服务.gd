extends RefCounted
class_name 阵型整理服务


static func 整理阵型(单位列表: Array[战斗单位运行时]) -> void:
	var 存活单位: Array[战斗单位运行时] = []
	for 单位: 战斗单位运行时 in 单位列表:
		if 单位 != null and 单位.当前生命值 > 0:
			存活单位.append(单位)
	存活单位.sort_custom(func(a: 战斗单位运行时, b: 战斗单位运行时): return a.当前槽位 < b.当前槽位)
	var 槽位: int = 1
	for 单位: 战斗单位运行时 in 存活单位:
		单位.当前槽位 = 槽位
		槽位 += 1