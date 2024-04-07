extends Gadget


@onready var area := $"3D/Area3D" as Area3D
@onready var area_visual := $"3D/Area3D/AreaVisual" as MeshInstance3D

var audio_player
var inside_area := false


func _ready() -> void:
	super._ready()
	change_property(&"ThreeD", false)


func input(_delta: float) -> void:
	if is_input_pulse(0):
		audio_player.play()


func change_property(property: StringName, value: Variant) -> void:
	match property:
		&"Sound":
			if value.begins_with("res://"):
				audio_player.stream = load(value)
			else:
				audio_player.stream = AudioStreamOggVorbis.load_from_file(value)
		&"Range":
			area.scale = Vector3.ONE * value
		&"Volume":
			audio_player.volume_db = linear_to_db(value)
		&"Loop":
			if value:
				audio_player.finished.connect(func() -> void:
					var data: Variant = get_input_data(0)
					if data == null and inside_area or data == true:
						audio_player.play()
				)
			else:
				audio_player.finished.disconnect(audio_player.play)
		&"ThreeD":
			var stream: AudioStream
			var loop := false
			var volume := 0.0

			if is_instance_valid(audio_player):
				audio_player.queue_free()

				# Old audio player properties
				stream = audio_player.stream
				loop = audio_player.finished.is_connected(audio_player.play)
				volume = audio_player.volume_db

			if value:
				audio_player = AudioStreamPlayer3D.new()
			else:
				audio_player = AudioStreamPlayer.new()

			# Set same properties for new audio player
			audio_player.stream = stream
			if loop:
				change_property(&"Loop", loop)
			audio_player.volume_db = volume

			audio_player.finished.connect(func() -> void:
				output(0, true, true)
			)

			area.add_child(audio_player)


func _on_area_3d_body_entered(_body: Node3D) -> void:
	# TODO: Add different modes
	inside_area = true
	if get_input_data(0) == null:
		audio_player.play()


func _on_area_3d_body_exited(_body: Node3D) -> void:
	inside_area = false
