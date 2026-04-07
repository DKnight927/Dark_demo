extends Resource
class_name 怪物词缀定义

@export var 词缀编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 属性修正列表: Array[属性修正定义] = []
@export var 附加技能: Array[技能定义] = []
@export var 免疫状态列表: Array[状态效果定义] = []
@export var 是否精英专属: bool = true
