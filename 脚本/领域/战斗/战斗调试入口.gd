extends Node
class_name 战斗调试入口

@export var 自动补帧步长: float = 5.0
@export var 自动补帧上限: int = 40
@export var 敌方行动预备时长: float = 2.0

var 战斗控制器实例: 战斗控制器
var 已选目标槽位: int = 1
var 已选技能: 技能定义
var 敌方行动计时器: Timer
var 敌方行动挂起: bool = false
var 待执行敌方行动者: 战斗单位运行时
var 待执行敌方技能: 技能定义
var 当前技能选择行动者标识: StringName

var 界面层: CanvasLayer
var 背景层: ColorRect
var 根边距: MarginContainer
var 根布局: VBoxContainer

var 顶部光照面板: PanelContainer
var 顶部光照布局: HBoxContainer
var 光照标题标签: Label
var 光照描述标签: Label
var 光照进度条: ProgressBar

var 战场面板: PanelContainer
var 战场布局: HBoxContainer
var 我方行: HBoxContainer
var 战场中缝: PanelContainer
var 敌方行: HBoxContainer
var 战场浮动层: Control
var 战场提示面板: PanelContainer
var 战场提示标签: Label
var 战场提示补间: Tween
var 我方卡片映射: Dictionary = {}
var 敌方卡片映射: Dictionary = {}

var 底部面板: PanelContainer
var 底部布局: VBoxContainer
var 技能信息行: HBoxContainer
var 当前单位标签: Label
var 当前技能标签: Label
var 技能按钮行: HBoxContainer
var 当前脉冲立像: CanvasItem
var 当前脉冲补间: Tween


func _ready() -> void:
	randomize()
	_构建敌方行动计时器()
	构建界面()
	构建演示战斗()
	刷新界面()


func _构建敌方行动计时器() -> void:
	敌方行动计时器 = Timer.new()
	敌方行动计时器.one_shot = true
	敌方行动计时器.timeout.connect(_on_敌方行动计时器超时)
	add_child(敌方行动计时器)


func 构建界面() -> void:
	界面层 = CanvasLayer.new()
	add_child(界面层)

	背景层 = ColorRect.new()
	背景层.set_anchors_preset(Control.PRESET_FULL_RECT)
	背景层.color = Color(0.03, 0.04, 0.04)
	界面层.add_child(背景层)

	根边距 = MarginContainer.new()
	根边距.set_anchors_preset(Control.PRESET_FULL_RECT)
	根边距.add_theme_constant_override("margin_left", 18)
	根边距.add_theme_constant_override("margin_top", 18)
	根边距.add_theme_constant_override("margin_right", 18)
	根边距.add_theme_constant_override("margin_bottom", 18)
	界面层.add_child(根边距)

	根布局 = VBoxContainer.new()
	根布局.add_theme_constant_override("separation", 14)
	根边距.add_child(根布局)

	_构建顶部光照区域()
	_构建战场区域()
	_构建底部区域()


func _构建顶部光照区域() -> void:
	顶部光照面板 = PanelContainer.new()
	顶部光照面板.custom_minimum_size = Vector2(0, 52)
	顶部光照面板.add_theme_stylebox_override("panel", _创建面板样式(Color(0.05, 0.05, 0.04), Color(0.36, 0.29, 0.14), 1, 8, 10))
	根布局.add_child(顶部光照面板)

	顶部光照布局 = HBoxContainer.new()
	顶部光照布局.alignment = BoxContainer.ALIGNMENT_CENTER
	顶部光照布局.add_theme_constant_override("separation", 12)
	顶部光照面板.add_child(顶部光照布局)

	光照标题标签 = Label.new()
	光照标题标签.text = "光照"
	顶部光照布局.add_child(光照标题标签)

	光照进度条 = ProgressBar.new()
	光照进度条.show_percentage = false
	光照进度条.min_value = 0
	光照进度条.max_value = 100
	光照进度条.custom_minimum_size = Vector2(220, 12)
	_应用进度条样式(光照进度条, Color(0.90, 0.79, 0.34), Color(0.16, 0.13, 0.09))
	顶部光照布局.add_child(光照进度条)

	光照描述标签 = Label.new()
	顶部光照布局.add_child(光照描述标签)


func _构建战场区域() -> void:
	战场面板 = PanelContainer.new()
	战场面板.custom_minimum_size = Vector2(0, 330)
	战场面板.size_flags_vertical = Control.SIZE_EXPAND_FILL
	战场面板.add_theme_stylebox_override("panel", _创建面板样式(Color(0.02, 0.04, 0.04), Color(0.10, 0.14, 0.13), 1, 10, 12))
	根布局.add_child(战场面板)

	战场布局 = HBoxContainer.new()
	战场布局.add_theme_constant_override("separation", 10)
	战场面板.add_child(战场布局)

	我方行 = HBoxContainer.new()
	我方行.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	我方行.add_theme_constant_override("separation", 8)
	战场布局.add_child(我方行)
	构建阵营卡片(我方行, [4, 3, 2, 1], 我方卡片映射, true)

	战场中缝 = PanelContainer.new()
	战场中缝.custom_minimum_size = Vector2(22, 226)
	战场中缝.add_theme_stylebox_override("panel", _创建面板样式(Color(0.05, 0.07, 0.06), Color(0.16, 0.20, 0.16), 1, 6, 0))
	战场布局.add_child(战场中缝)

	敌方行 = HBoxContainer.new()
	敌方行.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	敌方行.add_theme_constant_override("separation", 8)
	战场布局.add_child(敌方行)
	构建阵营卡片(敌方行, [1, 2, 3, 4], 敌方卡片映射, false)

	战场浮动层 = Control.new()
	战场浮动层.set_anchors_preset(Control.PRESET_FULL_RECT)
	战场浮动层.mouse_filter = Control.MOUSE_FILTER_IGNORE
	战场面板.add_child(战场浮动层)

	战场提示面板 = PanelContainer.new()
	战场提示面板.add_theme_stylebox_override("panel", _创建面板样式(Color(0.06, 0.06, 0.05, 0.92), Color(0.42, 0.33, 0.16), 1, 8, 8))
	战场提示面板.mouse_filter = Control.MOUSE_FILTER_IGNORE
	战场提示面板.visible = false
	战场提示面板.position = Vector2(0, 18)
	战场提示面板.size = Vector2(280, 42)
	战场浮动层.add_child(战场提示面板)

	战场提示标签 = Label.new()
	战场提示标签.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	战场提示标签.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	战场提示标签.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	战场提示面板.add_child(战场提示标签)


