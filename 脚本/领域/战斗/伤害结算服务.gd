extends RefCounted
class_name 伤害结算服务


static func 执行技能效果(行动者: 战斗单位运行时, 所在阵营单位: Array[战斗单位运行时], 目标列表: Array[战斗单位运行时], 效果列表: Array[技能效果定义], 技能: 技能定义 = null) -> PackedStringArray:
	var 结果摘要列表: PackedStringArray = PackedStringArray()
	for 效果: 技能效果定义 in 效果列表:
		if 效果 == null:
			continue
		for 目标: 战斗单位运行时 in 目标列表:
			if 目标 == null or 目标.当前生命值 <= 0:
				continue
			var 摘要: PackedStringArray = _执行单个效果(行动者, 所在阵营单位, 目标, 效果, 技能)
			结果摘要列表.append_array(摘要)
	return 结果摘要列表


static func _执行单个效果(行动者: 战斗单位运行时, 所在阵营单位: Array[战斗单位运行时], 目标: 战斗单位运行时, 效果: 技能效果定义, 技能: 技能定义 = null) -> PackedStringArray:
	var 摘要列表: PackedStringArray = PackedStringArray()
	match 效果.效果类型值:
		效果类型.枚举.伤害:
			if not 命中结算服务.是否命中(行动者, 目标, 技能):
				摘要列表.append("%s 未命中 %s" % [String(行动者.单位标识), String(目标.单位标识)])
				return 摘要列表
			var 是否暴击: bool = 命中结算服务.是否暴击(行动者, 技能)
			var 原始伤害: float = maxf(_取属性值(行动者, 效果.关联属性) * 效果.数值系数, 1.0)
			if 是否暴击:
				原始伤害 *= 1.5
			var 最终伤害: int = 防御结算服务.计算最终伤害(原始伤害, 目标)
			目标.当前生命值 = max(目标.当前生命值 - 最终伤害, 0)
			if 是否暴击:
				摘要列表.append("%s 暴击 %s，造成 %d 伤害" % [String(行动者.单位标识), String(目标.单位标识), 最终伤害])
			else:
				摘要列表.append("%s 对 %s 造成 %d 伤害" % [String(行动者.单位标识), String(目标.单位标识), 最终伤害])
		效果类型.枚举.治疗:
			var 治疗值: int = int(maxf(_取属性值(行动者, 效果.关联属性) * 效果.数值系数, 1.0))
			目标.当前生命值 += 治疗值
			摘要列表.append("%s 为 %s 恢复 %d 生命" % [String(行动者.单位标识), String(目标.单位标识), 治疗值])
		效果类型.枚举.增加压力:
			目标.当前压力值 = mini(目标.当前压力值 + 效果.压力变化值, 200)
			摘要列表.append("%s 对 %s 施加 %d 压力" % [String(行动者.单位标识), String(目标.单位标识), 效果.压力变化值])
		效果类型.枚举.恢复压力:
			目标.当前压力值 = maxi(目标.当前压力值 - 效果.压力变化值, 0)
			摘要列表.append("%s 为 %s 恢复 %d 压力" % [String(行动者.单位标识), String(目标.单位标识), 效果.压力变化值])
		效果类型.枚举.行动进度变化:
			目标.当前行动进度 = maxf(目标.当前行动进度 + 效果.行动进度变化值, 0.0)
			摘要列表.append("%s 使 %s 的行动进度变化 %.1f" % [String(行动者.单位标识), String(目标.单位标识), 效果.行动进度变化值])
		效果类型.枚举.位移:
			位移解析服务.推动单位(所在阵营单位, 目标, 效果.位移格数)
			摘要列表.append("%s 将 %s 位移 %d 格" % [String(行动者.单位标识), String(目标.单位标识), 效果.位移格数])
		效果类型.枚举.施加状态:
			if 效果.目标状态效果 != null:
				var 状态实例: 已施加状态实例 = 已施加状态实例.new()
				状态实例.来源状态定义 = 效果.目标状态效果
				状态实例.剩余回合 = 效果.目标状态效果.持续回合
				状态实例.当前层数 = 1
				状态实例.来源单位标识 = 行动者.单位标识
				目标.已施加状态.append(状态实例)
				摘要列表.append("%s 对 %s 施加状态 %s" % [String(行动者.单位标识), String(目标.单位标识), 效果.目标状态效果.名称])
		_:
			pass
	死亡处理服务.刷新单位死亡状态(目标)
	if 目标.当前生命值 <= 0:
		摘要列表.append("%s 被击倒" % String(目标.单位标识))
	return 摘要列表


static func _取属性值(单位: 战斗单位运行时, 属性枚举: 属性类型.枚举) -> float:
	for 属性: 属性修正定义 in 单位.当前属性:
		if 属性 != null and 属性.属性 == 属性枚举:
			return 属性.最小值
	return 0.0
