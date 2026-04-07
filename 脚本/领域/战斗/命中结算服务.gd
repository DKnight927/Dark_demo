extends RefCounted
class_name 命中结算服务


static func 是否命中(行动者: 战斗单位运行时, 目标: 战斗单位运行时, 技能: 技能定义 = null) -> bool:
	var 命中率: float = _取属性值(行动者, 属性类型.枚举.命中率)
	var 闪避率: float = _取属性值(目标, 属性类型.枚举.闪避率)
	var 技能命中修正: float = 0.0
	if 技能 != null:
		技能命中修正 = 技能.命中修正
	var 最终命中率: float = clampf(1.0 + (命中率 + 技能命中修正 - 闪避率) / 100.0, 0.05, 0.95)
	return randf() <= 最终命中率


static func 是否暴击(行动者: 战斗单位运行时, 技能: 技能定义 = null) -> bool:
	var 暴击率: float = _取属性值(行动者, 属性类型.枚举.暴击率)
	var 技能暴击修正: float = 0.0
	if 技能 != null:
		技能暴击修正 = 技能.暴击修正
	var 最终暴击率: float = clampf((暴击率 + 技能暴击修正) / 100.0, 0.0, 0.75)
	return randf() <= 最终暴击率


static func _取属性值(单位: 战斗单位运行时, 属性枚举: 属性类型.枚举) -> float:
	for 属性: 属性修正定义 in 单位.当前属性:
		if 属性 != null and 属性.属性 == 属性枚举:
			return 属性.最小值
	return 0.0