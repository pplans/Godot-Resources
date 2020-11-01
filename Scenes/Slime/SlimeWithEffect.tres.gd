class_name SlimeWithEffect
extends Sprite

var m_directionX: float

# Called when the node enters the scene tree for the first time.
func _ready():
	m_directionX = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass

func SetDirectionX(dirX):
	m_directionX = dirX
	self.material.set_shader_param("uDirX", m_directionX)
