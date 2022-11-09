extends KinematicBody2D
var speed = 120
const gravitation = 0.3
var gravity = gravitation
var jump = 4000
var jumpLine = 0
var fly = false
var fall = false
const FLOOR = Vector2(0,-1)
var velocity = Vector2(0,0)
var duble_jump = false

func _physics_process(delta):
	$Label.text = ""
	if is_on_floor():
		gravity = 0.5
		jumpLine = 0
#		$CircleAnimation.visible = false
		duble_jump = false
		fall = false
	if InputEventAction.new():
		velocitySet()
	
	if fly:
		velocity.y = -1
	elif !is_on_floor():
		velocity.y = 1
	if jumpLine >= jump:
		fly = false
		fall = true
	
	velocity.x *= speed
	if !$Button.disabled:
		if is_on_wall() and fall:
			velocity.y *= speed
		else:
			velocity.y *= speed*2.5
	jumpLine -= velocity.y
	$Label.text += "Velo: " + str(velocity) + "\n"
	velocity = move_and_slide(velocity, FLOOR)
	$Label.text += "Floor: " + str(is_on_floor()) + "\n"
	animates_player(velocity)


func velocitySet():
	if Input.is_action_pressed("ui_left") or $Button.pressed:
		velocity.x = -1
		#$Button.disabled = true
		if !$Sprite.flip_h:
			$Sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 1
		if $Sprite.flip_h:
			$Sprite.flip_h = false
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or !duble_jump):
		fly = true
		if !is_on_floor():
			duble_jump = true
			jumpLine = 0
	if $Button2.pressed:
		$Button.disabled = false


func animates_player(direction: Vector2):
	$Label.text += "Fly: " + str(fly) + "\n"
	if duble_jump and fly:
			$Sprite.play("D_Jump")
	else:
		if direction.x != 0:
			$Sprite.play("Run")
		elif !is_on_floor() and (fall or fly):
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
