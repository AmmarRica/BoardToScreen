@tool
extends Node2D

@export var frequency: float = 440.0  # Frequency in Hz (A4)
@export var duration: float = 1.0  # Duration in seconds
@export var generate_sound: bool = false  # Trigger sound generation from the editor

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D  # Reference to AudioStreamPlayer2D node
var generator: AudioStreamGenerator = null  # Initialize the generator variable

func _ready():
	if Engine.is_editor_hint():
		return  # Skip initialization in the editor

	if generator == null:
		generator = AudioStreamGenerator.new()  # Initialize the generator
		generator.mix_rate = 44100  # Set the audio sample rate to 44.1kHz (standard)
		audio_player.stream = generator  # Assign the generated stream to the AudioStreamPlayer2D

# Handle the property change directly when you modify `generate_sound` in the inspector
func _set(property, value):
	if property == "generate_sound" and value == true:
		generate_audio()
		generate_sound = false  # Reset the flag to avoid continuous generation

# Function to generate and play the audio
func generate_audio():
	if Engine.is_editor_hint():  # Check if we are in editor mode
		print("Generating audio in the editor.")
		if generator == null:
			print("Error: AudioStreamGenerator is null!")
			return
		play_sine_wave(frequency, duration)  # Generate and play sine wave
		audio_player.play()  # Play audio immediately after generation

# Function to generate a sine wave and play it through the AudioStreamPlayer2D
func play_sine_wave(freq: float, time: float):
	var mix_rate = generator.mix_rate
	var num_samples = int(mix_rate * time)  # Total number of samples to generate
	var buffer = PackedFloat32Array()  # Create a buffer for audio data

	# Generate the sine wave samples and append to the buffer
	for i in range(num_samples):
		var sample = sin(TAU * freq * i / mix_rate)  # Generate sine wave sample at the given frequency
		buffer.append(sample)

	# Push the generated buffer to the playback
	var playback = generator.playback  # Access the AudioStreamGeneratorPlayback
	playback.push_buffer(buffer)  # Push the buffer to the playback

	# Ensure the audio player is linked to the stream and playing
	audio_player.stream = generator  # Reassign the stream to the AudioStreamPlayer2D
