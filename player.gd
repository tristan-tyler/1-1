extends CharacterBody2D

var speed = 1000
var jump_speed = 30000
var can_jump = true
var jump_max = 200
var gravity = 1200
var friction = 0.035

func _physics_process(delta: float) -> void:		
	velocity.x += velocity.x * -friction
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT * delta * speed
	elif Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT * delta * speed
	if Input.is_action_pressed("ui_up") and can_jump:
		if position.y < -jump_max:
			can_jump = false
		else:
			velocity.y = (Vector2.UP * delta * jump_speed).y
	else:
		can_jump = false

	if move_and_slide():
		var collision = get_last_slide_collision()
		velocity += -collision.get_remainder()
		if is_on_floor():
			can_jump = true
	else:
		velocity += Vector2.DOWN * delta * gravity
