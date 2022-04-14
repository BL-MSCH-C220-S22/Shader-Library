shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color : hint_color;
uniform vec2 circle_origin = vec2(0.36, 0.36);
uniform float distance_cutoff : hint_range(0.0, 1.0) = 0.37;

vec2 sphereify(vec2 coord) { 
	// from https://www.shadertoy.com/view/wdSXRz
	vec2 uv = coord - 0.5; 
	uv *= 2.2;
	uv = mix(uv,normalize(uv)*(2.0*asin(length(uv)) / 3.1415926),0.5);
    vec3 n = vec3(uv, sqrt(1.0 - uv.x*uv.x - uv.y*uv.y));
    uv = normalize(uv)*(2.0*asin(length(uv)) / 3.1415926);
	return uv;
}

vec2 rotate_vec2(vec2 vec, float angle) {
	vec -=vec2(0.5);
	vec *= mat2(vec2(cos(angle),-sin(angle)), vec2(sin(angle),cos(angle)));
	vec += vec2(0.5);
	return vec;
}

void fragment() {
	// dist makes a circle
	float circle_dist = distance(UV, vec2(0.5));

	// check cutoff against circle
	float a = step(circle_dist, 0.37);
	
	vec2 rotated = rotate_vec2(UV, 4.5);
	float color_dist = distance(sphereify(UV), sphereify(circle_origin));
	float corner_dist = distance(vec2(UV), vec2(0.03));
	
	//float color_dist = distance(UV, vec2(0.4));
	color_dist /= corner_dist;
	a *= step(color_dist, distance_cutoff);
	
	COLOR = vec4(color.rgb, color.a * a);
}

