extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var floor_height = 850
@export var Target: Node2D

var is_knocked_back = false;
# @export var knocked_back_timer = Timer.new()

var is_on_chair = false

var picked_up_water_gun = false

var crying = false

var cried_once = false

var holding_grenade = false

var done_throwing_grenade = false

var reached_position = true

var throwing_grenade = false

var tolerance = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity_x = 0;
	if picked_up_water_gun:
		tolerance = 10
	else:
		tolerance = 5

	if abs(Target.position.x - position.x) > tolerance:
		reached_position = false
		if Target.position.x > position.x:
			velocity_x = 1
		if Target.position.x < position.x:
			velocity_x = -1
	else:
		reached_position = true
	
	if velocity_x != 0 and not is_knocked_back:
		velocity_x = velocity_x * speed
		if picked_up_water_gun:
			$AnimatedSprite2D.animation = "water"
		elif is_on_chair:
			$AnimatedSprite2D.animation = "chair"
		else:
			$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity_x < 0
	elif not is_knocked_back:
		velocity_x = 0
		if throwing_grenade:
			$AnimatedSprite2D.animation = "throw"
			if $AnimatedSprite2D.frame == 5:
				done_throwing_grenade = true
				throwing_grenade = false
				holding_grenade = false
		elif holding_grenade:
			$AnimatedSprite2D.animation = "grenadeIdle"
		elif crying:
			$AnimatedSprite2D.animation = "cry"
		elif picked_up_water_gun:
			$AnimatedSprite2D.animation = "water"
			$AnimatedSprite2D.flip_h = true
		elif is_on_chair:
			$AnimatedSprite2D.animation = "chair"
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.flip_h = true
	else:
		velocity_x = 1.5 * speed
		$AnimatedSprite2D.animation = "jump"
	
	if position.y < floor_height and not is_knocked_back:
		position.y += 2 * speed * delta
	elif is_knocked_back:
		position.y -= 1 * speed * delta
	else:
		position.y = floor_height
		
	position.x += velocity_x * delta

	$AnimatedSprite2D.play()

	if $AnimatedSprite2D.animation == "cry" and $AnimatedSprite2D.frame == 6:
		crying = false;

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func knockback():
	is_knocked_back = true
	$KnockedBackTimer.start()

func get_on_chair():
	is_on_chair = true

func get_off_chair():
	is_on_chair = false

func pick_up_water_gun():
	picked_up_water_gun = true
	reached_position = not abs(Target.position.x - position.x) > 10

func drop_water_gun():
	picked_up_water_gun = false

func cry():
	crying = true
	cried_once = true

func throw_grenade():
	if not done_throwing_grenade:
		throwing_grenade = true

# Called when the knocked back timer times out.
func _on_knocked_back_timeout() -> void:
	is_knocked_back = false
	$KnockedBackTimer.stop()
