extends Button


@export var item: BaseMaterial3D
@export var item_data: ItemData
@export var object_properties: ObjectProperties


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon = item_data.icon
	tooltip_text = item_data.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	object_properties.object.material_override = item