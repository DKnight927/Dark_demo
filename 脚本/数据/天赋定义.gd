extends Resource
class_name 天赋定义

@export var 天赋编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 最大等级: int = 1
@export var 属性修正列表: Array[属性修正定义] = []
@export var 解锁等级需求: int = 1
@export var 是否核心天赋: bool = false
