extends Node

##################################################
const RECORD_INTERVAL: float = 0.1	# 녹화 주기 변수
const REWIND_INTERVAL: float = 0.05	# 되감기 재생 주기 변수

var rewind_targets: Array = []		# 되감기 할 오브젝트들 저장 변수
var is_rewinding: bool = false		# 되감기 중인지 여부 변수
var record_timer: float = 0.0		# 녹화 타이머 변수
var rewind_timer: float = 0			# 되감기 재생 타이머 변수

##################################################
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):		# 되감기 시작
		is_rewinding = true
	elif Input.is_action_just_released("ui_cancel"):	# 되감기 종료
		is_rewinding = false
	
	if is_rewinding:	# 되감기 중이면
		rewind_timer += delta	# 타이머 재생
		if rewind_timer >= REWIND_INTERVAL:	# 타이머가 일정 시간 이상이면
			rewind_timer = 0.0	# 타이머 초기화
			for target in rewind_targets:	# 되감기 할 오브젝트들을 순회하며
				if target.has_method("rewind_state"):	# 해당 함수가 있으면
					target.rewind_state()	# 해당 함수 실행
	else:			# 되감기 상태가 아니라면 (녹화 상태)
		record_timer += delta	# 타이머 재생
		if record_timer >= RECORD_INTERVAL:	# 타이머가 일정 시간 이상이면
			record_timer = 0.0	# 타이머 초기화
			for target in rewind_targets:	# 되감기 할 오브젝트들을 순회하며
				if target.has_method("record_state"):	# 해당 함수가 있으면
					target.record_state()	# 해당 함수 실행

##################################################
func register(target: Node2D) -> void:	# 되감기 할 오브젝트 변수에 등록하는 함수
	if not rewind_targets.has(target):
		rewind_targets.append(target)

##################################################
func unregister(target: Node2D) -> void:	# 되감기 할 오브젝트 변수에서 등록 해제하는 함수
	rewind_targets.erase(target)
