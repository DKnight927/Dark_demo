extends Resource
class_name 怪癖定义

@export var 怪癖编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 是否正面: bool = false
@export var 是否可锁定: bool = false
@export var 属性修正列表: Array[属性修正定义] = []
@export var 条件修正列表: Array[条件属性修正定义] = []
@export var 来源标签列表: PackedStringArray = PackedStringArray()
