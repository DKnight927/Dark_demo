extends RefCounted
class_name 属性计算服务


static func 汇总属性修正(属性修正列表: Array[属性修正定义]) -> Dictionary:
	var 结果: Dictionary = {}
	for 属性修正: 属性修正定义 in 属性修正列表:
		if 属性修正 == null:
			continue
		if not 结果.has(属性修正.属性):
			结果[属性修正.属性] = 0.0
		结果[属性修正.属性] += 属性修正.最小值
	return 结果


static func 计算英雄基础属性(英雄资源: 英雄定义, 等级: int) -> Dictionary:
	var 结果: Dictionary = 汇总属性修正(英雄资源.基础属性)
	for 成长: 属性成长定义 in 英雄资源.属性成长:
		if 成长 == null:
			continue
		if not 结果.has(成长.属性):
			结果[成长.属性] = 0.0
		结果[成长.属性] += float(max(_取成长等级(等级), 0)) * 成长.每级成长值
	_应用基础派生(结果)
	_应用英雄主属性加成(结果, 英雄资源.主属性类型)
	return 结果


static func 计算敌人基础属性(敌人资源: 敌人定义, 词缀列表: Array[怪物词缀定义] = []) -> Dictionary:
	var 来源列表: Array[属性修正定义] = []
	来源列表.append_array(敌人资源.基础属性)
	for 词缀: 怪物词缀定义 in 词缀列表:
		if 词缀 == null:
			continue
		来源列表.append_array(词缀.属性修正列表)
	var 结果: Dictionary = 汇总属性修正(来源列表)
	_应用基础派生(结果)
	return 结果


static func 计算英雄最终属性(英雄状态: 英雄战役状态) -> Dictionary:
	var 英雄资源: 英雄定义 = 英雄状态.英雄定义资源
	var 结果: Dictionary = 计算英雄基础属性(英雄资源, 英雄状态.当前等级)
	if 英雄状态.装备栏状态 != null:
		for 装备: 装备实例 in 英雄状态.装备栏状态.取全部装备():
			_叠加装备实例属性(结果, 装备)
	for 天赋: 天赋定义 in 英雄状态.已解锁天赋:
		if 天赋 == null:
			continue
		_叠加属性字典(结果, 汇总属性修正(天赋.属性修正列表))
	return 结果


static func 转换为属性修正列表(属性值字典: Dictionary) -> Array[属性修正定义]:
	var 列表: Array[属性修正定义] = []
	for 属性: Variant in 属性值字典.keys():
		var 修正: 属性修正定义 = 属性修正定义.new()
		修正.属性 = 属性
		修正.最小值 = float(属性值字典[属性])
		修正.最大值 = float(属性值字典[属性])
		列表.append(修正)
	return 列表


static func _叠加装备实例属性(结果: Dictionary, 装备: 装备实例) -> void:
	if 装备 == null:
		return
	if 装备.来源定义 != null:
		_叠加属性字典(结果, 汇总属性修正(装备.来源定义.基础属性))
	for 词条: 装备词条定义 in 装备.词条列表:
		if 词条 == null:
			continue
		_叠加属性字典(结果, 汇总属性修正(词条.属性修正列表))
	_叠加属性字典(结果, 汇总属性修正(装备.随机属性覆盖))


static func _叠加属性字典(目标: Dictionary, 来源: Dictionary) -> void:
	for 属性: Variant in 来源.keys():
		if not 目标.has(属性):
			目标[属性] = 0.0
		目标[属性] += 来源[属性]


static func _应用基础派生(结果: Dictionary) -> void:
	var 力量值: float = float(结果.get(属性类型.枚举.力量, 0.0))
	var 敏捷值: float = float(结果.get(属性类型.枚举.敏捷, 0.0))
	var 智力值: float = float(结果.get(属性类型.枚举.智力, 0.0))
	_增加属性值(结果, 属性类型.枚举.生命值, 力量值 * 10.0)
	_增加属性值(结果, 属性类型.枚举.物理攻击力, 力量值 * 2.0)
	_增加属性值(结果, 属性类型.枚举.护甲, 敏捷值 * 1.5)
	_增加属性值(结果, 属性类型.枚举.速度, 敏捷值 * 1.0)
	_增加属性值(结果, 属性类型.枚举.魔法值, 智力值 * 8.0)
	_增加属性值(结果, 属性类型.枚举.魔法抗性, 智力值 * 1.5)


static func _应用英雄主属性加成(结果: Dictionary, 主属性类型: 英雄主属性类型.枚举) -> void:
	var 力量值: float = float(结果.get(属性类型.枚举.力量, 0.0))
	var 敏捷值: float = float(结果.get(属性类型.枚举.敏捷, 0.0))
	var 智力值: float = float(结果.get(属性类型.枚举.智力, 0.0))
	match 主属性类型:
		英雄主属性类型.枚举.力量:
			_增加属性值(结果, 属性类型.枚举.物理攻击力, 力量值)
		英雄主属性类型.枚举.敏捷:
			_增加属性值(结果, 属性类型.枚举.速度, 敏捷值 * 0.5)
		英雄主属性类型.枚举.智力:
			_增加属性值(结果, 属性类型.枚举.魔法值, 智力值 * 0.5)


static func _增加属性值(结果: Dictionary, 属性: 属性类型.枚举, 数值: float) -> void:
	if not 结果.has(属性):
		结果[属性] = 0.0
	结果[属性] += 数值


static func _取成长等级(等级: int) -> int:
	return max(等级 - 1, 0)