func _构建底部区域() -> void:
	底部面板 = PanelContainer.new()
	底部面板.custom_minimum_size = Vector2(0, 126)
	底部面板.add_theme_stylebox_override("panel", _创建面板样式(Color(0.04, 0.04, 0.05), Color(0.37, 0.29, 0.14), 2, 8, 12))
	根布局.add_child(底部面板)

	底部布局 = VBoxContainer.new()
	底部布局.add_theme_constant_override("separation", 8)
	底部面板.add_child(底部布局)

	技能信息行 = HBoxContainer.new()
	技能信息行.add_theme_constant_override("separation", 14)
	底部布局.add_child(技能信息行)

	当前单位标签 = Label.new()
	当前单位标签.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	技能信息行.add_child(当前单位标签)

	当前技能标签 = Label.new()
	当前技能标签.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	当前技能标签.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	技能信息行.add_child(当前技能标签)

	技能按钮行 = HBoxContainer.new()
	技能按钮行.alignment = BoxContainer.ALIGNMENT_CENTER
	技能按钮行.add_theme_constant_override("separation", 10)
	底部布局.add_child(技能按钮行)


func _创建面板样式(背景色: Color, 边框色: Color, 边框宽度: int, 圆角: int, 内边距: int) -> StyleBoxFlat:
	var 样式: StyleBoxFlat = StyleBoxFlat.new()
	样式.bg_color = 背景色
	样式.border_color = 边框色
	样式.border_width_left = 边框宽度
	样式.border_width_top = 边框宽度
	样式.border_width_right = 边框宽度
	样式.border_width_bottom = 边框宽度
	样式.corner_radius_top_left = 圆角
	样式.corner_radius_top_right = 圆角
	样式.corner_radius_bottom_left = 圆角
	样式.corner_radius_bottom_right = 圆角
	样式.content_margin_left = 内边距
	样式.content_margin_right = 内边距
	样式.content_margin_top = 内边距
	样式.content_margin_bottom = 内边距
	return 样式


func _创建技能按钮样式(是否选中: bool, 是否基础攻击: bool, 是否禁用: bool) -> StyleBoxFlat:
	var 样式: StyleBoxFlat = StyleBoxFlat.new()
	样式.corner_radius_top_left = 8
	样式.corner_radius_top_right = 8
	样式.corner_radius_bottom_left = 8
	样式.corner_radius_bottom_right = 8
	样式.border_width_left = 2
	样式.border_width_top = 2
	样式.border_width_right = 2
	样式.border_width_bottom = 2
	样式.content_margin_left = 12
	样式.content_margin_right = 12
	样式.content_margin_top = 10
	样式.content_margin_bottom = 10
	样式.shadow_color = Color(0.0, 0.0, 0.0, 0.35)
	样式.shadow_size = 3
	if 是否禁用:
		样式.bg_color = Color(0.08, 0.08, 0.09)
		样式.border_color = Color(0.18, 0.18, 0.18)
	elif 是否选中:
		样式.bg_color = Color(0.67, 0.57, 0.23)
		样式.border_color = Color(0.96, 0.90, 0.60)
		样式.shadow_color = Color(0.69, 0.55, 0.18, 0.25)
		样式.shadow_size = 5
	else:
		样式.bg_color = Color(0.09, 0.09, 0.10)
		样式.border_color = Color(0.24, 0.22, 0.18)
	return 样式


func _应用进度条样式(进度条: ProgressBar, 填充色: Color, 底色: Color) -> void:
	var 背景样式: StyleBoxFlat = StyleBoxFlat.new()
	背景样式.bg_color = 底色
	背景样式.corner_radius_top_left = 2
	背景样式.corner_radius_top_right = 2
	背景样式.corner_radius_bottom_left = 2
	背景样式.corner_radius_bottom_right = 2
	var 填充样式: StyleBoxFlat = StyleBoxFlat.new()
	填充样式.bg_color = 填充色
	填充样式.corner_radius_top_left = 2
	填充样式.corner_radius_top_right = 2
	填充样式.corner_radius_bottom_left = 2
	填充样式.corner_radius_bottom_right = 2
	进度条.add_theme_stylebox_override("background", 背景样式)
	进度条.add_theme_stylebox_override("fill", 填充样式)
	进度条.custom_minimum_size = Vector2(0, 8)


func 构建阵营卡片(父节点: HBoxContainer, 顺序: Array, 卡片映射: Dictionary, 是否我方: bool) -> void:
	for 槽位值: Variant in 顺序:
		var 槽位: int = int(槽位值)
		var 面板: PanelContainer = PanelContainer.new()
		面板.custom_minimum_size = Vector2(110, 228)
		面板.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		面板.mouse_filter = Control.MOUSE_FILTER_STOP
		面板.gui_input.connect(_on_卡片输入.bind(槽位, 是否我方))
		面板.add_theme_stylebox_override("panel", _创建单位卡片样式(false))
		父节点.add_child(面板)

		var 卡片布局: VBoxContainer = VBoxContainer.new()
		卡片布局.add_theme_constant_override("separation", 6)
		面板.add_child(卡片布局)

		var 顶部行: HBoxContainer = HBoxContainer.new()
		顶部行.add_theme_constant_override("separation", 6)
		卡片布局.add_child(顶部行)

		var 槽位标签: Label = Label.new()
		槽位标签.text = "%d号位" % 槽位
		槽位标签.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		顶部行.add_child(槽位标签)

		var 状态标签: Label = Label.new()
		状态标签.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		状态标签.custom_minimum_size = Vector2(38, 0)
		顶部行.add_child(状态标签)

		var 立像容器: MarginContainer = MarginContainer.new()
		立像容器.custom_minimum_size = Vector2(0, 98)
		卡片布局.add_child(立像容器)

		var 立像占位: ColorRect = ColorRect.new()
		立像占位.set_anchors_preset(Control.PRESET_FULL_RECT)
		立像占位.color = Color(0.08, 0.09, 0.09)
		立像容器.add_child(立像占位)

		var 效果覆盖层: ColorRect = ColorRect.new()
		效果覆盖层.set_anchors_preset(Control.PRESET_FULL_RECT)
		效果覆盖层.color = Color(1, 1, 1, 0)
		效果覆盖层.mouse_filter = Control.MOUSE_FILTER_IGNORE
		立像容器.add_child(效果覆盖层)

		var 名称标签: Label = Label.new()
		名称标签.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		名称标签.text = "空位"
		卡片布局.add_child(名称标签)

		var 生命条: ProgressBar = ProgressBar.new()
		生命条.show_percentage = false
		生命条.min_value = 0
		生命条.max_value = 100
		生命条.value = 0
		_应用进度条样式(生命条, Color(0.78, 0.22, 0.18), Color(0.16, 0.09, 0.09))
		卡片布局.add_child(生命条)

		var 生命文本: Label = Label.new()
		生命文本.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		卡片布局.add_child(生命文本)

		var 蓝量条: ProgressBar = ProgressBar.new()
		蓝量条.show_percentage = false
		蓝量条.min_value = 0
		蓝量条.max_value = 100
		蓝量条.value = 0
		_应用进度条样式(蓝量条, Color(0.24, 0.58, 0.96), Color(0.08, 0.12, 0.18))
		卡片布局.add_child(蓝量条)

		var 蓝量文本: Label = Label.new()
		蓝量文本.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		卡片布局.add_child(蓝量文本)

		var 压力条: ProgressBar = ProgressBar.new()
		压力条.show_percentage = false
		压力条.min_value = 0
		压力条.max_value = 200
		压力条.value = 0
		_应用进度条样式(压力条, Color(0.72, 0.47, 0.92), Color(0.12, 0.08, 0.16))
		卡片布局.add_child(压力条)

		var 压力文本: Label = Label.new()
		压力文本.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		卡片布局.add_child(压力文本)

		卡片映射[槽位] = {
			"panel": 面板,
			"slot": 槽位标签,
			"state": 状态标签,
			"portrait": 立像占位,
			"overlay": 效果覆盖层,
			"name": 名称标签,
			"hp_bar": 生命条,
			"hp_text": 生命文本,
			"mp_bar": 蓝量条,
			"mp_text": 蓝量文本,
			"stress_bar": 压力条,
			"stress_text": 压力文本,
			"is_ally": 是否我方
		}


