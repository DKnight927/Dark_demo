extends Resource
class_name 状态效果定义

@export var 状态编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 状态标签: PackedStringArray = PackedStringArray()
@export var 持续回合: int = 1
@export var 最大层数: int = 1
@export var 叠加时刷新持续时间: bool = true
@export var 叠加时增加强度: bool = false
@export var 属性修正列表: Array[属性修正定义] = []
@export var 每回合效果: Array[技能效果定义] = []
@export var 是否负面状态: bool = true
@export var 使目标无法行动: bool = false
@export var 免疫状态编号列表: PackedStringArray = PackedStringArray()
