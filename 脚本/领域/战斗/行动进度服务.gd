extends RefCounted
class_name 行动进度服务


static func 推进单位(单位: 战斗单位运行时, 时间增量: float) -> void:
	if 单位 == null or 单位.当前生命值 <= 0:
		return
	单位.当前行动进度 += 取行动速度(单位) * 时间增量


static func 重置行动进度(单位: 战斗单位运行时) -> void:
	if 单位 == null:
		return
	单位.当前行动进度 = 0.0


static func 取行动速度(单位: 战斗单位运行时) -> float:
	for 属性 in 单位.当前属性:
		if 属性 != null and 属性.属性 == 属性类型.枚举.速度:
			return max(属性.最小值, 1.0)
	if 单位.英雄状态来源 != null and 单位.英雄状态来源.英雄定义资源 != null:
		return max(单位.英雄状态来源.英雄定义资源.初始行动速度, 1.0)
	if 单位.敌人定义来源 != null:
		return max(单位.敌人定义来源.基础行动速度, 1.0)
	return 1.0


static func 取可行动单位(单位列表: Array[战斗单位运行时]) -> Array[战斗单位运行时]:
	var 结果: Array[战斗单位运行时] = []
	for 单位: 战斗单位运行时 in 单位列表:
		if 单位 != null and 单位.可行动():
			结果.append(单位)
	结果.sort_custom(_比较单位行动顺序)
	return 结果


static func _比较单位行动顺序(甲: 战斗单位运行时, 乙: 战斗单位运行时) -> bool:
	if 甲 == null:
		return false
	if 乙 == null:
		return true
	if not is_equal_approx(甲.当前行动进度, 乙.当前行动进度):
		return 甲.当前行动进度 > 乙.当前行动进度
	var 甲速度: float = 取行动速度(甲)
	var 乙速度: float = 取行动速度(乙)
	if not is_equal_approx(甲速度, 乙速度):
		return 甲速度 > 乙速度
	return 甲.当前槽位 < 乙.当前槽位