extends Control


func change_state(new_state: CamStateResource) -> void:
	_frame_time.wait_time = new_state.anim_fps / 1.0
	_current_index = 0
	_animate()


# -- PRIVATE -------------------------------------------------------------------
var _cam_state: CamStateResource
var _current_index: int = 0

@onready var _frame_time: Timer = $FrameTime
@onready var _cam_view: TextureRect = $cam_view

func _animate() -> void:
	_cam_view.texture = _cam_state.images[_current_index]
	_frame_time.start()

func _on_frame_time_timeout() -> void:
	_current_index = _current_index + 1
	if _current_index >= _cam_state.images.size() and _cam_state.loops:
		_current_index = 0
	else:
		return
	_cam_view.texture = _cam_state.images[_current_index]
	_frame_time.start()
