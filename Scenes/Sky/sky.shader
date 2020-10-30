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

uniform vec2 sunDir = vec2(0., 1.);

float remap01(float x, float m_, float _m)
{
	return clamp((x-m_)/(_m-m_), 0., 1.);
}

// Fragment Shader
void fragment()
{
	vec4 stars = texture(TEXTURE, UV);
	vec3 rd = normalize(vec3(-1.+2.*UV, 1.));
	vec3 ld = normalize(vec3(sunDir, 1.));
	float sunViewTeta = dot(rd, -ld);
	float LoN = dot(sunDir, vec2(0., 1.));
	vec3 color = vec3(0.);
	float g = UV.y;
	g = log(1.+g);
	const vec3 colorDawn = vec3(1.0, 0.2, 0);
	const vec3 colorNight = vec3(0, 0.1, 0.5);
	const vec3 colorDay = vec3(0.1, 0.6, 1);
	
	float anim = fract(sin(fract(0.05*TIME)*3.14));
	float colorStars = 	mix(
							stars.r,
							mix(
								stars.g,
								mix(
									stars.b,
									stars.a,
									remap01(anim, 0.66, 1.)
								),
								remap01(anim, 0.33, 0.66)
							),
							remap01(anim, 0., 0.33)
						);
	color = mix(
				0.5*(1.+g)*colorNight,
				mix(
					mix(colorNight, colorDawn, clamp(g+LoN, 0., 1.)),
					0.5*(1.+(1.-g))*colorDay,
					remap01(LoN, 0., 1.)
				),
				remap01(LoN, -1., 0.)
			);
	COLOR = vec4(color, 1.);
}