extends RefCounted
class_name 演示战斗数据仓库

const 数据路径 := "res://数据/战斗/演示/演示战斗数据.json"


static func 创建演示英雄列表() -> Array[英雄战役状态]:
	var 数据: Dictionary = _读取数据()
	var 技能映射: Dictionary = _构建技能映射(数据)
	var 结果: Array[英雄战役状态] = []
	var 英雄数据列表: Array = 数据.get("heroes", [])
	for 英雄数据值: Variant in 英雄数据列表:
		var 英雄数据: Dictionary = 英雄数据值 as Dictionary
		if 英雄数据.is_empty():
			continue
		var 英雄资源: 英雄定义 = 英雄定义.new()
		英雄资源.英雄编号 = StringName(String(英雄数据.get("id", "未命名英雄")))
		英雄资源.名称 = String(英雄数据.get("name", 英雄资源.英雄编号))
		英雄资源.主属性类型 = _解析主属性类型(String(英雄数据.get("primary_attribute", "力量")))
		英雄资源.初始行动速度 = float(英雄数据.get("agility", 1.0))
		英雄资源.初始行动阈值 = 100.0
		英雄资源.基础属性 = _解析属性列表(英雄数据.get("base_attributes", []))
		var 技能列表: Array[技能定义] = _按编号取技能列表(英雄数据.get("skills", []), 技能映射)
		if not 技能列表.is_empty():
			英雄资源.初始专属技能 = 技能列表[0]
			英雄资源.可学习技能 = 技能列表
		var 英雄状态: 英雄战役状态 = 英雄战役状态.new()
		英雄状态.英雄定义资源 = 英雄资源
		英雄状态.当前等级 = 1
		英雄状态.当前装备技能 = 技能列表
		结果.append(英雄状态)
	return 结果


static func 创建演示敌人列表() -> Array[敌人定义]:
	var 数据: Dictionary = _读取数据()
	var 技能映射: Dictionary = _构建技能映射(数据)
	var 结果: Array[敌人定义] = []
	var 敌人数据列表: Array = 数据.get("enemies", [])
	for 敌人数据值: Variant in 敌人数据列表:
		var 敌人数据: Dictionary = 敌人数据值 as Dictionary
		if 敌人数据.is_empty():
			continue
		var 敌人资源: 敌人定义 = 敌人定义.new()
		敌人资源.敌人编号 = StringName(String(敌人数据.get("id", "未命名敌人")))
		敌人资源.名称 = String(敌人数据.get("name", 敌人资源.敌人编号))
		敌人资源.基础行动速度 = float(敌人数据.get("speed", 1.0))
		敌人资源.基础属性 = _解析属性列表(敌人数据.get("base_attributes", []))
		敌人资源.可用技能 = _按编号取技能列表(敌人数据.get("skills", []), 技能映射)
		结果.append(敌人资源)
	return 结果


static func _读取数据() -> Dictionary:
	if not FileAccess.file_exists(数据路径):
		push_warning("演示战斗数据不存在：%s" % 数据路径)
		return {}
	var 原始文本: String = FileAccess.get_file_as_string(数据路径)
	var 解析结果: Variant = JSON.parse_string(原始文本)
	if not (解析结果 is Dictionary):
		push_warning("演示战斗数据解析失败：%s" % 数据路径)
		return {}
	return 解析结果


static func _构建技能映射(数据: Dictionary) -> Dictionary:
	var 映射: Dictionary = {}
	var 技能数据列表: Array = 数据.get("skills", [])
	for 技能数据值: Variant in 技能数据列表:
		var 技能数据: Dictionary = 技能数据值 as Dictionary
		if 技能数据.is_empty():
			continue
		var 技能: 技能定义 = 技能定义.new()
		技能.技能编号 = StringName(String(技能数据.get("id", "未命名技能")))
		技能.名称 = String(技能数据.get("name", 技能.技能编号))
		技能.描述 = String(技能数据.get("description", ""))
		技能.可用站位 = _解析整数数组(技能数据.get("usable_slots", []))
		技能.可选目标站位 = _解析整数数组(技能数据.get("target_slots", []))
		技能.目标阵营 = _解析目标阵营(String(技能数据.get("target_camp", "敌方单体")))
		技能.魔法消耗 = int(技能数据.get("mana_cost", 0))
		技能.冷却回合 = int(技能数据.get("cooldown", 0))
		技能.命中修正 = float(技能数据.get("accuracy_bonus", 0.0))
		技能.暴击修正 = float(技能数据.get("critical_bonus", 0.0))
		技能.是否基础攻击 = bool(技能数据.get("is_basic_attack", false))
		技能.技能标签 = _解析字符串数组(技能数据.get("tags", []))
		技能.效果列表 = _解析效果列表(技能数据.get("effects", []))
		映射[String(技能.技能编号)] = 技能
	return 映射


