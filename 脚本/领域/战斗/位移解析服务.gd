extends RefCounted
class_name 位移解析服务


static func 推动单位(单位列表: Array[战斗单位运行时], 目标单位: 战斗单位运行时, 位移格数: int) -> void:
	if 目标单位 == null or 位移格数 == 0:
		return
	var 方向: int = 1 if 位移格数 > 0 else -1
	var 剩余位移: int = absi(位移格数)
	while 剩余位移 > 0:
		var 目标槽位: int = clampi(目标单位.当前槽位 + 方向, 1, 4)
		if 目标槽位 == 目标单位.当前槽位:
			break
		var 阻挡单位: 战斗单位运行时 = _取槽位单位(单位列表, 目标槽位)
		if 阻挡单位 != null:
			阻挡单位.当前槽位 = 目标单位.当前槽位
		目标单位.当前槽位 = 目标槽位
		剩余位移 -= 1


static func _取槽位单位(单位列表: Array[战斗单位运行时], 槽位: int) -> 战斗单位运行时:
	for 单位: 战斗单位运行时 in 单位列表:
		if 单位 != null and 单位.当前生命值 > 0 and 单位.当前槽位 == 槽位:
			return 单位
	return null