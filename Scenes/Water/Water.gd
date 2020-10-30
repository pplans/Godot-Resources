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


class_name Water2D
extends MeshInstance2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sunDir = Vector2(0.0, 1.0)
export var Amplitude = 0.05
export var Frequency = 4.0
export var Width = 1024.0

var m_horizontalPos = 0.0;

func SetSunDir(dir):
	sunDir = dir

func SetHorizontalPos(xpos):
	m_horizontalPos = xpos

# Called when the node enters the scene tree for the first time.
func _ready():
	var vertices = PoolVector3Array()
	var uv = PoolVector2Array()
	var xnumber = 1;
	for i in range(0, xnumber, 1):
		var xstep = float(1.0/xnumber);
		var x = i*xstep;
		var xnext = x+xstep;
		vertices.push_back	(Vector3(x, 0, 0))
		uv.push_back		(Vector2(x, 0))
		vertices.push_back	(Vector3(x, 1, 0))
		uv.push_back		(Vector2(x, 1))
		vertices.push_back	(Vector3(xnext, 1, 0))
		uv.push_back		(Vector2(xnext, 1))
		vertices.push_back	(Vector3(xnext, 1, 0))
		uv.push_back		(Vector2(xnext, 1))
		vertices.push_back	(Vector3(xnext, 0, 0))
		uv.push_back		(Vector2(xnext, 0))
		vertices.push_back	(Vector3(x, 0, 0))
		uv.push_back		(Vector2(x, 0))
	# Initialize the ArrayMesh.
	#var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_TEX_UV] = uv
	# Create the Mesh.
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	#var m = MeshInstance.new()
	#m.mesh = arr_mesh


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.material.set_shader_param("parameters", Color(Amplitude, Frequency, m_horizontalPos, 1.0))
	self.material.set_shader_param("sunDir", sunDir);
