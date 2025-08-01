class_name Wasp
extends Node2D

const SPEED_Y:float = 30
const VEL_EXIT:float = 120
const ACC_EXIT:float = 700

static var dead_wasp_count:int = 0

enum State {
	LANDING,
	ATTACKING,
	DYING
}

var state:State = State.LANDING:
	set(value):
		state = value
		match state:
			State.LANDING:
				$AnimatedSprite2D.play("landing")
			State.ATTACKING:
				$AnimatedSprite2D.play("attacking")
				var half_screen = get_viewport_rect().size.x/2
				if position.x > half_screen:
					attack_dir = -1
				if position.x <= half_screen:
					attack_dir = 1
				rotation = -PI/2 * attack_dir
				velocity_x = VEL_EXIT * -attack_dir
			State.DYING:
				$AnimatedSprite2D.stop()
				$AnimatedSprite2D.rotation = PI
				$Area2D.rotation = PI
				queue_redraw()

var score:int = 250

#region LANDING vars
@export_range(-1,1,2) var direction_x: int = 1
@export_range(60,180,10) var velocity_x: float = 60
@onready var switch_dir_time:float = 144.0 / velocity_x
@onready var switch_dir_timer:float = switch_dir_time
#endregion

#region ATTACKING vars
var attack_dir: int = 1
#endregion

#region DYING vars
var velocity_y: float = -VEL_EXIT
#endregion

func _ready() -> void:
	$AnimatedSprite2D.play("landing")
	
func _draw() -> void:
	if not state == State.DYING:
		return
	var theme:Theme = ThemeDB.get_project_theme()
	draw_string(theme.default_font, Vector2(0,0), str(score),
			HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER, -1, theme.default_font_size)

func _physics_process(delta: float) -> void:
	match state:
		State.LANDING:
			
			position.y += SPEED_Y * delta
			if position.y >= 48.0:
				switch_dir_timer -= delta
				if switch_dir_timer <= 0.0:
					direction_x = -direction_x
					switch_dir_timer = switch_dir_time
				position.x += velocity_x * direction_x * delta
			if position.y >= 232.0:
				state = State.ATTACKING
		State.ATTACKING:
			velocity_x += ACC_EXIT * attack_dir * delta
			position.x += velocity_x * delta
		State.DYING:
			velocity_y += ACC_EXIT * delta
			$AnimatedSprite2D.position.y += velocity_y * delta
			$Area2D.position.y = $AnimatedSprite2D.position.y

func out_of_bounds() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if state == State.DYING or position.y < 48.0:
		return
	if not(area.owner is Spray):
		return
	(area.owner as Spray).resize_spray(-1)
	(area.owner as Spray).expand_timer = Spray.EXPAND_TIME
	dead_wasp_count += 1
	(area.owner as Spray).wasps_killed += 1
	score *= (area.owner as Spray).wasps_killed
	state = State.DYING
