extends Node
class_name 战役流程控制器

enum 阶段 {
	主菜单,
	城镇,
	地牢,
	战斗,
	结算,
}

var 当前阶段: 阶段 = 阶段.主菜单


func 切换到阶段(目标阶段: 阶段) -> void:
	当前阶段 = 目标阶段
