extends Control

@onready var log_lines = [$background/log_line1, $background/log_line2, $background/log_line3]
@onready var log_line_timers = [$log_line_timer1, $log_line_timer2, $log_line_timer3]
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

func damage_log(who:String, damage:int):
	var new_line = who + " was damaged for " + str(damage)
	update_log(new_line)

func kill_log(who:String):
	var new_line = who + " was killed"
	update_log(new_line)

func update_log(new_line:String):
	log_lines[2].text = log_lines[1].text
	log_lines[2].label_settings.font_color.a8 = log_lines[1].label_settings.font_color.a8
	log_lines[1].text = log_lines[0].text
	log_lines[1].label_settings.font_color.a8 = log_lines[0].label_settings.font_color.a8
	log_lines[0].text = new_line
	log_lines[0].label_settings.font_color.a8 = max_log_alpha
	for timer in log_line_timers:
		timer.start(log_fadeout_time_step)


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
