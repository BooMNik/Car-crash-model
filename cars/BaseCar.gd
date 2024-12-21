extends VehicleBody3D
@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40

@onready var doge_body = $cpot
@onready var stock_body = $cpotcrash
@onready var doge_body2 = $door
@onready var stock_body2 = $doorcrashcrash
@onready var doge_body3 = $down
@onready var stock_body3 = $downcrash
@onready var collision_shape = $CollisionShape3D2 # Получаем ссылку на CollisionShape3D

var is_swapped = false
var is_collided = false # Флаг для проверки столкновения

func _ready():
	stock_body.visible = false # по умолчанию невидимым stock-body
	doge_body.visible = true # по умолчанию видимым doge-body
	stock_body2.visible = false # по умолчанию невидимым stock-body
	doge_body2.visible = true # по умолчанию видимым doge-body
	stock_body3.visible = false # по умолчанию невидимым stock-body
	doge_body3.visible = true # по умолчанию видимым doge-body
	collision_shape.set_deferred("disabled", false)

func _physics_process(delta):
	var speed = linear_velocity.length() * Engine.get_frames_per_second() * delta
	traction(speed)
	$Hud/speed.text = str(round(speed * 0.8)) + "  KMPH"

	var fwd_mps = transform.basis.x.x
	steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	steer_target *= STEER_LIMIT
	if Input.is_action_pressed("ui_down"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if speed < 20 and speed != 0:
			engine_force = clamp(engine_force_value * 3 / speed, 0, 300)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0
	if Input.is_action_pressed("ui_up"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = -clamp(engine_force_value * 10 / speed, 0, 300)
			else:
				engine_force = -engine_force_value
		else:
			brake = 1
	else:
		brake = 0.0
		
	if Input.is_action_pressed("ui_select"):
		brake = 3
		$wheal2.wheel_friction_slip = 0.8
		$wheal3.wheel_friction_slip = 0.8
	else:
		$wheal2.wheel_friction_slip = 3
		$wheal3.wheel_friction_slip = 3
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)


	if Input.is_action_pressed("Cam1"):
		$Camera1.current = true
		$look/Camera3D.current = false
	if Input.is_action_pressed("Cam2"):
		$Camera1.current = false
		$look/Camera3D.current = true


var is_light_on = false # Флаг состояния света

func _process(_delta):
	if Input.is_action_just_pressed("Lightsalone"): # Используем is_action_just_pressed для однократного нажатия
		is_light_on = not is_light_on  # Инвертируем состояние света
		$SaloneLight.visible = is_light_on # Устанавливаем видимость в соответствии с флагом
	if Input.is_action_just_pressed("Lightcar"): # Используем is_action_just_pressed для однократного нажатия
		is_light_on = not is_light_on  # Инвертируем состояние света
		$LightCar.visible = is_light_on # Устанавливаем видимость в соответствии с флагом
		$LightCar2.visible = is_light_on # Устанавливаем видимость в соответствии с флагом
func traction(speed):
	apply_central_force(Vector3.DOWN * speed)
	




func _on_area_3d_body_entered(body):
	if not is_collided:
		if body.is_in_group("Obstacle"):
			var speed = linear_velocity.length() * Engine.get_frames_per_second()
			if speed > 1500: # Изменено с 200 на 150
				doge_body.visible = false
				stock_body.visible = true
				is_swapped = true
				is_collided = true
			else:
				is_collided = false


func _on_area_3d_2_body_entered(body):
	if not is_collided:
		if body.is_in_group("Obstacle"):
			var speed = linear_velocity.length() * Engine.get_frames_per_second()
			if speed > 1500: # Изменено с 200 на 150
				doge_body2.visible = false
				stock_body2.visible = true
				is_swapped = true
				is_collided = true
			else:
				is_collided = false

func _on_area_3d_3_body_entered(body):
	if not is_collided:
		if body.is_in_group("Obstacle"):
			var speed = linear_velocity.length() * Engine.get_frames_per_second()
			if speed > 1000: # Изменено с 200 на 150
				doge_body3.visible = false
				stock_body3.visible = true
				is_swapped = true
				is_collided = true
			else:
				is_collided = false
