@tool
extends Control

enum { MARGIN_LEFT, MARGIN_RIGHT, MARGIN_TOP, MARGIN_BOTTOM, MARGIN_CENTER }

const DRAW_NOTHING := -1
const DRAW_CENTERED := -2
const MARGIN_NONE := -1

var _draw_margin := DRAW_NOTHING
var _should_split := false


func _draw() -> void:
	var rect: Rect2
	if _draw_margin == DRAW_NOTHING:
		return
	elif _draw_margin == DRAW_CENTERED:
		rect = Rect2(Vector2.ZERO, size)
	elif _draw_margin == MARGIN_LEFT:
		rect = Rect2(0, 0, size.x * 0.5, size.y)
	elif _draw_margin == MARGIN_TOP:
		rect = Rect2(0, 0, size.x, size.y * 0.5)
	elif _draw_margin == MARGIN_RIGHT:
		var half_width = size.x * 0.5
		rect = Rect2(half_width, 0, half_width, size.y)
	elif _draw_margin == MARGIN_BOTTOM:
		var half_height = size.y * 0.5
		rect = Rect2(0, half_height, size.x, half_height)
	var stylebox := get_theme_stylebox("panel", "TooltipPanel")
	draw_style_box(stylebox, rect)


func set_enabled(enabled: bool, should_split: bool = true) -> void:
	visible = enabled
	_should_split = should_split
	if enabled:
		clear_hover()


func get_hover_margin() -> int:
	return _draw_margin


func clear_hover() -> void:
	_draw_margin = DRAW_NOTHING
	mouse_filter = MOUSE_FILTER_IGNORE
	queue_redraw()


func _can_drop_data(pos: Vector2, data) -> bool:
	return get_parent()._can_drop_data(pos, data)


func _drop_data(pos: Vector2, data) -> void:
	get_parent()._drop_data(pos, data)


func update_hover(local_pos: Vector2) -> void:
	mouse_filter = MOUSE_FILTER_STOP
	if _should_split:
		_draw_margin = _find_hover_margin(local_pos)
	else:
		_draw_margin = DRAW_CENTERED
	queue_redraw()


func _find_hover_margin(point: Vector2) -> int:
	var half_size := size * 0.5

	var left := point.distance_squared_to(Vector2(0, half_size.y))
	var lesser := left
	var lesser_margin := MARGIN_LEFT

	var top := point.distance_squared_to(Vector2(half_size.x, 0))
	if lesser > top:
		lesser = top
		lesser_margin = MARGIN_TOP

	var right := point.distance_squared_to(Vector2(size.x, half_size.y))
	if lesser > right:
		lesser = right
		lesser_margin = MARGIN_RIGHT

	var bottom := point.distance_squared_to(Vector2(half_size.x, size.y))
	if lesser > bottom:
		#lesser = bottom  # unused result
		lesser_margin = MARGIN_BOTTOM
	return lesser_margin