func _创建单位卡片样式(是否高亮: bool, 是否可选目标: bool = false, 是否选中目标: bool = false) -> StyleBoxFlat:
	var 样式: StyleBoxFlat = StyleBoxFlat.new()
	样式.bg_color = Color(0.08, 0.08, 0.09)
	样式.border_width_left = 2
	样式.border_width_top = 2
	样式.border_width_right = 2
	样式.border_width_bottom = 2
	样式.border_color = Color(0.22, 0.22, 0.24)
	样式.corner_radius_top_left = 8
	样式.corner_radius_top_right = 8
	样式.corner_radius_bottom_left = 8
	样式.corner_radius_bottom_right = 8
	样式.content_margin_left = 8
	样式.content_margin_right = 8
	样式.content_margin_top = 8
	样式.content_margin_bottom = 8
	样式.shadow_color = Color(0.0, 0.0, 0.0, 0.36)
	样式.shadow_size = 4
	if 是否可选目标 or 是否选中目标:
		样式.border_width_left = 3
		样式.border_width_top = 3
		样式.border_width_right = 3
		样式.border_width_bottom = 3
		样式.border_color = Color(0.92, 0.96, 1.0)
		样式.shadow_color = Color(0.82, 0.88, 0.98, 0.28)
		样式.shadow_size = 8
	if 是否高亮:
		样式.border_width_left = 3
		样式.border_width_top = 3
		样式.border_width_right = 3
		样式.border_width_bottom = 3
		样式.border_color = Color(0.92, 0.76, 0.26)
		样式.bg_color = Color(0.17, 0.14, 0.08)
		样式.shadow_color = Color(0.93, 0.76, 0.26, 0.30)
		样式.shadow_size = 10
	return 样式


func 构建演示战斗() -> void:
	战斗控制器实例 = 战斗控制器.new()
	add_child(战斗控制器实例)
	var 英雄列表: Array[英雄战役状态] = 演示战斗数据仓库.创建演示英雄列表()
	var 敌人列表: Array[敌人定义] = 演示战斗数据仓库.创建演示敌人列表()
	if 英雄列表.is_empty() or 敌人列表.is_empty():
		英雄列表 = [演示技能工厂.创建前排英雄状态(&"英雄一", 8.0), 演示技能工厂.创建后排英雄状态(&"英雄二", 12.0)]
		敌人列表 = [演示技能工厂.创建敌人定义(&"敌人一", 6.0), 演示技能工厂.创建敌人定义(&"敌人二", 9.0)]
	战斗控制器实例.初始化战斗(英雄列表, 敌人列表)
	if not 战斗控制器实例.当前战斗状态.英雄单位列表.is_empty():
		var 首名英雄: 战斗单位运行时 = 战斗控制器实例.当前战斗状态.英雄单位列表[0]
		首名英雄.当前行动进度 = 首名英雄.行动阈值
		战斗控制器实例.当前战斗状态.当前可行动单位 = [首名英雄]
		_确保当前技能有效()


func _on_卡片输入(事件: InputEvent, 槽位: int, 是否我方卡片: bool) -> void:
	if 敌方行动挂起:
		return
	if not (事件 is InputEventMouseButton):
		return
	var 鼠标事件: InputEventMouseButton = 事件
	if 鼠标事件.button_index != MOUSE_BUTTON_LEFT or not 鼠标事件.pressed:
		return
	if not _卡片可作为当前目标(槽位, 是否我方卡片):
		return
	已选目标槽位 = 槽位
	var 可行动单位: Array[战斗单位运行时] = 战斗控制器实例.取可行动单位()
	if 可行动单位.is_empty() or 已选技能 == null:
		return
	_执行技能(可行动单位[0], 已选技能)


func _on_技能按钮按下(技能: 技能定义) -> void:
	if 敌方行动挂起:
		return
	已选技能 = 技能
	var 可行动单位: Array[战斗单位运行时] = 战斗控制器实例.取可行动单位()
	if not 可行动单位.is_empty():
		当前技能选择行动者标识 = 可行动单位[0].单位标识
		已选目标槽位 = _为行动者选择默认目标槽位(可行动单位[0], 技能)
	刷新界面()


