extends KinematicBody2D

var speed = 120
const gravitation = 0.35
var gravity = gravitation
var jump = 800
var jumpLine = 0
var fly = false
const FLOOR = Vector2(0,-1)
var velocity = Vector2(0,0)
var space = false
var duble_jump = false

func _physics_process(delta):
	if is_on_floor():
		gravity = 0.5
		jumpLine = 0
#		$CircleAnimation.visible = false
		duble_jump = false
	if !fly:
		if is_on_wall():
			gravity += gravitation/20
		else:
			gravity += gravitation
		velocity.y = int(gravity)
		velocity.y *= 40
	$Label.text = str(velocity) + '  =>  '
	velocity = move_and_slide(velocity, FLOOR)
	$Label.text += str(velocity) + "\n"
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
		if !$Sprite.flip_h:
			$Sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 1
		if $Sprite.flip_h:
			$Sprite.flip_h = false
	else:
		velocity.x = 0
	#velocity = move_and_slide(velocity, FLOOR)
	$Label.text += str(is_on_floor()) + "\n"
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or !duble_jump):
		fly = true
		gravity = 0.5
		jumpLine = 0
		if !is_on_floor():
			duble_jump = true
	if space:
		if fly and jumpLine<jump:
			#jumpLine = motion_jump(jump, jumpLine)
			#print(velocity.y, '   ', int(jumpLine))
			jumpLine += int(jump*gravitation)
			velocity.y = -int(jump*gravitation)#-(int(jumpLine) + velocity.y)
			#print(velocity.y)
			#print(global_position.y)
			#jumpLine += (jump - jumpLine) / 5 + (jump - jumpLine) % 5
			
		elif fly:
			fly = false
#			$CircleAnimation.visible = true
#			print("Let fall")
			#jumpLine = 0
		space = false
	else: space = true
	
	velocity.x *= speed
	velocity = move_and_slide(velocity, FLOOR)
	animates_player(velocity)

func motion_jump(max_h, last_h):
	if !is_on_floor():
		last_h += max_h/3^int(last_h/6)#last_h - (max_h + last_h) / 5# + (max_h - last_h) % 5
	else:
		last_h += max_h/6
	#print(last_h)
	return last_h

func animates_player(direction: Vector2):
	$Label.text += str(fly) + "\n"
	if duble_jump:
			$Sprite.play("D_Jump")
	else:
		if direction.x != 0:
			$Sprite.play("Run")
		elif is_on_wall() and !is_on_floor():
			$Sprite.play("Wall")
		elif !is_on_floor():
			
				if !fly:
					$Sprite.play("Fall")
				else:
					$Sprite.play("Jump")
		else:
			$Sprite.play("Idle")


func _on_Sprite_animation_finished():
	if velocity.x != 0:
		$Sprite.play("Run")
	elif is_on_wall() and !is_on_floor():
		$Sprite.play("Wall")
	elif !is_on_floor():
		
			if !fly:
				$Sprite.play("Fall")
			else:
				$Sprite.play("Jump")
	else:
		$Sprite.play("Idle") # Replace with function body.
