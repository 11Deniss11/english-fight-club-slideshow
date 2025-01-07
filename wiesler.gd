extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var floor_height = 850
@export var Target: Node2D
var is_knocked_back = false;

var reached_position = true

var done_crying = false
var is_on_chair = false

var letter_is_out = false

var auto_anim_active = true

var is_dancing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity_x = 0;
	if abs(Target.position.x - position.x) > 5:
		reached_position = false
		if Target.position.x > position.x:
			velocity_x = 1
		if Target.position.x < position.x:
			velocity_x = -1
	else:
		reached_position = true

	if auto_anim_active:
		if velocity_x != 0 and not is_knocked_back:
			velocity_x = velocity_x * speed
			if letter_is_out:
				$AnimatedSprite2D.animation = "draftWalk"
			elif is_on_chair:
				$AnimatedSprite2D.animation = "chair"
			else:
				$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_h = velocity_x < 0
		elif not is_knocked_back:
			velocity_x = 0
			if is_dancing:
				$AnimatedSprite2D.animation = "dance"
				if $AnimatedSprite2D.frame == 5:
					$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
					$AnimatedSprite2D.frame = 0
			elif letter_is_out:
				$AnimatedSprite2D.animation = "draftIdle"
			elif is_on_chair:
				$AnimatedSprite2D.animation = "chair"
			else:
				$AnimatedSprite2D.animation = "idle"
				$AnimatedSprite2D.flip_h = false;
		else:
			velocity_x = -1.5 * speed
			$AnimatedSprite2D.animation = "jump"
	
	if position.y < floor_height and not is_knocked_back:
		position.y += 2 * speed * delta
	elif is_knocked_back:
		position.y -= 1 * speed * delta
	else:
		position.y = floor_height
		
	position.x += velocity_x * delta

	$AnimatedSprite2D.play()

	if $AnimatedSprite2D.animation == "headphonesCry" and $AnimatedSprite2D.frame == 5:
		done_crying = true;

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func knockback():
	is_knocked_back = true
	$KnockedBackTimer.start()

func headphones():
	$AnimatedSprite2D.animation = "headphones"

func cry():
	$AnimatedSprite2D.animation = "headphonesCry"

func get_on_chair():
	is_on_chair = true

func get_off_chair():
	is_on_chair = false

func letter_out():
	letter_is_out = true
	reached_position = not abs(Target.position.x - position.x) > 5

func letter_in():
	letter_is_out = false

# Called when the knocked back timer times out.
func _on_knocked_back_timeout() -> void:
	is_knocked_back = false
	$KnockedBackTimer.stop()