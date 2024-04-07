extends Node2D
var screenSize
var padSize
var direction = Vector2(1.0, 0.0)
const INITIAL_BALL_SPEED = 80
var ball_speed = INITIAL_BALL_SPEED
const PAD_SPEED = 150
var leftScore = 0
var rightScore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	padSize = get_node("LeftP").get_texture().get_size()
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ball_pos = get_node("Ball").get_position()
	var left_rect = Rect2( get_node("LeftP").get_position() - padSize*0.5, padSize )
	var right_rect = Rect2( get_node("RightP").get_position() - padSize*0.5, padSize )
	ball_pos += direction * ball_speed * delta
	
	#Ball settings
	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screenSize.y and direction.y > 0)):
		direction.y = -direction.y
	
	
	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
		
		#change the Bal color
		var ball = get_node("Ball")
		var new_color = Color(randf(), randf(), randf(), 1)
		ball.set_modulate(new_color)  # give Ball a random color
		
	if (ball_pos.x > screenSize.x):
		ball_pos = screenSize * 0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
		leftScore += 1
		print("Blue scored:", leftScore)
		$BlueScore.text = str(leftScore)
	
	if (ball_pos.x < 0):
		ball_pos = screenSize * 0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(1, 0)
		rightScore += 1
		print("Purpel scored:", rightScore)
		$PinkScore.text = str(rightScore)
		
	if(ball_pos.x < 0 or ball_pos.x > screenSize.x):
		ball_pos = screenSize*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1,0)
		
	get_node("Ball").position = ball_pos
		
	# Move left pad
	var left_pos = get_node("LeftP").get_position()
	if(left_pos.y > 0 and Input.is_action_pressed("ui_up")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screenSize.y and Input.is_action_pressed("ui_down")):
		left_pos.y += PAD_SPEED * delta
		
	get_node("LeftP").position = left_pos

	# Move right pad
	var right_pos = get_node("RightP").get_position()
	if (right_pos.y > 0 and Input.is_action_pressed("ui_page_up")):
		right_pos.y += -PAD_SPEED * delta
	if(right_pos.y < screenSize.y and Input.is_action_pressed("ui_page_down")):
		right_pos.y += PAD_SPEED * delta
		
	get_node("RightP").position = right_pos

