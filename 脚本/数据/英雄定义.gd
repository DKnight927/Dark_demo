extends Resource
class_name 英雄定义

@export var 英雄编号: StringName
@export var 名称: String = ""
@export_multiline var 简介: String = ""
@export var 主属性类型: 英雄主属性类型.枚举 = 英雄主属性类型.枚举.力量
@export var 初始等级: int = 1
@export var 基础属性: Array[属性修正定义] = []
@export var 属性成长: Array[属性成长定义] = []
@export var 初始专属技能: 技能定义
@export var 可学习技能: Array[技能定义] = []
@export var 可用天赋: Array[天赋定义] = []
@export var 初始行动速度: float = 1.0
@export var 初始行动阈值: float = 100.0


func 取默认已装备技能() -> Array[技能定义]:
	var 技能列表: Array[技能定义] = []
	if 初始专属技能 != null:
		技能列表.append(初始专属技能)
	return 技能列表
