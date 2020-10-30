# *******************************************************************************
# * @author: pierre.plans@gmail.com
# *
# * MIT License
# *
# * Copyright (c) 2020 Pierre-Marie Plans
# *
# * Permission is hereby granted, free of charge, to any person obtaining a copy
# * of this software and associated documentation files (the "Software"), to deal
# * in the Software without restriction, including without limitation the rights
# * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# * copies of the Software, and to permit persons to whom the Software is
# * furnished to do so, subject to the following conditions:
# * 
# * The above copyright notice and this permission notice shall be included in all
# * copies or substantial portions of the Software.
# * 
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# * SOFTWARE.
# ******************************************************************************

class_name Ship2D
extends Sprite

export var m_speed = Vector2(0.1, 0.0)

var sunDir = Vector2(0.0, 1.0)

var m_dir = Vector2.ZERO;

var m_spriteDay: Texture
var m_spriteNight: Texture

func SetSunDir(dir):
	sunDir = dir;

func GetPos():
	return position

# Called when the node enters the scene tree for the first time.
func _ready():
	m_spriteDay = load("res://Ship/textures/Ship.png")
	m_spriteNight = load("res://Ship/textures/ShipNight.png");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	m_dir.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	position.x += m_dir.x*delta*m_speed.x
	self.material.set_shader_param("sunDir", sunDir);
	# switch sprite, actually done in the shader using the normal slot
	#if sunDir.dot(Vector2.UP)<0.0:
	#	self.texture = m_spriteDay
	#else:
	#	self.texture = m_spriteNight