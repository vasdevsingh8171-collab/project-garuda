extends CharacterBody3D

@export var move_speed: float = 5.0
@export var jump_speed: float = 5.0
@export var gravity_strength: float = 14.0

var touch_state: Dictionary = {}
var hud_layer: CanvasLayer

func _ready() -> void:
    _make_garuda_core()
    _make_touch_hud()

func _physics_process(delta: float) -> void:
    var axis := Vector2.ZERO

    if Input.is_key_pressed(KEY_A) or touch_state.get("left", false):
        axis.x -= 1.0
    if Input.is_key_pressed(KEY_D) or touch_state.get("right", false):
        axis.x += 1.0
    if Input.is_key_pressed(KEY_W) or touch_state.get("forward", false):
        axis.y -= 1.0
    if Input.is_key_pressed(KEY_S) or touch_state.get("back", false):
        axis.y += 1.0

    axis = axis.normalized()
    var direction := Vector3(axis.x, 0.0, axis.y)

    if not is_on_floor():
        velocity.y -= gravity_strength * delta
    elif Input.is_key_pressed(KEY_SPACE) or touch_state.get("jump", false):
        velocity.y = jump_speed

    velocity.x = direction.x * move_speed
    velocity.z = direction.z * move_speed

    if direction.length() > 0.05:
        look_at(global_position + direction, Vector3.UP)

    move_and_slide()

func _make_garuda_core() -> void:
    var core := MeshInstance3D.new()
    core.name = "GoldenEnergyCore"
    var sphere := SphereMesh.new()
    sphere.radius = 0.18
    sphere.height = 0.36
    core.mesh = sphere
    core.position = Vector3(0.0, 0.25, -0.47)

    var material := StandardMaterial3D.new()
    material.albedo_color = Color("#F59E0B")
    material.emission_enabled = true
    material.emission = Color("#FFE066")
    material.emission_energy_multiplier = 2.2
    core.material_override = material
    add_child(core)

func _make_touch_hud() -> void:
    hud_layer = CanvasLayer.new()
    add_child(hud_layer)

    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    hud_layer.add_child(root)

    var title := Label.new()
    title.text = "GARUDA // FLIGHT & MOVEMENT TEST"
    title.position = Vector2(18, 18)
    title.add_theme_color_override("font_color", Color("#67E8F9"))
    title.add_theme_font_size_override("font_size", 15)
    root.add_child(title)

    _add_hold_button(root, "▲", "forward", Vector2(104, -174), Vector2(66, 62))
    _add_hold_button(root, "▼", "back", Vector2(104, -42), Vector2(66, 62))
    _add_hold_button(root, "◀", "left", Vector2(34, -108), Vector2(66, 62))
    _add_hold_button(root, "▶", "right", Vector2(174, -108), Vector2(66, 62))
    _add_hold_button(root, "JUMP", "jump", Vector2(-126, -112), Vector2(104, 82), true)

func _add_hold_button(parent: Control, caption: String, action_name: String,
        offset: Vector2, button_size: Vector2, is_jump: bool = false) -> void:
    var button := Button.new()
    button.text = caption
    button.size = button_size
    button.anchor_left = 0.0 if not is_jump else 1.0
    button.anchor_right = 0.0 if not is_jump else 1.0
    button.anchor_top = 1.0
    button.anchor_bottom = 1.0
    button.position = offset
    button.focus_mode = Control.FOCUS_NONE
    button.add_theme_font_size_override("font_size", 16 if not is_jump else 14)
    button.add_theme_color_override("font_color", Color("#F8FAFC"))
    button.add_theme_color_override("font_hover_color", Color("#FFE066"))
    button.add_theme_stylebox_override("normal", _button_style(Color("#1B2230")))
    button.add_theme_stylebox_override("pressed", _button_style(Color("#8F0D13")))
    button.button_down.connect(func() -> void: touch_state[action_name] = true)
    button.button_up.connect(func() -> void: touch_state[action_name] = false)
    parent.add_child(button)

func _button_style(fill: Color) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = Color(fill, 0.88)
    style.border_color = Color("#F59E0B")
    style.set_border_width_all(1)
    style.set_corner_radius_all(4)
    style.content_margin_left = 8
    style.content_margin_right = 8
    style.content_margin_top = 6
    style.content_margin_bottom = 6
    return style
