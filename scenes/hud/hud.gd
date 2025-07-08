extends CanvasLayer

##################################################
var mode_label_node: Label

##################################################
func _ready() -> void:
	mode_label_node = $MarginContainer/ModeLabel

##################################################
func _process(delta: float) -> void:
	if RM.is_rewinding:
		mode_label_node.text = "Mode: Rewind"
	else:
		mode_label_node.text = "Mode: Normal"
