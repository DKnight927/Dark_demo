extends Resource
class_name 装备定义

@export var 装备编号: StringName
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 槽位类型: 装备槽位类型.枚举 = 装备槽位类型.枚举.武器
@export var 基础属性: Array[属性修正定义] = []
@export var 可出现品质: Array[int] = [
	装备品质类型.枚举.绿色,
	装备品质类型.枚举.蓝色,
	装备品质类型.枚举.紫色,
	装备品质类型.枚举.橙色
]
@export var 可用词条池: Array[装备词条定义] = []
