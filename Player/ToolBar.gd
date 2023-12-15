extends CanvasLayer
class_name ToolBar

@onready var cartridges = %Cartridges
@export var player: Player

enum MODES {DEFAULT, JUMP, PUSH, SPEED}
# Called when the node enters the scene tree for the first time.
func _ready():
	update_cartridges()


func update_cartridges():
	var template = "Jump %s   Speed %s   Push %s"
	var realstring = template % [player.cartridges_dict[MODES.JUMP], player.cartridges_dict[MODES.SPEED], player.cartridges_dict[MODES.PUSH]]
	cartridges.text = realstring
