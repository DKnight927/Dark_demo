extends Resource
class_name 战斗状态

@export var 英雄单位列表: Array[战斗单位运行时] = []
@export var 敌方单位列表: Array[战斗单位运行时] = []
@export var 当前时间刻度: float = 0.0
@export var 当前可行动单位: Array[战斗单位运行时] = []
@export_range(0, 100, 1) var 当前光照值: int = 76
@export var 战斗是否结束: bool = false
@export var 胜利阵营: StringName


func 取全部单位() -> Array[战斗单位运行时]:
	var 结果: Array[战斗单位运行时] = []
	结果.append_array(英雄单位列表)
	结果.append_array(敌方单位列表)
	return 结果


func 刷新战斗结束状态() -> void:
	var 英雄存活: bool = _阵营仍有存活单位(英雄单位列表)
	var 敌人存活: bool = _阵营仍有存活单位(敌方单位列表)
	战斗是否结束 = not 英雄存活 or not 敌人存活
	if not 战斗是否结束:
		胜利阵营 = &""
	elif 英雄存活:
		胜利阵营 = &"英雄"
	elif 敌人存活:
		胜利阵营 = &"敌人"
	else:
		胜利阵营 = &"无"


func _阵营仍有存活单位(单位列表: Array[战斗单位运行时]) -> bool:
	for 单位: 战斗单位运行时 in 单位列表:
		if 单位 != null and 单位.当前生命值 > 0:
			return true
	return false