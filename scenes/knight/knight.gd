extends CharacterBody2D

##################################################
const AFTER_IMAGE_SCENE: PackedScene = \
preload("res://scenes/after_image/after_image.tscn")
const MOVING_SPEED = 200.0
const JUMP_VELOCITY = -400.0
const MAX_HISTORY_SIZE: float = 300

@onready var after_images_node = get_tree().root.get_node("Main/AfterImages")

var animated_sprite_node: AnimatedSprite2D

var state_history: Array = []	# 되감기를 위한 상태 값 저장 변수

##################################################
func _ready() -> void:
	animated_sprite_node = $AnimatedSprite2D
	
	RM.register(self)	# Rewind Manager에 등록

##################################################
func _exit_tree() -> void:
	RM.unregister(self)	# Rewind Manager에서 등록 취소

##################################################
func _physics_process(delta: float) -> void:
	if RM.is_rewinding:	# 되감기 중이면 아래 키 입력 모두 막음
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_node.play("roll")

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		SM.jump_audio_play()

	var x_direction: float = Input.get_axis("ui_left", "ui_right")
	if x_direction:
		velocity.x = x_direction * MOVING_SPEED
		if is_on_floor():
			animated_sprite_node.play("run")
		if x_direction > 0:
			animated_sprite_node.flip_h = false
		elif x_direction < 0:
			animated_sprite_node.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, MOVING_SPEED)
		if is_on_floor():
			animated_sprite_node.play("idle")

	move_and_slide()

##################################################
func record_state() -> void:	# 상태 값 저장 함수
	state_history.push_front({	# 위치, 속도, 애니메이션, 방향을 저장
		"position": global_position,
		"velocity": velocity,
		"animation": animated_sprite_node.animation,
		"flip_h": animated_sprite_node.flip_h
		})
	
	if state_history.size() > MAX_HISTORY_SIZE:	# 저장 최대 개수를 제한
		state_history.pop_back()

##################################################
func rewind_state() -> void:	# 되감기 기록 재생 함수
	if state_history.is_empty():	# 저장 기록이 없으면 return
		return
	
	var state = state_history.pop_front()	# 최근 기록부터 불러와서 각 값에 설정
	global_position = state["position"]
	velocity = state["velocity"]
	animated_sprite_node.play(state["animation"])
	animated_sprite_node.flip_h = state["flip_h"]
	SM.rewind_audio_play()	# 되감기 효과음 재생
	
	_spawn_after_image()	# 잔상 추가

##################################################
func _spawn_after_image() -> void:
	var after_image_instance: Node2D = AFTER_IMAGE_SCENE.instantiate()
	after_image_instance.global_position = global_position
	
	var sprite = after_image_instance.get_node("Sprite2D")
	sprite.texture = \
	animated_sprite_node.sprite_frames.get_frame_texture(animated_sprite_node.animation, animated_sprite_node.frame)
	sprite.flip_h = animated_sprite_node.flip_h
	
	after_images_node.add_child(after_image_instance)
