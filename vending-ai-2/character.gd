extends Node2D

var is_talking = false
var is_error_playing = false

func _ready():
	randomize()
	$AnimatedSprite2D.play("idle")
	blink_loop()

func blink_loop():
	while true:
		
		# error中は瞬きしない（割り込み防止）
		if is_error_playing:
			await get_tree().create_timer(0.1).timeout
			continue
		
		# ランダム待ち
		await get_tree().create_timer(randf_range(2, 5)).timeout

		# 待ってる間にerrorが来たら瞬きしない
		if is_error_playing:
			continue

		# 1回目の瞬き
		$AnimatedSprite2D.play("blink")
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.play("idle")

		# 20% の確率で2連続瞬き
		if randf() < 0.2:
			await get_tree().create_timer(randf_range(0.05, 0.2)).timeout
			$AnimatedSprite2D.play("blink")
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.play("idle")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if not is_talking and not is_error_playing:
			play_voice_and_talk()
		
	if event.is_action_pressed("ui_cancel"):
		if not is_error_playing:
			play_error_animation()


func play_voice_and_talk():
	var audio = $irassyaimase
	# 音声の長さ（秒）
	var duration = audio.stream.get_length()
	# 再生開始
	audio.play()
	# 口パク開始
	is_talking = true
	var timer = get_tree().create_timer(duration)
	while timer.time_left > 0:
		$AnimatedSprite2D.play("talk")
		await get_tree().create_timer(randf_range(0.05, 0.15)).timeout
		$AnimatedSprite2D.play("idle")
		await get_tree().create_timer(randf_range(0.05, 0.15)).timeout
	# 終了処理
	$AnimatedSprite2D.play("idle")
	is_talking = false

func play_error_animation():
	is_error_playing = true
	var audio = $soldout
	# 音声の長さ（秒）
	var duration = audio.stream.get_length()
	# 再生開始
	audio.play()
	# 口パク開始
	is_talking = true
	var timer = get_tree().create_timer(duration)
	while timer.time_left > 0:
		$AnimatedSprite2D.play("error")
		await get_tree().create_timer(randf_range(0.05, 0.15)).timeout
		$AnimatedSprite2D.play("error2")
		await get_tree().create_timer(randf_range(0.05, 0.15)).timeout
		
	$AnimatedSprite2D.play("idle")
	is_error_playing = false
