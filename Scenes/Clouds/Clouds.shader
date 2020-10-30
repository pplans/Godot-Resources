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
render_mode blend_disabled;

uniform vec2 sunDir = vec2(0., 1.);

vec2 rot(vec2 X, float a)
{
 	float s = sin(a); float c = cos(a);
    return mat2(vec2(c, -s), vec2(s, c))*X;
}

float Hash(vec2 uv)
{
 	vec2 suv = sin(uv);
    suv = rot(suv, uv.x);
    return fract(mix(suv.x*13.13032942, suv.y*12.01293203924, dot(uv, suv)));
	//return fract(sin(dot(uv, uv)*2134.23987439));
}

float smoothHash(vec2 uv)
{
 	vec2 lower	= floor(uv);
    vec2 frac 	= fract(uv);
    vec2 f = frac*frac*(3.0-2.0*frac);
    
    return mix(
        	mix(Hash(lower+vec2(0.0, 0.0)), Hash(lower+vec2(1.0, 0.0)), f.x),
        	mix(Hash(lower+vec2(0.0, 1.0)), Hash(lower+vec2(1.0, 1.0)), f.x),
        	f.y);
}

float fbmHash(vec2 x)
{
	float h = 0.;
	h += 0.800*smoothHash(x); x *= 2.;
	h += 0.400*smoothHash(x); x *= 2.;
	h += 0.200*smoothHash(x); x *= 2.;
	h += 0.100*smoothHash(x); x *= 2.;
	return h*0.25;
}

float remap01(float x, float m_, float _m)
{
	return clamp((x-m_)/(_m-m_), 0., 1.);
}

// Fragment Shader
void fragment()
{
	float t = .4*TIME;
	float h = fbmHash(16.*UV+vec2(t, t*0.5));
	vec4 base = texture(TEXTURE, UV);
	vec4 noises = texture(TEXTURE, UV+0.005*t);
	//if(base.a>0.)
	{
		vec2 noise = clamp(1.-noises.rg, 0., 1.);
		float b = exp(-base.a*(remap01(noise.r, 0.0, 1.)+remap01(noise.g, 0.0, 1.0)));
		float sunTeta = dot(normalize(sunDir), vec2(0., 1.));
		const vec3 colorNight = vec3(0.1);
		const vec3 colorDawn = vec3(0.7, 0.4, 0.55);
		const vec3 colorDay = vec3(1.);
		
		vec3 sunImpact = 	mix(
								colorNight,
								mix(
									colorDawn,
									mix(
										colorDawn,
										mix(
											colorDawn,
											colorDay,
											remap01(sunTeta, 0.15, 1.0)
										),	
										remap01(sunTeta, 0., 0.15)
									),
									remap01(sunTeta, -0.15, 0.0)
								),
								remap01(sunTeta, -1., -0.15)
							);
			
		vec3 color = clamp((0.2+sunImpact)*b, 0., 1.);

		COLOR = clamp(vec4(color, base.b-0.2*h*noises.g), 0., 1.);
		//COLOR.a = 1.;
		//COLOR.r = COLOR.b = COLOR.g = h;// clamp(base, 0., 1.);
		//COLOR = vec4(b, 0, 0, 1)
	}
}