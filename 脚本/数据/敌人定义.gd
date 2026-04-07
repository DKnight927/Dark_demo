extends Resource
class_name 敌人定义

@export var 敌人编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 基础属性: Array[属性修正定义] = []
@export var 可用技能: Array[技能定义] = []
@export var 可用词缀池: Array[怪物词缀定义] = []
@export var 基础行动速度: float = 1.0
@export var 是否允许精英化: bool = true
