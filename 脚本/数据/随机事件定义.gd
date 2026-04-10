extends Resource
class_name 随机事件定义

@export var 事件编号: StringName
@export var 标题: String = ""
@export_multiline var 描述: String = ""
@export var 权重: int = 1
@export var 是否唯一: bool = false
@export var 最小层级: int = 1
@export var 最大层级: int = 99
@export var 前置条件列表: Array[Dictionary] = []
@export var 选项列表: Array[事件选项定义] = []
