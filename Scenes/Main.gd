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

extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var m_sunDir = Vector2(0.0, 1.0)
export var fNightToDay: float
export var bForceNightAndDay: bool

var m_elapsedTime = 0.0;

var m_root = "BackgroundScenes/ViewportContainer/Viewport/Node2D/"
var m_playerRelatedPath = "CanvasLayerPlayer/"

var m_player: Ship2D
var m_water1: Water2D
var m_water2: Water2D
var m_clouds: Clouds2D
var m_sky: Sky2D
var m_slimeDemo: SlimeWithEffect
	
# Called when the node enters the scene tree for the first time.
func _ready():
	m_player = get_node(m_root+m_playerRelatedPath+"Ship/Sprite") as Ship2D;
	m_water1 = get_node(m_root+m_playerRelatedPath+"Ship/Sprite/Camera2D/Water/MeshInstance2D") as Water2D
	m_water2 = get_node(m_root+m_playerRelatedPath+"Ship/Sprite/Camera2D/Water2/MeshInstance2D") as Water2D
	m_clouds = get_node(m_root+"CanvasLayer/Clouds/ParallaxBackground/ParallaxLayer2/Clouds") as Clouds2D
	m_sky = get_node(m_root+"CanvasLayer/TextureRect") as Sky2D
	m_slimeDemo = get_node("CanvasLayer/Node2D/Camera2D/Sprite") as SlimeWithEffect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bForceNightAndDay:
		m_sunDir = Vector2(0.0, -1.0)
		m_sunDir = m_sunDir.rotated(PI*fNightToDay)
	else:
		m_sunDir = m_sunDir.rotated(delta)

	m_sky.SetSunDir(m_sunDir)
	m_clouds.SetSunDir(m_sunDir)
	m_water1.SetSunDir(m_sunDir)
	m_water2.SetSunDir(m_sunDir)
	m_player.SetSunDir(m_sunDir)

	m_water1.SetHorizontalPos(m_player.GetPos().x)
	m_water2.SetHorizontalPos(m_player.GetPos().x)
	m_elapsedTime += delta;
	var sT = sin(m_elapsedTime);
	m_slimeDemo.SetDirectionX(sT)
