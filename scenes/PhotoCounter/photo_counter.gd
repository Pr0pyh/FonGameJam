class_name PhotoCounter
extends Node

@onready var counter_display: Label = $CanvasLayer/CounterDisplay

var counter = 0

func add_scanned_photo():
	counter += 1
	counter_display.text = "Photos taken: " + str(counter)
	print(counter)
