extends Control
class_name PlayerMainHud
@onready var log_lines = [$background/log_line1, $background/log_line2, $background/log_line3]
@onready var log_line_timers = [$log_line_timer1, $log_line_timer2, $log_line_timer3]
@onready var vitality_timer = $vitality_timer


func screen_flash_start():
	get_tree().paused = true
	$screen_flash.visible = true
	$flash_timer.start()

func _on_flash_timer_timeout():
	get_tree().paused = false
	$screen_flash.visible = false

const max_log_alpha = 255
const min_log_alpha = 80
const log_fadeout_time = 1
const log_fadeout_time_step = 0.08
const log_fadeout_alpha_step:int = (max_log_alpha - min_log_alpha) * (log_fadeout_time_step / log_fadeout_time)

@onready var dash_indicator = $background/dash_status
const dash_indicator_symbols_amount = 10

@onready var health_indicator = $background/health_status

func update_log(new_line:String):
	log_lines[2].text = log_lines[1].text
	log_lines[2].label_settings.font_color.a8 = log_lines[1].label_settings.font_color.a8
	log_lines[1].text = log_lines[0].text
	log_lines[1].label_settings.font_color.a8 = log_lines[0].label_settings.font_color.a8
	log_lines[0].text = new_line
	log_lines[0].label_settings.font_color.a8 = max_log_alpha
	for timer in log_line_timers:
		timer.start(log_fadeout_time_step)

func update_dash_indicator(dash_percentage):
	if (dash_percentage < 1):
		dash_indicator.label_settings.font_color = Color.RED
		var dash_text = "["
		var filled_symbols = int(dash_percentage * dash_indicator_symbols_amount)
		for i in filled_symbols:
			dash_text += "#"
		for i in dash_indicator_symbols_amount - filled_symbols:
			dash_text += "."
		dash_text += "]"
		dash_indicator.text = dash_text
	else:
		dash_indicator.label_settings.font_color = Color.GREEN
		dash_indicator.text = "ready"

func update_vitality(health, max_health):
	var health_text = str(int(health)) + "/" + str(int(max_health))
	health_indicator.text = health_text
	health_indicator.label_settings.font_color = Color.RED
	vitality_timer.start()

func show_death():
	$death_screen.visible = true

func hide_death():
	$death_screen.visible = false

func _on_log_line_timer_1_timeout():
	var cur_alpha = log_lines[0].label_settings.font_color.a8
	if cur_alpha > min_log_alpha:
		cur_alpha -= log_fadeout_alpha_step
		log_lines[0].label_settings.font_color.a8 = max(min_log_alpha, cur_alpha)
		log_line_timers[0].start(log_fadeout_time_step)

func _on_log_line_timer_2_timeout():
	var cur_alpha = log_lines[1].label_settings.font_color.a8
	if cur_alpha > min_log_alpha:
		cur_alpha -= log_fadeout_alpha_step
		log_lines[1].label_settings.font_color.a8 = max(min_log_alpha, cur_alpha)
		log_line_timers[1].start(log_fadeout_time_step)

func _on_log_line_timer_3_timeout():
	var cur_alpha = log_lines[2].label_settings.font_color.a8
	if cur_alpha > min_log_alpha:
		cur_alpha -= log_fadeout_alpha_step
		log_lines[2].label_settings.font_color.a8 = max(min_log_alpha, cur_alpha)
		log_line_timers[2].start(log_fadeout_time_step)

func _on_vitality_timer_timeout() -> void:
	health_indicator.label_settings.font_color = Color.GREEN

func _on_logger_player_log(msg: String) -> void:
	update_log(msg)
