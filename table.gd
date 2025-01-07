extends Sprite2D

@export var speed = 400
@export var Target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity_y = 0;
	if abs(Target.position.y - position.y) > 5:
		if Target.position.y > position.y:
			velocity_y = 1
		if Target.position.y < position.y:
			velocity_y = -1
	
	position.y += velocity_y * delta * speed
