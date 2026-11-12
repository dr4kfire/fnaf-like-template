class_name CamDisplay
extends Control


func change_state(new_state: CamStateResource) -> void:
	if new_state == _cam_state:
		return
	_frame_time.wait_time = new_state.anim_fps / 1.0
	_cam_state = new_state
	_current_index = 0
	play_switch_effect()
	_animate()

func play_switch_effect() -> void:
	_switch_effect.stop()
	_switch_effect.play("default")


# -- PRIVATE -------------------------------------------------------------------
var _cam_state: CamStateResource
var _current_index: int = 0

@onready var _frame_time: Timer = $FrameTime
@onready var _cam_view: TextureRect = $cam_view
@onready var _switch_effect: AnimatedSprite2D = $SwitchEffect

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
