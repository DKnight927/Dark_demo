extends RefCounted
class_name 防御结算服务


static func 计算最终伤害(原始伤害: float, 目标: 战斗单位运行时) -> int:
	var 护甲值: float = _取属性值(目标, 属性类型.枚举.护甲)
	var 减伤系数: float = clampf(护甲值 / 100.0, 0.0, 0.8)
	var 最终伤害: float = 原始伤害 * (1.0 - 减伤系数)
	return int(max(最终伤害, 1.0))


static func _取属性值(单位: 战斗单位运行时, 属性枚举: 属性类型.枚举) -> float:
	for 属性: 属性修正定义 in 单位.当前属性:
		if 属性 != null and 属性.属性 == 属性枚举:
			return 属性.最小值
	return 0.0