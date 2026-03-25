class_name PhotoCounter
extends Label


var counter: int = 0


func _ready():
	reset_counter()


func add_scanned_photo():
	counter += 1
	text = "Photos taken: " + str(counter)


func reset_counter():
	counter = 0
	text = "Photos taken: " + str(counter)
