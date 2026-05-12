extends Control

@onready var chat_bot_response = $PanelContainer/MarginContainer/VBoxContainer/ChatResponse
@onready var user_question = $PanelContainer/MarginContainer/VBoxContainer/LineEdit
@onready var ai = $NobodyWhoChat

func _send_text_to_ai():
	user_question.editable = false
	chat_bot_response.text = ""
	ai.say(user_question.text)

#func _input(event: InputEvent) -> void:
#	if (event.is_action("ui_text_newline")):
#		_send_text_to_ai()
		


func _on_nobody_who_chat_response_updated(new_token: String) -> void:
	chat_bot_response.text += new_token
	#if new_token == "" :
	#	_on_nobody_who_chat_response_finished(chat_bot_response.text)
	#print("go")

func _on_nobody_who_chat_response_finished(_response: String) -> void:
	user_question.editable = true
	user_question.text = ""

func _on_line_edit_text_submitted(_new_text: String) -> void:
	_send_text_to_ai()
