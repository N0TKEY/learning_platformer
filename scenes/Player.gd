extends KinematicBody2D
var speed = 120
var jump = 3800
var jumpLine = 0
const gravitation = 3.5
var fly = false
var fall = false
const FLOOR = Vector2(0,-1)
var velocity = Vector2(0,0)
var duble_jump = false
onready var newLabel = get_parent().get_node("Label")

func _physics_process(delta):
	newLabel.text = ""
	if is_on_floor():
		jumpLine = 0
#		$CircleAnimation.visible = false
		duble_jump = false
		fall = false
	elif !fly:
		fall = true
	if InputEventAction.new():
		velocitySet()
	
	if fly:
		velocity.y = -1
		if jumpLine >= jump and fly:
			fly = false
			jumpLine = 0
			fall = true
	elif !is_on_floor():
		velocity.y = 1
	
	
	velocity.x *= speed
	if is_on_wall() and fall:
		velocity.y *= speed
	else:
		newLabel.text += str(jumpLine>jump*0.9 and fly) + "\n" + str(jumpLine<jump*0.1 and fall) + str(jumpLine) + "\n"
		if (jumpLine>jump*0.9 and fly) or (jumpLine<jump*0.1 and fall):
			velocity.y *= speed*1
		else:
			if fall:
				velocity.y *= speed+int(gravitation*sqrt(jumpLine))
				print(int(gravitation*sqrt(jumpLine)))
			else:
				velocity.y *= speed*2.5
	jumpLine += abs(velocity.y)
	newLabel.text += "Velo: " + str(velocity) + "\n"
	velocity = move_and_slide(velocity, FLOOR)
	newLabel.text += "Floor: " + str(is_on_floor()) + "\n"
	newLabel.text += "Fall: " + str(fall) + "\n"
	animates_player(velocity)


func velocitySet():
	if Input.is_action_pressed("ui_left") or $Button.pressed:
		velocity.x = -1
		if !$Sprite.flip_h:
			$Sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 1
		if $Sprite.flip_h:
			$Sprite.flip_h = false
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or !duble_jump or is_on_wall()):
		fly = true
		fall = false
		jumpLine = 0
		if !is_on_floor() and !is_on_wall():
			duble_jump = true
	#print("Жмак")


func animates_player(direction: Vector2):
	newLabel.text += "Fly: " + str(fly) + "\n"
	if duble_jump and fly:
			$Sprite.play("D_Jump")
	else:
		if direction.x != 0:
			$Sprite.play("Run")
		elif !is_on_floor() and (fall or fly) and !is_on_wall():
			if fall:
				$Sprite.play("Fall")
			elif fly:
				$Sprite.play("Jump")
		elif is_on_wall() and !is_on_floor():
			$Sprite.play("Wall")
		else:
			$Sprite.play("Idle")


func _on_Sprite_animation_finished():
	if fall:
		if $Sprite.animation == "D_Jump":
			$Sprite.play("Fall")