static func _按编号取技能列表(技能编号列表值: Variant, 技能映射: Dictionary) -> Array[技能定义]:
	var 结果: Array[技能定义] = []
	var 技能编号列表: Array = 技能编号列表值 as Array
	for 技能编号值: Variant in 技能编号列表:
		var 技能编号: String = String(技能编号值)
		if 技能映射.has(技能编号):
			结果.append(技能映射[技能编号] as 技能定义)
	return 结果


static func _解析属性列表(属性列表值: Variant) -> Array[属性修正定义]:
	var 结果: Array[属性修正定义] = []
	var 属性列表: Array = 属性列表值 as Array
	for 属性数据值: Variant in 属性列表:
		var 属性数据: Dictionary = 属性数据值 as Dictionary
		if 属性数据.is_empty():
			continue
		var 修正: 属性修正定义 = 属性修正定义.new()
		修正.属性 = _解析属性类型(String(属性数据.get("attribute", "力量")))
		var 数值: float = float(属性数据.get("value", 0.0))
		修正.最小值 = 数值
		修正.最大值 = 数值
		结果.append(修正)
	return 结果


static func _解析效果列表(效果列表值: Variant) -> Array[技能效果定义]:
	var 结果: Array[技能效果定义] = []
	var 效果列表: Array = 效果列表值 as Array
	for 效果数据值: Variant in 效果列表:
		var 效果数据: Dictionary = 效果数据值 as Dictionary
		if 效果数据.is_empty():
			continue
		var 效果: 技能效果定义 = 技能效果定义.new()
		效果.效果类型值 = _解析效果类型(String(效果数据.get("type", "伤害")))
		效果.关联属性 = _解析属性类型(String(效果数据.get("attribute", "力量")))
		效果.数值系数 = float(效果数据.get("coefficient", 0.0))
		效果.位移格数 = int(效果数据.get("shift", 0))
		效果.行动进度变化值 = float(效果数据.get("progress", 0.0))
		效果.压力变化值 = int(效果数据.get("stress", 0))
		结果.append(效果)
	return 结果


static func _解析字符串数组(数组值: Variant) -> PackedStringArray:
	var 结果: PackedStringArray = PackedStringArray()
	var 源数组: Array = 数组值 as Array
	for 数值: Variant in 源数组:
		结果.append(String(数值))
	return 结果


static func _解析整数数组(数组值: Variant) -> PackedInt32Array:
	var 结果: PackedInt32Array = PackedInt32Array()
	var 源数组: Array = 数组值 as Array
	for 数值: Variant in 源数组:
		结果.append(int(数值))
	return 结果


static func _解析目标阵营(文本: String) -> 目标阵营类型.枚举:
	match 文本:
		"自身":
			return 目标阵营类型.枚举.自身
		"友方单体":
			return 目标阵营类型.枚举.友方单体
		"友方群体":
			return 目标阵营类型.枚举.友方群体
		"敌方群体":
			return 目标阵营类型.枚举.敌方群体
		"任意单体":
			return 目标阵营类型.枚举.任意单体
		"任意群体":
			return 目标阵营类型.枚举.任意群体
		_:
			return 目标阵营类型.枚举.敌方单体


static func _解析主属性类型(文本: String) -> 英雄主属性类型.枚举:
	match 文本:
		"敏捷":
			return 英雄主属性类型.枚举.敏捷
		"智力":
			return 英雄主属性类型.枚举.智力
		_:
			return 英雄主属性类型.枚举.力量


static func _解析效果类型(文本: String) -> 效果类型.枚举:
	match 文本:
		"治疗":
			return 效果类型.枚举.治疗
		"位移":
			return 效果类型.枚举.位移
		"施加状态":
			return 效果类型.枚举.施加状态
		"移除状态":
			return 效果类型.枚举.移除状态
		"增加压力":
			return 效果类型.枚举.增加压力
		"恢复压力":
			return 效果类型.枚举.恢复压力
		"光照变化":
			return 效果类型.枚举.光照变化
		"属性修正":
			return 效果类型.枚举.属性修正
		"行动进度变化":
			return 效果类型.枚举.行动进度变化
		_:
			return 效果类型.枚举.伤害


static func _解析属性类型(文本: String) -> 属性类型.枚举:
	match 文本:
		"敏捷":
			return 属性类型.枚举.敏捷
		"智力":
			return 属性类型.枚举.智力
		"生命值":
			return 属性类型.枚举.生命值
		"物理攻击力":
			return 属性类型.枚举.物理攻击力
		"魔法值":
			return 属性类型.枚举.魔法值
		"魔法抗性":
			return 属性类型.枚举.魔法抗性
		"护甲":
			return 属性类型.枚举.护甲
		"速度":
			return 属性类型.枚举.速度
		"暴击率":
			return 属性类型.枚举.暴击率
		"闪避率":
			return 属性类型.枚举.闪避率
		"命中率":
			return 属性类型.枚举.命中率
		"压力上限":
			return 属性类型.枚举.压力上限
		"压力抗性":
			return 属性类型.枚举.压力抗性
		_:
			return 属性类型.枚举.力量
