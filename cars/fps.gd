extends Label

var frames_per_second = 0
var time_accumulated = 0.0
var frame_count = 0

func _process(delta):
	time_accumulated += delta
	frame_count += 1
	if time_accumulated >= 0.5:
		frames_per_second = frame_count * 2
		frame_count = 0
		time_accumulated = 0.0
	text = str(frames_per_second) + " FPS"
