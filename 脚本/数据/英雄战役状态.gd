extends Resource
class_name 英雄战役状态

@export var 英雄定义资源: 英雄定义
@export var 当前等级: int = 1
@export var 当前经验: int = 0
@export var 已学技能状态: 英雄已学技能状态
@export var 当前装备技能: Array[技能定义] = []
@export var 装备栏状态: 英雄装备栏状态
@export var 已解锁天赋: Array[天赋定义] = []
@export var 当前生命值: int = 0
@export var 当前魔法值: int = 0
@export var 当前压力值: int = 0
@export var 是否死亡: bool = false


func 取当前已装备技能() -> Array[技能定义]:
	if 当前装备技能.is_empty() and 英雄定义资源 != null:
		return 英雄定义资源.取默认已装备技能()
	return 当前装备技能
