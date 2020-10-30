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

uniform float slimeOffsetScaleX = 0.05;
uniform float slimeOffsetScaleFreq = 16.;
uniform float deformScale = 0.04;
uniform float sharpness = 1.;
uniform float flowPower = 0.;

float remap01(float x, float m_, float _m)
{
	return clamp((x-m_)/(_m-m_), 0., 1.);
}

void flowmap(
	float time,
    float blend_cycle, float cycle_speed,
    float offset,
    vec2 flow, float flow_speed, vec2 flow_scale,
    vec2 base_uv,
    out float blend_factor,
    out vec2 ouv1, out vec2 ouv2)
{
    // Compute cycle, phases
	float half_cycle = blend_cycle * 0.5;

	float phase0 = mod(offset + time * cycle_speed, blend_cycle);
	float phase1 = mod(offset + time * cycle_speed + half_cycle, blend_cycle);

	// Blend factor to mix the two layers
	blend_factor = abs(half_cycle - phase0)/half_cycle;

	// Offset by halfCycle to improve the animation for color (for normalmap not absolutely necessary)
	phase0 -= half_cycle;
	phase1 -= half_cycle;

	// Multiply with scale to make flow speed independent from the uv scaling
	flow *= flow_speed * flow_scale;

	ouv1 = flow * phase0 + base_uv;
	ouv2 = flow * phase1 + base_uv;
}

// Fragment Shader
void fragment()
{
    float blend_factor;
    vec2 ouv1, ouv2;
	// first get first texture sample
	float dirX = 0.;
	dirX = .1*sin(TIME);
	vec2 uv = UV+vec2(clamp(dirX, -.1, .1)*(1.-UV.y)*(1.-UV.y), 0.);
	vec4 slimeFix = texture(TEXTURE, uv);
	vec4 slime = slimeFix;
	
	if(flowPower>0.)
	{
		flowmap(TIME, 2.*flowPower, flowPower, 0.,
		    -1.+2.*slimeFix.rg, flowPower*0.8, vec2(flowPower*0.4),
		    uv,
		    blend_factor, ouv1, ouv2);
		
		// sample slime following flow
		slime = mix(texture(TEXTURE, ouv1), texture(TEXTURE, ouv2), blend_factor);
	}
	
	float depth = slime.a;
	float alpha = pow(depth, mix(0.5, 0.2, sharpness));
	float attenuation = depth;
	vec4 backgroundColor = texture(NORMAL_TEXTURE, SCREEN_UV+attenuation*deformScale*(-1.+2.*slime.rg));
	float baseColor = mix(1.-slime.b, slime.b, 0.5*(1.+sin(TIME)));
	COLOR = vec4(mix(mix(baseColor, slime.r, 0.5)*vec3(0., 1., 0.), backgroundColor.rgb, mix(.2, .1, alpha)), alpha);
	//COLOR = vec4(attenuation>0.9?vec4(1., 0., 0., 1.):vec4(1.));
	//COLOR = vec4(slimeOffsetScaleX);
}