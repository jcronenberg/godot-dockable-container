extends "res://addons/dockable_container/layout_node.gd"
"""Layout binary tree nodes, defining subtrees and leaf panels"""

enum Margin {
	MARGIN_LEFT,
	MARGIN_TOP,
	MARGIN_RIGHT,
	MARGIN_BOTTOM,
}

const LayoutPanel = preload("res://addons/dockable_container/layout_panel.gd")

export(Margin) var split = MARGIN_RIGHT setget set_split, get_split
export(float, 0, 1) var percent = 0.5 setget set_percent, get_percent
export(Resource) var first = LayoutPanel.new() setget set_first, get_first
export(Resource) var second = LayoutPanel.new() setget set_second, get_second

var _split = MARGIN_RIGHT
var _percent = 0.5
var _first
var _second


func _init() -> void:
	resource_name = "Split"


func set_first(value) -> void:
	if value == null:
		_first = LayoutPanel.new()
	else:
		_first = value
	_first.parent = self


func get_first():
	return _first


func set_second(value) -> void:
	if value == null:
		_second = LayoutPanel.new()
	else:
		_second = value
	_second.parent = self


func get_second():
	return _second


func set_split(value: int) -> void:
	if value != _split:
		_split = value
		get_root().emit_changed()


func get_split() -> int:
	return _split


func set_percent(value: float) -> void:
	var clamped_value = clamp(value, 0, 1)
	if not is_equal_approx(_percent, clamped_value):
		_percent = clamped_value
		get_root().emit_changed()


func get_percent() -> float:
	return _percent


func _ensure_indices_in_range(data: Dictionary) -> void:
	_first._ensure_indices_in_range(data)
	_second._ensure_indices_in_range(data)


func is_horizontal() -> bool:
	return is_horizontal_margin(_split)


static func is_horizontal_margin(margin: int) -> bool:
	return margin == MARGIN_LEFT or margin == MARGIN_RIGHT