extends Resource
class_name 怪物词缀定义

@export var 词缀编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 分类: StringName = &"general"
@export var 最低层级: StringName = &"shallow"
@export var 建议权重: int = 10
@export var 特殊机制类型: StringName = &"attribute"
@export_multiline var 主要效果说明: String = ""
@export var 属性修正列表: Array[属性修正定义] = []
@export var 附加技能: Array[技能定义] = []
@export var 命中触发效果: Array[技能效果定义] = []
@export var 回合开始效果: Array[技能效果定义] = []
@export var 免疫状态列表: Array[状态效果定义] = []
@export var 冲突词缀编号列表: PackedStringArray = PackedStringArray()
@export var 允许普通精英: bool = true
@export var 允许剧情精英: bool = true
@export var 是否精英专属: bool = true
