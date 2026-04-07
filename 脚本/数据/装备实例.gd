extends Resource
class_name 装备实例

@export var 实例编号: StringName
@export var 来源定义: 装备定义
@export var 品质: 装备品质类型.枚举 = 装备品质类型.枚举.绿色
@export var 词条列表: Array[装备词条定义] = []
@export var 随机属性覆盖: Array[属性修正定义] = []
