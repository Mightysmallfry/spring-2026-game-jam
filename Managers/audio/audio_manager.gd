extends Node
class_name AudioManager

var musicPlayerCount : int = 2
var currentMusicPlayer : int = 0

var musicPlayers : Array [AudioStreamPlayer] = []
var musicBus : String = "Music"
var musicFadeDuration : float = 0.5;

# Let 16 simultaneous effects happen at once
var sfxPlayerCount : int = 16
var sfxPlayers : Array [AudioStreamPlayer] = []
var sfxBus : String = "SFX"
var currentSfxPlayer : int = 0



# Different from audio bus volume
var normalVolume_db : float = 0.0
var defaultMusicVolume_db : float = -10.0
var quietVolume_db : float = -40.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.audio_manager = self
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Adds two audio stream players so we can do transitions
	# Including having two tracks of music playing
	for i in musicPlayerCount:
		var newPlayer = AudioStreamPlayer.new()
		add_child(newPlayer)
		newPlayer.volume_db = quietVolume_db
		newPlayer.bus = musicBus
		musicPlayers.append(newPlayer)
		
	for i in sfxPlayerCount:
		var newPlayer = AudioStreamPlayer.new();
		add_child(newPlayer)
		newPlayer.bus = sfxBus
		sfxPlayers.append(newPlayer)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_music(audioStream : AudioStream, duration : float = musicFadeDuration) -> void:
	if audioStream == musicPlayers[currentMusicPlayer].stream:
		return
	
	var oldPlayer : AudioStreamPlayer = musicPlayers[currentMusicPlayer]
	
	currentMusicPlayer = (currentMusicPlayer + 1) % musicPlayerCount
	
	var currentPlayer : AudioStreamPlayer = musicPlayers[currentMusicPlayer]
	currentPlayer.stream = audioStream
	fade_in(currentPlayer, duration)
	fade_out(oldPlayer)


func pause_music() -> void:
	for player in musicPlayers:
		fade_out(player)


func fade_in(player : AudioStreamPlayer, fadeDuration : float = musicFadeDuration) -> void:
	player.play()
	var tween : Tween = create_tween()
	tween.tween_property(player, "volume_db", defaultMusicVolume_db, fadeDuration)
	
func fade_out(player : AudioStreamPlayer = musicPlayers[currentMusicPlayer]) -> void:
	var tween : Tween = create_tween()
	tween.tween_property(player, "volume_db", quietVolume_db, musicFadeDuration)
	await tween.finished
	player.stop()

func play_sfx(audioStream : AudioStream) -> void:
	
	currentSfxPlayer = (currentSfxPlayer + 1) % sfxPlayerCount
	var currentSfx : AudioStreamPlayer = sfxPlayers[currentSfxPlayer]
	currentSfx.stream = audioStream
	currentSfx.play()
	
