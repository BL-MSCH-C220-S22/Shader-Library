shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color : hint_color;

uniform float time_scale : hint_range(0.0, 1.0) = 0.05;

uniform float scale = 1.0;
uniform float seed: hint_range(1, 10);

vec2 rand(vec2 coord) {
	return vec2(fract(sin(dot(coord, vec2(35, 62)) * 1000.0) * 1000.0 * seed));
}

vec2 rotate(vec2 vec, float angle) {
	vec -=vec2(0.5);
	vec *= mat2(vec2(cos(angle),-sin(angle)), vec2(sin(angle),cos(angle)));
	vec += vec2(0.5);
	return vec;
}

vec2 hash( float n ) {
    float sn = sin(n);
    return fract(vec2(sn,sn*42125.13)*seed);
}
// by Leukbaars from https://www.shadertoy.com/view/4tK3zR
float circleNoise(vec2 uv, float time) {
	float angle = atan(uv.x, uv.y);

	uv += sign(-uv) * time;
    float uv_y = floor(uv.y);
    uv.x += uv_y*.31;

	//uv.x += uv_y*.31+sign(-uv.x)*time;
	//uv.x += uv_y*.31+angle/2.0;
    vec2 f = fract(uv);
    vec2 h = hash(floor(uv.x)*uv_y);
    float m = (length(f-.5-(h.x*.5)));
    float r = (h.y*.5);
    return m = smoothstep(r-1.0*r,r,m);
}

void fragment() {
	float time = TIME * time_scale;

	// angle from centered uv's
	float angle = atan(UV.x - 0.5, UV.y - 0.5);
	float d = distance(UV, vec2(0.5));
	vec2 circleUV = vec2(d, (angle)) ;
	
	float c = 1.0 - circleNoise(circleUV*scale, time);
	c = step(d*2.0, c);

	COLOR = vec4(color.rgb, color.a * c);
}