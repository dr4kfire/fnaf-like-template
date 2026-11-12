extends Control

@export var scroll_curve : Curve
@export var states: Array[CamStateResource]


func _process(delta: float) -> void:
	var view_width: float = ProjectSettings.get_setting("display/window/size/viewport_width")
	var mouse_pos : float = get_global_mouse_position().x / view_width
	
	_turn_anchor.position.x = lerpf(_turn_anchor.position.x, scroll_curve.sample(mouse_pos), 10.0*delta)


#region PRIVATE
# -- PRIVATE -------------------------------------------------------------------
var _night: int = 1
var _hour: int = 12
var _in_cams: bool = false:
	set(value):
		_in_cams = value
		_block_panel.visible = _in_cams
		if not _in_cams:
			_cams_view.visible = false

#region onreadys
@onready var _turn_anchor: Control = $TurnAnchor
@onready var _block_panel: Panel = $BLOCK_PANEL
@onready var _cams_view: Control = $UI/Cams
@onready var _camera_view: CamDisplay = $UI/Cams/SubViewportContainer/SubViewport/CameraView

@onready var _door_left: AnimatedSprite2D = $TurnAnchor/DoorLeft
@onready var _door_right: AnimatedSprite2D = $TurnAnchor/DoorRight
@onready var _office_light_right: TextureRect = $TurnAnchor/OfficeTexture/OfficeLightRight
@onready var _office_light_left: TextureRect = $TurnAnchor/OfficeTexture/OfficeLightLeft

@onready var _camera_flip: AnimatedSprite2D = $UI/CameraFlip
@onready var _cam_flip_timer: Timer = $UI/CameraTrigger/CooldownTimer
@onready var _camera_trigger: TextureRect = $UI/CameraTrigger
@onready var _first_cam_button: TextureButton = $UI/Cams/Overlay/Map/cam1b

@onready var _light_active_l: TextureRect = $TurnAnchor/ButtonLeft/LightActive
@onready var _door_active_l: TextureRect = $TurnAnchor/ButtonLeft/DoorActive
@onready var _both_active_l: TextureRect = $TurnAnchor/ButtonLeft/BothActive
@onready var _door_active_r: TextureRect = $TurnAnchor/ButtonRight/DoorActive
@onready var _light_active_r: TextureRect = $TurnAnchor/ButtonRight/LightActive
@onready var _both_active_r: TextureRect = $TurnAnchor/ButtonRight/BothActive


@onready var _boop_sound: AudioStreamPlayer = $Sounds/BoopSound
@onready var _door_close_sound: AudioStreamPlayer = $Sounds/DoorClose
@onready var _lights_sound_l: AudioStreamPlayer = $Sounds/LightsSoundL
@onready var _lights_sound_r: AudioStreamPlayer = $Sounds/LightsSoundR
@onready var _cam_close_sound: AudioStreamPlayer = $Sounds/CamCloseSound
@onready var _cam_open_sound: AudioStreamPlayer = $Sounds/CamOpenSound
@onready var _cam_loop_sound: AudioStreamPlayer = $Sounds/Ambients/CamLoop
@onready var _cam_change_sound: AudioStreamPlayer = $Sounds/CamChangeSound
#endregion

func _on_door_button_left_toggled(toggled_on: bool) -> void:
	_door_active_l.visible = toggled_on
	_both_active_l.visible = _light_active_l.visible && toggled_on
	if toggled_on:
		_door_left.play("close")
	else:
		_door_left.play_backwards("close")
	_door_close_sound.play()
func _on_light_button_left_toggled(toggled_on: bool) -> void:
	_light_active_l.visible = toggled_on
	_both_active_l.visible = _door_active_l.visible && toggled_on
	_lights_sound_l.playing = toggled_on
	_office_light_left.visible = toggled_on


func _on_door_button_right_toggled(toggled_on: bool) -> void:
	_door_active_r.visible = toggled_on
	_both_active_r.visible = _light_active_r.visible && toggled_on
	if toggled_on:
		_door_right.play("close")
	else:
		_door_right.play_backwards("close")
	_door_close_sound.play()
func _on_light_button_right_toggled(toggled_on: bool) -> void:
	_light_active_r.visible = toggled_on
	_both_active_r.visible = _door_active_r.visible && toggled_on
	_lights_sound_r.playing = toggled_on
	_office_light_right.visible = toggled_on

func _on_boop_button_pressed() -> void:
	_boop_sound.play()

func _on_camera_trigger_mouse_entered() -> void:
	if not _camera_trigger.visible: return
	_in_cams = !_in_cams
	_cam_flip_timer.start()
	_camera_trigger.visible = false
	if _in_cams:
		_camera_flip.play("camera_flip")
		_cam_open_sound.play()
		_cam_loop_sound.play()
	else:
		_camera_flip.play_backwards("camera_flip")
		_cam_close_sound.play()
		_cam_open_sound.stop()
		_cam_loop_sound.stop()

func _on_cam_trigger_cooldown_timer_timeout() -> void:
	_camera_trigger.visible = true
	_camera_view.play_switch_effect()
	_cams_view.visible = _in_cams

func _on_cam_change_pressed() -> void:
	_cam_change_sound.play()
	var cam_name: String = _first_cam_button.button_group.get_pressed_button().name
	match cam_name:
		"cam1a":
			var CAM_1A_ALL := load("uid://c8qihgihwwqee")
			_camera_view.change_state(CAM_1A_ALL)
		"cam1b":
			var CAM_1B_NONE := load("uid://cxfk5hw6daojq")
			_camera_view.change_state(CAM_1B_NONE)
		_:
			return
#endregion
