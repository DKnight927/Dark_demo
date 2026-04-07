extends Resource
class_name 技能书定义

@export var 物品编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 对应技能: 技能定义
@export var 允许英雄列表: Array[英雄定义] = []