func _执行技能(行动者: 战斗单位运行时, 技能: 技能定义, 驱动跑圈: bool = true) -> void:
	var 敌方单位: Array[战斗单位运行时] = 战斗控制器实例.当前战斗状态.敌方单位列表
	var 我方单位: Array[战斗单位运行时] = 战斗控制器实例.当前战斗状态.英雄单位列表
	var 目标阵营: Array[战斗单位运行时] = 敌方单位 if 我方单位.has(行动者) else 我方单位
	var 施法前快照: Dictionary = _快照全部单位()
	var 意图: 行动意图 = 行动意图.new()
	意图.行动者标识 = 行动者.单位标识
	意图.施放技能 = 技能
	意图.施法站位 = 行动者.当前槽位
	意图.目标槽位列表 = PackedInt32Array([已选目标槽位])
	var 结果: 最终行动 = 战斗控制器实例.提交行动(行动者, 意图)
	if 结果 == null:
		_创建浮动文本("无法施放", 行动者.当前槽位, not 我方单位.has(行动者), 0, Color(0.80, 0.80, 0.82))
		return
	_显示浮动结算(结果, 目标阵营)
	_显示战场提示(_构建行动提示文案(行动者, 技能, 结果))
	_播放结算卡片反馈(施法前快照, 行动者)
	_确保当前技能有效()
	刷新界面()
	if 战斗控制器实例.当前战斗状态.战斗是否结束:
		return
	if 驱动跑圈:
		_推进跑圈直到我方回合(行动者)


func _推进跑圈直到我方回合(上一个行动者: 战斗单位运行时 = null) -> void:
	敌方行动挂起 = false
	待执行敌方行动者 = null
	待执行敌方技能 = null
	已选技能 = null
	var 空转步数: int = 0
	var 安全上限: int = max(自动补帧上限 * 4, 20)
	while not 战斗控制器实例.当前战斗状态.战斗是否结束 and 空转步数 < 安全上限:
		var 可行动单位: Array[战斗单位运行时] = 战斗控制器实例.取可行动单位()
		if 可行动单位.is_empty():
			战斗控制器实例.推进战斗(自动补帧步长)
			空转步数 += 1
			continue
		var 当前行动者: 战斗单位运行时 = 可行动单位[0]
		if 上一个行动者 != null and 当前行动者 == 上一个行动者:
			当前行动者.当前行动进度 = 0.0
			战斗控制器实例.当前战斗状态.当前可行动单位 = 行动进度服务.取可行动单位(战斗控制器实例.当前战斗状态.取全部单位())
			continue
		if 战斗控制器实例.当前战斗状态.英雄单位列表.has(当前行动者):
			_确保当前技能有效()
			刷新界面()
			break
		var 技能列表: Array[技能定义] = 战斗控制器实例.取单位可用技能(当前行动者)
		if 技能列表.is_empty():
			当前行动者.当前行动进度 = 0.0
			战斗控制器实例.当前战斗状态.当前可行动单位 = 行动进度服务.取可行动单位(战斗控制器实例.当前战斗状态.取全部单位())
			continue
		已选技能 = 技能列表[0]
		已选目标槽位 = _为行动者选择默认目标槽位(当前行动者, 已选技能)
		敌方行动挂起 = true
		待执行敌方行动者 = 当前行动者
		待执行敌方技能 = 已选技能
		刷新界面()
		_创建浮动文本("%s" % 已选技能.名称, 当前行动者.当前槽位, true, 0, Color(0.96, 0.90, 0.72))
		_显示战场提示("%s 准备施放 %s" % [String(当前行动者.单位标识), 已选技能.名称])
		敌方行动计时器.start(敌方行动预备时长)
		break


func _on_敌方行动计时器超时() -> void:
	if not 敌方行动挂起 or 待执行敌方行动者 == null or 待执行敌方技能 == null:
		return
	var 行动者: 战斗单位运行时 = 待执行敌方行动者
	var 技能: 技能定义 = 待执行敌方技能
	敌方行动挂起 = false
	待执行敌方行动者 = null
	待执行敌方技能 = null
	if 行动者.当前生命值 <= 0:
		刷新界面()
		return
	_执行技能(行动者, 技能, false)
	if 战斗控制器实例.当前战斗状态.战斗是否结束:
		刷新界面()
		return
	_推进跑圈直到我方回合(行动者)


func _为行动者选择默认目标槽位(行动者: 战斗单位运行时, 技能: 技能定义) -> int:
	var 是否我方行动者: bool = 战斗控制器实例.当前战斗状态.英雄单位列表.has(行动者)
	match 技能.目标阵营:
		目标阵营类型.枚举.自身:
			return 行动者.当前槽位
		目标阵营类型.枚举.友方单体, 目标阵营类型.枚举.友方群体:
			var 友方列表: Array[战斗单位运行时] = 战斗控制器实例.当前战斗状态.英雄单位列表 if 是否我方行动者 else 战斗控制器实例.当前战斗状态.敌方单位列表
			return _从阵营选择首个合法槽位(友方列表, 技能)
		目标阵营类型.枚举.敌方单体, 目标阵营类型.枚举.敌方群体:
			var 敌对列表: Array[战斗单位运行时] = 战斗控制器实例.当前战斗状态.敌方单位列表 if 是否我方行动者 else 战斗控制器实例.当前战斗状态.英雄单位列表
			return _从阵营选择首个合法槽位(敌对列表, 技能)
		目标阵营类型.枚举.任意单体, 目标阵营类型.枚举.任意群体:
			return _从阵营选择首个合法槽位(战斗控制器实例.当前战斗状态.取全部单位(), 技能)
	return 1


func _从阵营选择首个合法槽位(单位列表: Array[战斗单位运行时], 技能: 技能定义) -> int:
	for 槽位: int in [1, 2, 3, 4]:
		for 单位: 战斗单位运行时 in 单位列表:
			if 单位 != null and 单位.当前生命值 > 0 and 单位.当前槽位 == 槽位 and 站位合法性服务.技能可命中目标槽位(技能, 槽位):
				return 槽位
	return 1


func _确保当前技能有效() -> void:
	var 可行动单位: Array[战斗单位运行时] = 战斗控制器实例.取可行动单位()
	if 可行动单位.is_empty():
		已选技能 = null
		当前技能选择行动者标识 = StringName()
		return
	var 当前行动者: 战斗单位运行时 = 可行动单位[0]
	var 技能列表: Array[技能定义] = 战斗控制器实例.取单位可用技能(当前行动者)
	if 技能列表.is_empty():
		已选技能 = null
		当前技能选择行动者标识 = 当前行动者.单位标识
		return
	if 当前技能选择行动者标识 != 当前行动者.单位标识:
		当前技能选择行动者标识 = 当前行动者.单位标识
		已选技能 = null
		return
	if 已选技能 != null and not 技能列表.has(已选技能):
		已选技能 = null
	if 已选技能 != null:
		已选目标槽位 = _为行动者选择默认目标槽位(当前行动者, 已选技能)


