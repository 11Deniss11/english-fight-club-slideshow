extends AnimatedSprite2D

@export var speed = 800
@export var Target: Node2D

var reached_position = true

var stopped = false

var soldiers_moving = false
var soldiers_moving_2 = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	
	if velocity_x != 0:
		animation = "drive"
		play()
	else:
		stop()
	
	position.x += velocity_x * delta * speed

func start_stop_timer():
	if $stop_timer.is_stopped():
		$stop_timer.start()
		print("Timer started")
		stopped = true

func start_soldier_move_timer():
	if $soldier_move_timer.is_stopped():
		$soldier_move_timer.start()
		print("Soldier move timer started")
		soldiers_moving = true

func start_soldier_move_timer_2():
	if $soldier_move_timer_2.is_stopped():
		$soldier_move_timer_2.start()
		print("Soldier move timer 2 started")
		soldiers_moving_2 = true

func _on_stop_timer_timeout() -> void:
	# $stop_timer.stop()
	stopped = false


func _on_soldier_move_timer_timeout() -> void:
	soldiers_moving = false

func _on_soldier_move_timer_2_timeout() -> void:
	soldiers_moving_2 = false
