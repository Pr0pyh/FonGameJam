class_name ExplodingNokia
extends Node3D


@export var parent: Node3D
@export var smoke_particles: GPUParticles3D


var gravity: float = 10.0
var linear_velocities: Array[Vector3]
var angular_velocities: Array[Vector3]


func _ready():
	smoke_particles.emitting = true
	var i = 0
	for child in parent.get_children():
		linear_velocities.append(Vector3(randf()-0.5,randf(),randf()-0.5).normalized()*8.0)
		angular_velocities.append(Vector3(randf()-0.5,randf()-0.5,randf()-0.5).normalized()*300.0)
		var visible_on_screen := VisibleOnScreenNotifier3D.new()
		visible_on_screen.aabb = AABB()
		child.add_child(visible_on_screen)
		visible_on_screen.position = Vector3()
		i += 1


func _process(delta: float) -> void:
	var i = 0
	for child in parent.get_children():
		linear_velocities[i].y -= gravity * delta
		child.global_position += linear_velocities[i]*delta
		child.rotation_degrees += angular_velocities[i]*delta
		i += 1
		
