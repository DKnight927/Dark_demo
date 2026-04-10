extends Resource
class_name 事件选项定义

@export var 选项编号: StringName
@export var 选项文本: String = ""
@export var 是否需要检定: bool = false
@export var 检定属性: StringName
@export var 检定难度: int = 0
@export var 成功结果列表: Array[Dictionary] = []
@export var 失败结果列表: Array[Dictionary] = []
@export var 直接结果列表: Array[Dictionary] = []
