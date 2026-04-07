extends Resource
class_name 战役状态

@export var 战役编号: StringName
@export var 战役名称: String = ""
@export var 当前周数: int = 1
@export var 英雄名册: Array[英雄战役状态] = []
@export var 城镇资源: 城镇资源状态
@export var 仓库装备: Array[装备实例] = []
@export var 已解锁设施: PackedStringArray = PackedStringArray()
