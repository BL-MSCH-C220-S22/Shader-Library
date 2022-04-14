shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color : hint_color;
uniform vec4 color_inner : hint_color;

uniform float distance_cutoff : hint_range(0.0, 1.0) = 0.4;
uniform float bumps : hint_range(1, 100) = 28.0;
uniform float bump_height : hint_range(0.0, 1.0) = 0.01;
uniform float time_scale : hint_range(0.0, 1.0) = 0.05;

uniform float seed: hint_range(1, 10);
uniform float scale = 1.0;

vec2 rand(vec2 coord) {
	return vec2(fract(sin(dot(coord, vec2(35, 62)) * 1000.0) * 1000.0 * seed));
}

vec2 rotate_vec2(vec2 vec, float angle) {
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
	float dist = distance(UV, vec2(0.5));
	vec2 circleUV = vec2(dist, angle);
	
	angle += time;	
	float bump = sin(angle * bumps) * bump_height;
	
	vec4 col = color;
	float c = 1.0 - circleNoise(circleUV*scale, time);
	
	if (c - dist> 0.5) {
		col = color_inner;
	}
	
	float total = (dist + bump);
	float a = step(total, distance_cutoff);
	a += step(dist*2.0, c);
	a = clamp(a, 0.0, 1.0);
	
	COLOR = vec4(col.rgb, col.a * a);
}