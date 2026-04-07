extends Resource
class_name 装备词条定义

@export var 词条编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 适用槽位: Array[int] = []
@export var 属性修正列表: Array[属性修正定义] = []
@export var 最低品质: 装备品质类型.枚举 = 装备品质类型.枚举.绿色
