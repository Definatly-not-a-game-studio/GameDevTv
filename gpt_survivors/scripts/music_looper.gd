class_name looped_music
extends AudioStreamPlayer


func _ready():
	#when the audio is finished, it will play again
	finished.connect(loop)
	loop()



func loop():
	play()