func _快照单位(单位列表: Array[战斗单位运行时]) -> Dictionary:
	var 快照: Dictionary = {}
	for 单位: 战斗单位运行时 in 单位列表:
		if 单位 == null:
			continue
		快照[String(单位.单位标识)] = {"hp": 单位.当前生命值, "mp": 单位.当前魔法值, "stress": 单位.当前压力值, "slot": 单位.当前槽位, "ally": 单位.英雄状态来源 != null}
	return 快照



func _快照全部单位() -> Dictionary:
	return _快照单位(战斗控制器实例.当前战斗状态.取全部单位())
func _构建结果摘要文本(结果: 最终行动, 施法前快照: Dictionary, 单位列表: Array[战斗单位运行时]) -> String:
	if 结果 != null and not 结果.结果摘要列表.is_empty():
		return "，".join(结果.结果摘要列表)
	return _构建效果摘要(施法前快照, 单位列表, 结果)


func _构建效果摘要(施法前快照: Dictionary, 单位列表: Array[战斗单位运行时], 结果: 最终行动) -> String:
	var 摘要列表: PackedStringArray = PackedStringArray()
	for 单位: 战斗单位运行时 in 单位列表:
		if 单位 == null:
			continue
		var 键: String = String(单位.单位标识)
		if not 施法前快照.has(键):
			continue
		var 施法前数据: Dictionary = 施法前快照[键]
		var 施法前生命: int = int(施法前数据["hp"])
		var 施法前槽位: int = int(施法前数据["slot"])
		if 单位.当前生命值 != 施法前生命:
			var 生命变化: int = 单位.当前生命值 - 施法前生命
			if 生命变化 < 0:
				摘要列表.append("%s 受到 %d 伤害" % [键, -生命变化])
			else:
				摘要列表.append("%s 恢复 %d 生命" % [键, 生命变化])
		if 单位.当前槽位 != 施法前槽位:
			摘要列表.append("%s 被移到 %d 号位" % [键, 单位.当前槽位])
		if 施法前生命 > 0 and 单位.当前生命值 <= 0:
			摘要列表.append("%s 倒下" % 键)
	if 摘要列表.is_empty() and 结果 != null and 结果.最终目标槽位列表.is_empty():
		摘要列表.append("未命中合法目标")
	return "，".join(摘要列表)


func _显示浮动结算(结果: 最终行动, 目标阵营: Array[战斗单位运行时]) -> void:
	if 战场浮动层 == null or 结果 == null:
		return
	if not 结果.结果摘要列表.is_empty():
		for 索引: int in range(结果.结果摘要列表.size()):
			var 摘要文本: String = String(结果.结果摘要列表[索引])
			var 槽位: int = 已选目标槽位
			if 索引 < 结果.最终目标槽位列表.size():
				槽位 = int(结果.最终目标槽位列表[索引])
			var 浮动信息: Dictionary = _构建浮动信息(摘要文本)
			_创建浮动文本(String(浮动信息.get("text", 摘要文本)), 槽位, _目标阵营是否敌方(目标阵营), 索引, Color(浮动信息.get("color", Color(0.95, 0.86, 0.62))))
		return
	for 槽位值: int in 结果.最终目标槽位列表:
		_创建浮动文本("命中", int(槽位值), _目标阵营是否敌方(目标阵营), 0, Color(0.95, 0.86, 0.62))


func _构建浮动信息(摘要文本: String) -> Dictionary:
	if 摘要文本.contains("暴击") and 摘要文本.contains("造成"):
		return {"text": "暴击 %s" % _提取数字文本(摘要文本, "0"), "color": Color(0.99, 0.80, 0.34)}
	if 摘要文本.contains("造成") and 摘要文本.contains("伤害"):
		return {"text": "-%s" % _提取数字文本(摘要文本, "0"), "color": Color(0.93, 0.34, 0.28)}
	if 摘要文本.contains("未命中"):
		return {"text": "未命中", "color": Color(0.76, 0.78, 0.82)}
	if 摘要文本.contains("恢复") and 摘要文本.contains("生命"):
		return {"text": "+%s" % _提取数字文本(摘要文本, "0"), "color": Color(0.40, 0.86, 0.54)}
	if 摘要文本.contains("恢复") and 摘要文本.contains("蓝量"):
		return {"text": "+%s 蓝量" % _提取数字文本(摘要文本, "0"), "color": Color(0.45, 0.75, 0.98)}
	if 摘要文本.contains("恢复") and 摘要文本.contains("压力"):
		return {"text": "-%s 压力" % _提取数字文本(摘要文本, "0"), "color": Color(0.58, 0.83, 0.96)}
	if 摘要文本.contains("施加") and 摘要文本.contains("压力"):
		return {"text": "+%s 压力" % _提取数字文本(摘要文本, "0"), "color": Color(0.75, 0.45, 0.94)}
	if 摘要文本.contains("位移") or 摘要文本.contains("移到"):
		return {"text": "位移", "color": Color(0.89, 0.73, 0.46)}
	if 摘要文本.contains("击倒") or 摘要文本.contains("倒下"):
		return {"text": "击倒", "color": Color(0.90, 0.28, 0.24)}
	return {"text": 摘要文本, "color": Color(0.95, 0.86, 0.62)}


func _提取数字文本(摘要文本: String, 默认值: String) -> String:
	var 数字列表: PackedStringArray = PackedStringArray()
	var 当前数字: String = ""
	for 索引: int in range(摘要文本.length()):
		var 字符: String = 摘要文本.substr(索引, 1)
		if 字符 >= "0" and 字符 <= "9":
			当前数字 += 字符
		elif 当前数字 != "":
			数字列表.append(当前数字)
			当前数字 = ""
	if 当前数字 != "":
		数字列表.append(当前数字)
	if 数字列表.is_empty():
		return 默认值
	return 数字列表[数字列表.size() - 1]


func _目标阵营是否敌方(目标阵营: Array[战斗单位运行时]) -> bool:
	for 单位: 战斗单位运行时 in 目标阵营:
		if 单位 != null and 战斗控制器实例.当前战斗状态.敌方单位列表.has(单位):
			return true
	return false



