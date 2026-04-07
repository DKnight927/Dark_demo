extends Resource
class_name 光照区间定义

@export_range(0, 100, 1) var 最低光照: int = 0
@export_range(0, 100, 1) var 最高光照: int = 100
@export var 名称: String = ""
@export_multiline var 描述: String = ""
@export var 属性修正列表: Array[属性修正定义] = []


func 包含光照值(光照值: int) -> bool:
	return 光照值 >= 最低光照 and 光照值 <= 最高光照
