extends KinematicBody2D

export var speed = 500

const p_container = preload("res://Game_Classic/Player/PContainer.tres")
var world = "res://Game_Classic/Game_Main/MainScene.tscn"
var direction = Vector2(0.5, 1)
var is_throwing = false

onready var is_visible = get_node("BallVisible")
onready var audio = get_node("AudioStreamPlayer2D")
signal ball_hit(brick)
	
func _physics_process(delta):
	if Input.is_action_just_pressed("throw"):
		is_throwing = true
	
	if not is_throwing:
		return
	
	is_game_over()
	
	direction = direction.normalized()
	var velocity = speed * direction * delta
	var collision = move_and_collide(velocity)
	
	if collision != null:
		if collision.collider == p_container.player:
			direction = direction.bounce(collision.normal)
			play("res://Game_Classic/Sound/paddle_hit.wav")	
			#direction.x = get_bounce_directionx(collision)

		else:
			print(collision.collider.get_meta("brick"))
			if collision.collider.get_meta("brick"):
				play("res://Game_Classic/Sound/brick_hit.wav")
				var brick = collision.collider
				emit_signal("ball_hit", brick)
				brick.decrease_points()
			else:
				play("res://Game_Classic/Sound/wall_hit.wav")
			direction = direction.bounce(collision.normal)
		
#func get_bounce_directionx(collision: KinematicCollision2D):
	#var relativex = collision.position.x - p_container.player.global_position.x
	#var percent = relativex / p_container.player_width
	#return (percent - 0.5) * 2
func play(path):
	var audio = AudioStreamPlayer.new()
	get_tree().get_root().add_child(audio)
	var sound = load(path)
	audio.set_stream(sound)
	audio.play()
	
func is_game_over():
	if not is_visible.is_on_screen():
		print("Game over")
		get_tree().change_scene(world)
		