func _显示战场提示(文本: String) -> void:
	if 战场提示面板 == null or 战场提示标签 == null or 文本.strip_edges() == "":
		return
	if 战场提示补间 != null and is_instance_valid(战场提示补间):
		战场提示补间.kill()
	战场提示标签.text = 文本
	战场提示面板.visible = true
	战场提示面板.modulate = Color(1, 1, 1, 0)
	战场提示面板.size = Vector2(maxf(280.0, minf(640.0, float(max(文本.length() * 16, 280)))), 42)
	战场提示面板.position = Vector2((战场面板.size.x - 战场提示面板.size.x) * 0.5, 18)
	战场提示补间 = create_tween()
	战场提示补间.tween_property(战场提示面板, "modulate:a", 1.0, 0.12)
	战场提示补间.tween_interval(1.1)
	战场提示补间.tween_property(战场提示面板, "modulate:a", 0.0, 0.25)
	战场提示补间.tween_callback(func() -> void:
		if 战场提示面板 != null:
			战场提示面板.visible = false
	)


func _构建行动提示文案(行动者: 战斗单位运行时, 技能: 技能定义, 结果: 最终行动) -> String:
	var 行动者名称: String = String(行动者.单位标识)
	var 技能名: String = 技能.名称 if 技能 != null else "动作"
	if 结果 == null or 结果.结果摘要列表.is_empty():
		return "%s 使用了 %s" % [行动者名称, 技能名]
	return "%s 使用 %s：%s" % [行动者名称, 技能名, String(结果.结果摘要列表[0])]
func _创建浮动文本(文本: String, 槽位: int, 是否敌方: bool, 偏移序号: int = 0, 字体颜色: Color = Color(0.95, 0.86, 0.62)) -> void:
	var 映射: Dictionary = 敌方卡片映射 if 是否敌方 else 我方卡片映射
	if not 映射.has(槽位):
		return
	var 面板: PanelContainer = 映射[槽位]["panel"]
	var 标签: Label = Label.new()
	标签.text = 文本
	标签.z_index = 20
	标签.mouse_filter = Control.MOUSE_FILTER_IGNORE
	标签.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	标签.add_theme_color_override("font_color", 字体颜色)
	标签.add_theme_color_override("font_outline_color", Color(0.08, 0.08, 0.08))
	标签.add_theme_constant_override("outline_size", 4)
	战场浮动层.add_child(标签)
	var 起点: Vector2 = 面板.global_position - 战场浮动层.global_position + Vector2(4, 26 + float(偏移序号 * 16))
	标签.position = 起点
	标签.size = Vector2(maxf(面板.size.x - 8.0, 84.0), 24)
	var 补间: Tween = create_tween()
	补间.tween_property(标签, "position", 起点 + Vector2(0, -42), 0.95)
	补间.parallel().tween_property(标签, "modulate:a", 0.0, 0.95)
	补间.tween_callback(标签.queue_free)


func 刷新界面() -> void:
	刷新顶部光照()
	刷新阵营卡片()
	刷新技能信息()
	刷新技能按钮()



func 刷新技能信息() -> void:
	if 当前单位标签 == null or 当前技能标签 == null:
		return
	var 可行动单位: Array[战斗单位运行时] = 战斗控制器实例.取可行动单位()
	if 可行动单位.is_empty() or 敌方行动挂起:
		当前单位标签.text = ""
		当前技能标签.text = ""
		return
	var 当前行动者: 战斗单位运行时 = 可行动单位[0]
	当前单位标签.text = "当前行动：%s" % String(当前行动者.单位标识)
	if 已选技能 == null:
		当前技能标签.text = "请选择技能"
	else:
		当前技能标签.text = "%s | 耗蓝 %d | 冷却 %d" % [已选技能.名称, 已选技能.魔法消耗, 已选技能.冷却回合]
func 刷新顶部光照() -> void:
	if 光照进度条 == null or 战斗控制器实例 == null or 战斗控制器实例.当前战斗状态 == null:
		return
	var 光照值: int = clampi(战斗控制器实例.当前战斗状态.当前光照值, 0, 100)
	光照进度条.value = 光照值
	光照描述标签.text = "%s  %d" % [_取光照描述(光照值), 光照值]


func _取光照描述(光照值: int) -> String:
	if 光照值 >= 76:
		return "明亮"
	if 光照值 >= 51:
		return "稳定"
	if 光照值 >= 26:
		return "昏暗"
	return "漆黑"


func 刷新阵营卡片() -> void:
	var 战斗状态实例: 战斗状态 = 战斗控制器实例.当前战斗状态
	var 当前高亮单位: 战斗单位运行时 = null
	var 可行动单位: Array[战斗单位运行时] = 战斗控制器实例.取可行动单位()
	if 敌方行动挂起 and 待执行敌方行动者 != null:
		当前高亮单位 = 待执行敌方行动者
	elif not 可行动单位.is_empty():
		当前高亮单位 = 可行动单位[0]
	刷新单侧卡片(战斗状态实例.英雄单位列表, 我方卡片映射, 当前高亮单位)
	刷新单侧卡片(战斗状态实例.敌方单位列表, 敌方卡片映射, 当前高亮单位)
	_更新当前行动脉冲(当前高亮单位)


