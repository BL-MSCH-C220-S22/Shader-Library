shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color : hint_color;

uniform float distance_cutoff : hint_range(0.0, 1.0) = 0.37;
uniform float ring_size : hint_range(0.0, 0.5) = 0.03;
uniform float bumps : hint_range(1, 100) = 28.0;
uniform float bump_height : hint_range(0.0, 1.0) = 0.01;
uniform float time_scale : hint_range(0.0, 1.0) = 0.05;

vec2 rotate_vec2(vec2 vec, float angle) {
	vec -=vec2(0.5);
	vec *= mat2(vec2(cos(angle),-sin(angle)), vec2(sin(angle),cos(angle)));
	vec += vec2(0.5);
	return vec;
}

void fragment() {
	float time = TIME * time_scale;

	// angle from centered uv's
	float angle = atan(UV.x - 0.5, UV.y - 0.5);
	angle += time;
	
	// dist makes a circle, bump is the bumps along the edge
	float dist = distance(UV, vec2(0.5));
	
	float bump_outer = sin(angle * bumps) * bump_height;	
	float bump_inner = sin(angle * bumps * 0.5) * bump_height;	
	
	// check cutoff against sum of circle and bumps
	float a_outer = step(dist + bump_outer, distance_cutoff);
	float a_inner = step(distance_cutoff - ring_size, dist + bump_inner);
	COLOR = vec4(color.rgb, color.a * a_outer * a_inner);
}