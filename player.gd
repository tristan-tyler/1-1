extends CharacterBody2D

var speed = 300
var speed_max = 200
var jump_speed = 14000
var jump = true
var jump_start = position
var jump_max = 80
var gravity = 800
var friction = 0.1

func _physics_process(delta: float) -> void:
	var friction_offset = velocity.x * -friction
	velocity.x += friction_offset
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT * delta * speed
		velocity += Vector2.LEFT * abs(friction_offset) # offset friction during movement
		if velocity.x < (Vector2.LEFT * speed_max).x:
			velocity.x = (Vector2.LEFT * speed_max).x
	elif Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT * delta * speed
		velocity += Vector2.RIGHT * abs(friction_offset) # offset friction during movement
		if velocity.x > (Vector2.RIGHT * speed_max).x:
			velocity.x = (Vector2.RIGHT * speed_max).x

	if Input.is_action_pressed("ui_up") and jump:
		if jump_start.y - jump_max > position.y:
			jump = false
		else:
			velocity.y = (Vector2.UP * delta * jump_speed).y
	else:
		jump = false

	if move_and_slide():
		var collision = get_last_slide_collision()
		var collider = collision.get_collider()
		if is_on_ceiling():
			print("ceiling")
			jump = false
			if collider.has_method("headbutt"):
				collider.call("headbutt", collision.get_position())
		if is_on_floor():
			print("floor")
			jump = true
			jump_start = position
		if is_on_wall():
			print("wall")
	else:
		print("air")
	velocity += Vector2.DOWN * delta * gravity

func _process(delta: float) -> void:
	var input_animation = "big_idle"
	if Input.is_action_just_pressed("ui_left"):
		$"AnimatedSprite2D".flip_h = false
	elif Input.is_action_just_pressed("ui_right"):
		$"AnimatedSprite2D".flip_h = true
	if not is_on_floor():
		input_animation = "big_jump"
	elif Input.is_action_pressed("ui_down"):
		input_animation = "crouch"
	elif Input.is_action_pressed("ui_right") and 0.0 > velocity.x:
		input_animation = "big_slide"
	elif Input.is_action_pressed("ui_left") and 0.0 < velocity.x:
		input_animation = "big_slide"
	elif abs(velocity.x) > speed * friction:
		input_animation = "big_run"

	$"AnimatedSprite2D".play(input_animation)