func 刷新单侧卡片(单位列表: Array[战斗单位运行时], 卡片映射: Dictionary, 当前高亮单位: 战斗单位运行时) -> void:
	for 槽位值: Variant in 卡片映射.keys():
		var 槽位: int = int(槽位值)
		var 条目: Dictionary = 卡片映射[槽位]
		var 面板: PanelContainer = 条目["panel"]
		var 槽位标签: Label = 条目["slot"]
		var 状态标签: Label = 条目["state"]
		var 立像占位: ColorRect = 条目["portrait"]
		var 效果覆盖层: ColorRect = 条目["overlay"]
		var 名称标签: Label = 条目["name"]
		var 生命条: ProgressBar = 条目["hp_bar"]
		var 生命文本: Label = 条目["hp_text"]
		var 蓝量条: ProgressBar = 条目["mp_bar"]
		var 蓝量文本: Label = 条目["mp_text"]
		var 压力条: ProgressBar = 条目["stress_bar"]
		var 压力文本: Label = 条目["stress_text"]
		var 单位: 战斗单位运行时 = _按槽位查找单位(单位列表, 槽位)
		var 是否高亮: bool = 单位 != null and 单位 == 当前高亮单位
		var 是否可选目标: bool = _卡片处于可选目标状态(单位, bool(条目["is_ally"]))
		var 是否选中目标: bool = _卡片处于已选目标状态(单位, bool(条目["is_ally"]))
		面板.add_theme_stylebox_override("panel", _创建单位卡片样式(是否高亮, 是否可选目标, 是否选中目标))
		if 单位 == null:
			槽位标签.text = "%d号位" % 槽位
			状态标签.text = ""
			立像占位.color = Color(0.08, 0.09, 0.09)
			效果覆盖层.color = Color(1, 1, 1, 0)
			名称标签.text = "空位"
			生命条.max_value = 100
			生命条.value = 0
			生命文本.text = "生命 0/0"
			蓝量条.max_value = 100
			蓝量条.value = 0
			蓝量文本.text = "蓝量 0/0"
			压力条.max_value = 200
			压力条.value = 0
			压力文本.text = "压力 --"
			continue
		槽位标签.text = "%d号位" % 单位.当前槽位
		状态标签.text = "行动中" if 是否高亮 else ""
		立像占位.color = Color(0.12, 0.18, 0.15) if bool(条目["is_ally"]) else Color(0.18, 0.11, 0.13)
		效果覆盖层.color = Color(1, 1, 1, 0)
		名称标签.text = String(单位.单位标识)
		var 生命上限: int = _取单位生命上限(单位)
		var 蓝量上限: int = _取单位蓝量上限(单位)
		生命条.max_value = max(生命上限, 1)
		生命条.value = clampi(单位.当前生命值, 0, max(生命上限, 1))
		生命文本.text = "生命 %d/%d" % [单位.当前生命值, 生命上限]
		蓝量条.max_value = max(蓝量上限, 1)
		蓝量条.value = clampi(单位.当前魔法值, 0, max(蓝量上限, 1))
		蓝量文本.text = "蓝量 %d/%d" % [单位.当前魔法值, 蓝量上限]
		if bool(条目["is_ally"]):
			压力条.max_value = 200
			压力条.value = clampi(单位.当前压力值, 0, 200)
			压力文本.text = "压力 %d/200" % 单位.当前压力值
		else:
			压力条.max_value = 200
			压力条.value = 0
			压力文本.text = "压力 --"




func _卡片处于可选目标状态(单位: 战斗单位运行时, 是否我方卡片: bool) -> bool:
	if 单位 == null or 已选技能 == null or 敌方行动挂起:
		return false
	var 可行动单位: Array[战斗单位运行时] = 战斗控制器实例.取可行动单位()
	if 可行动单位.is_empty():
		return false
	var 行动者: 战斗单位运行时 = 可行动单位[0]
	if 单位 == 行动者:
		return false
	return _卡片可作为当前目标(单位.当前槽位, 是否我方卡片)


func _卡片处于已选目标状态(单位: 战斗单位运行时, 是否我方卡片: bool) -> bool:
	if not _卡片处于可选目标状态(单位, 是否我方卡片):
		return false
	return 单位.当前槽位 == 已选目标槽位
func _取卡片条目(是否我方: bool, 槽位: int) -> Dictionary:
	var 映射: Dictionary = 我方卡片映射 if 是否我方 else 敌方卡片映射
	if not 映射.has(槽位):
		return {}
	return 映射[槽位]


func _更新当前行动脉冲(当前高亮单位: 战斗单位运行时) -> void:
	if 当前脉冲补间 != null and is_instance_valid(当前脉冲补间):
		当前脉冲补间.kill()
	当前脉冲补间 = null
	if 当前脉冲立像 != null and is_instance_valid(当前脉冲立像):
		当前脉冲立像.scale = Vector2.ONE
	当前脉冲立像 = null


func _播放卡片反馈(是否我方: bool, 槽位: int, 颜色: Color, 浮动缩放: float = 1.03) -> void:
	var 条目: Dictionary = _取卡片条目(是否我方, 槽位)
	if 条目.is_empty():
		return
	var 面板: PanelContainer = 条目["panel"]
	var 覆盖层: ColorRect = 条目["overlay"]
	面板.pivot_offset = 面板.size * 0.5
	覆盖层.color = 颜色
	面板.scale = Vector2(浮动缩放, 浮动缩放)
	var 补间: Tween = create_tween()
	补间.tween_property(覆盖层, "color", Color(颜色.r, 颜色.g, 颜色.b, 0.0), 0.34)
	补间.parallel().tween_property(面板, "scale", Vector2.ONE, 0.22)


func _播放结算卡片反馈(施法前快照: Dictionary, 行动者: 战斗单位运行时) -> void:
	for 键值: Variant in 施法前快照.keys():
		var 标识: String = String(键值)
		var 快照数据: Dictionary = 施法前快照[标识]
		var 单位: 战斗单位运行时 = _按标识查找单位(标识)
		if 单位 == null:
			continue
		var 是否我方: bool = bool(快照数据.get("ally", true))
		var 原槽位: int = int(快照数据.get("slot", 单位.当前槽位))
		if 单位.当前生命值 < int(快照数据.get("hp", 单位.当前生命值)):
			_播放卡片反馈(是否我方, 原槽位, Color(1.0, 0.34, 0.30, 0.42), 1.06)
		elif 单位.当前生命值 > int(快照数据.get("hp", 单位.当前生命值)):
			_播放卡片反馈(是否我方, 单位.当前槽位, Color(0.30, 0.96, 0.46, 0.34), 1.04)
		if 单位.当前压力值 > int(快照数据.get("stress", 单位.当前压力值)):
			_播放卡片反馈(是否我方, 单位.当前槽位, Color(0.78, 0.45, 1.0, 0.34), 1.03)
		elif 单位.当前压力值 < int(快照数据.get("stress", 单位.当前压力值)):
			_播放卡片反馈(是否我方, 单位.当前槽位, Color(0.34, 0.84, 1.0, 0.30), 1.03)
		if 单位.当前槽位 != 原槽位:
			_播放卡片反馈(是否我方, 单位.当前槽位, Color(0.98, 0.86, 0.36, 0.28), 1.035)
	if 行动者 != null:
		var 行动者是否我方: bool = 战斗控制器实例.当前战斗状态.英雄单位列表.has(行动者)
		_播放卡片反馈(行动者是否我方, 行动者.当前槽位, Color(0.96, 0.80, 0.28, 0.18), 1.03)


func _按标识查找单位(标识: String) -> 战斗单位运行时:
	for 单位: 战斗单位运行时 in 战斗控制器实例.当前战斗状态.取全部单位():
		if 单位 != null and String(单位.单位标识) == 标识:
			return 单位
	return null
