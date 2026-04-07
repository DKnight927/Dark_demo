extends RefCounted
class_name 站位合法性服务


static func 技能可由单位发动(单位: 战斗单位运行时, 技能: 技能定义) -> bool:
	if 单位 == null or 技能 == null:
		return false
	if 单位.当前生命值 <= 0:
		return false
	if 单位.取技能剩余冷却(技能) > 0:
		return false
	if 单位.当前魔法值 < 技能.魔法消耗:
		return false
	return 技能.可从站位发动(单位.当前槽位)


static func 技能可命中目标槽位(技能: 技能定义, 目标槽位: int) -> bool:
	if 技能 == null:
		return false
	return 技能.目标站位合法(目标槽位)


static func 意图合法(行动者: 战斗单位运行时, 意图: 行动意图) -> bool:
	if 行动者 == null or 意图 == null or 意图.施放技能 == null:
		return false
	if not 技能可由单位发动(行动者, 意图.施放技能):
		return false
	for 目标槽位: int in 意图.目标槽位列表:
		if not 技能可命中目标槽位(意图.施放技能, 目标槽位):
			return false
	return true


static func 取可用技能(单位: 战斗单位运行时) -> Array[技能定义]:
	var 结果: Array[技能定义] = []
	if 单位 == null:
		return 结果
	if 单位.英雄状态来源 != null:
		for 技能: 技能定义 in 单位.英雄状态来源.取当前已装备技能():
			if 技能可由单位发动(单位, 技能):
				结果.append(技能)
	elif 单位.敌人定义来源 != null:
		for 技能: 技能定义 in 单位.敌人定义来源.可用技能:
			if 技能可由单位发动(单位, 技能):
				结果.append(技能)
	return 结果
