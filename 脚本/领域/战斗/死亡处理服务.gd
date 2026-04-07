extends RefCounted
class_name 死亡处理服务


static func 刷新单位死亡状态(单位: 战斗单位运行时) -> void:
	if 单位 == null:
		return
	if 单位.当前生命值 <= 0:
		单位.当前生命值 = 0
		单位.当前行动进度 = 0.0
		if 单位.英雄状态来源 != null:
			单位.英雄状态来源.是否死亡 = true


static func 刷新阵营死亡状态(单位列表: Array[战斗单位运行时]) -> void:
	for 单位 in 单位列表:
		刷新单位死亡状态(单位)
	阵型整理服务.整理阵型(单位列表)