func 刷新技能按钮() -> void:
	for 子节点: Node in 技能按钮行.get_children():
		子节点.queue_free()
	var 可行动单位: Array[战斗单位运行时] = 战斗控制器实例.取可行动单位()
	if 可行动单位.is_empty():
		return
	var 当前行动者: 战斗单位运行时 = 可行动单位[0]
	if 敌方行动挂起 or 战斗控制器实例.当前战斗状态.敌方单位列表.has(当前行动者):
		return
	var 全部技能: Array[技能定义] = _取当前行动者全部技能(当前行动者)
	var 可用技能: Array[技能定义] = 战斗控制器实例.取单位可用技能(当前行动者)
	for 技能: 技能定义 in 全部技能:
		var 按钮: Button = Button.new()
		var 剩余冷却: int = 当前行动者.取技能剩余冷却(技能)
		var 是否禁用: bool = 剩余冷却 > 0 or not 可用技能.has(技能)
		按钮.custom_minimum_size = Vector2(138, 64)
		var 标签文本: String = _技能短标签(技能)
		if 技能.魔法消耗 > 0:
			标签文本 = "%s  耗蓝%d" % [标签文本, 技能.魔法消耗]
		按钮.text = "%s\n%s" % [技能.名称, 标签文本]
		if 剩余冷却 > 0:
			按钮.text = "%s\n冷却 %d" % [技能.名称, 剩余冷却]
		按钮.tooltip_text = 技能.描述
		按钮.disabled = 是否禁用
		按钮.focus_mode = Control.FOCUS_NONE
		按钮.add_theme_stylebox_override("normal", _创建技能按钮样式(已选技能 == 技能, 技能.是否基础攻击, 是否禁用))
		按钮.add_theme_stylebox_override("hover", _创建技能按钮样式(已选技能 == 技能, 技能.是否基础攻击, 是否禁用))
		按钮.add_theme_stylebox_override("pressed", _创建技能按钮样式(true, 技能.是否基础攻击, 是否禁用))
		按钮.add_theme_stylebox_override("disabled", _创建技能按钮样式(false, 技能.是否基础攻击, true))
		if 已选技能 == 技能 and not 是否禁用:
			按钮.add_theme_color_override("font_color", Color(0.15, 0.11, 0.02))
			按钮.add_theme_color_override("font_hover_color", Color(0.15, 0.11, 0.02))
			按钮.add_theme_color_override("font_pressed_color", Color(0.15, 0.11, 0.02))

		按钮.pressed.connect(_on_技能按钮按下.bind(技能))
		技能按钮行.add_child(按钮)


func _取当前行动者全部技能(当前行动者: 战斗单位运行时) -> Array[技能定义]:
	var 结果: Array[技能定义] = []
	if 当前行动者 == null:
		return 结果
	if 当前行动者.英雄状态来源 != null:
		结果.append_array(当前行动者.英雄状态来源.取当前已装备技能())
	elif 当前行动者.敌人定义来源 != null:
		结果.append_array(当前行动者.敌人定义来源.可用技能)
	return 结果


func _技能短标签(技能: 技能定义) -> String:
	if 技能 == null:
		return "未选定"
	if not 技能.技能标签.is_empty():
		return "/".join(技能.技能标签)
	var 标签列表: PackedStringArray = PackedStringArray()
	for 效果: 技能效果定义 in 技能.效果列表:
		match 效果.效果类型值:
			效果类型.枚举.伤害:
				标签列表.append("基础攻击" if 技能.是否基础攻击 else "伤害")
			效果类型.枚举.治疗:
				标签列表.append("治疗")
			效果类型.枚举.位移:
				标签列表.append("位移")
			效果类型.枚举.行动进度变化:
				标签列表.append("控速")
			效果类型.枚举.增加压力:
				标签列表.append("施压")
			效果类型.枚举.恢复压力:
				标签列表.append("减压")
	if 标签列表.is_empty():
		return "基础"
	return "/".join(标签列表)


func _取单位生命上限(单位: 战斗单位运行时) -> int:
	for 属性: 属性修正定义 in 单位.当前属性:
		if 属性 != null and 属性.属性 == 属性类型.枚举.生命值:
			return int(属性.最小值)
	return max(单位.当前生命值, 1)


func _取单位蓝量上限(单位: 战斗单位运行时) -> int:
	for 属性: 属性修正定义 in 单位.当前属性:
		if 属性 != null and 属性.属性 == 属性类型.枚举.魔法值:
			return int(属性.最小值)
	return max(单位.当前魔法值, 1)


func _按槽位查找单位(单位列表: Array[战斗单位运行时], 槽位: int) -> 战斗单位运行时:
	for 单位: 战斗单位运行时 in 单位列表:
		if 单位 != null and 单位.当前生命值 > 0 and 单位.当前槽位 == 槽位:
			return 单位
	return null


func _卡片可作为当前目标(槽位: int, 是否我方卡片: bool) -> bool:
	var 可行动单位: Array[战斗单位运行时] = 战斗控制器实例.取可行动单位()
	if 可行动单位.is_empty() or 已选技能 == null:
		return false
	var 行动者: 战斗单位运行时 = 可行动单位[0]
	var 行动者是否我方: bool = 战斗控制器实例.当前战斗状态.英雄单位列表.has(行动者)
	if not 站位合法性服务.技能可命中目标槽位(已选技能, 槽位):
		return false
	match 已选技能.目标阵营:
		目标阵营类型.枚举.自身:
			return 是否我方卡片 == 行动者是否我方 and 槽位 == 行动者.当前槽位
		目标阵营类型.枚举.友方单体, 目标阵营类型.枚举.友方群体:
			return 是否我方卡片 == 行动者是否我方 and _按槽位查找单位(战斗控制器实例.当前战斗状态.英雄单位列表 if 行动者是否我方 else 战斗控制器实例.当前战斗状态.敌方单位列表, 槽位) != null
		目标阵营类型.枚举.敌方单体, 目标阵营类型.枚举.敌方群体:
			return 是否我方卡片 != 行动者是否我方 and _按槽位查找单位(战斗控制器实例.当前战斗状态.敌方单位列表 if 行动者是否我方 else 战斗控制器实例.当前战斗状态.英雄单位列表, 槽位) != null
		目标阵营类型.枚举.任意单体, 目标阵营类型.枚举.任意群体:
			return _按槽位查找单位(战斗控制器实例.当前战斗状态.英雄单位列表 if 是否我方卡片 else 战斗控制器实例.当前战斗状态.敌方单位列表, 槽位) != null
	return false
