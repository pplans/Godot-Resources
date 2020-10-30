/*******************************************************************************
 * @author: pierre.plans@gmail.com
 *
 * MIT License
 *
 * Copyright (c) 2020 Pierre-Marie Plans
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 ******************************************************************************/
shader_type canvas_item;
render_mode unshaded;

uniform vec4 parameters;
uniform vec2 sunDir = vec2(0., 1.);

// https://www.shadertoy.com/view/Ml2XWy
float trochoid2d(vec2 v, float t) // Approximation to FabriceNeyret2's inverse trochoid function (source: https://www.shadertoy.com/view/MtSSDG)
{
    float A = 0.5 + 0.4 * sin(0.1 * t * 2.0 * 3.14);
    return 1.-(-A + 2.0 * A * pow(1.0 - pow(0.5 + 0.5 * sin(v.x - t), A + 1.0), 1.0 / (A + 1.0)));
}

// Fragment Shader
void fragment()
{
	float f = parameters.y;
	float w = 0.;
	float a = parameters.x;
	float s = 0.;
	vec2 pos2D = UV+vec2(parameters.z, 0.0);
	for(int i = 0;i<4; ++i)
	{
		w += a*trochoid2d(f*pos2D, s+TIME);//sin(f*UV.x+TIME);
		w += 2.*a*trochoid2d(0.5*f*pos2D, s+-0.5*TIME);//sin(f*UV.x-TIME);
		a *= 0.2;
		f *= 4.;
		s+=5.;
	}
	w = w / 4.;

	float yOffset = w;
	vec2 uv = UV+vec2(0., -0.25+w);
	vec4 baseColor = vec4(0.02, 0.08, 0.15, 0.)+max(0., dot(normalize(sunDir), vec2(0., 1.)))*texture(TEXTURE, uv);
	
	float overflow = (1.-max(0., uv.y));
	baseColor.a = 1.-pow(overflow, 16.);

	COLOR = baseColor;
}