extends Resource
class_name 地牢会话状态

@export var 会话编号: StringName
@export var 参与英雄: Array[英雄战役状态] = []
@export var 当前光照值: int = 100
@export var 当前地图编号: StringName
@export var 当前节点编号: StringName
@export var 已访问节点: PackedStringArray = PackedStringArray()
@export var 背包物品: Array[Resource] = []
@export var 当前子状态: StringName
