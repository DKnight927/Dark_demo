extends Resource
class_name 特质定义

@export var 特质编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 是否正面: bool = true
@export var 品质: StringName
@export var 属性修正列表: Array[属性修正定义] = []
@export var 条件修正列表: Array[条件属性修正定义] = []
@export var 来源标签列表: PackedStringArray = PackedStringArray()
