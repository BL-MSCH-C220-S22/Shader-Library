shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color : hint_color;
uniform float time_scale = 0.1;
uniform float seed = 1.0;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453*seed);
}

void fragment() {
	float a = 1.0;
	
	vec2 centered = UV - 0.5;
	float angle = atan(UV.x - 0.5, UV.y - 0.5) + TIME * time_scale;
	float l = length(centered);
	float random = rand(vec2(floor(angle + sin((angle + TIME * time_scale)*10.0))));
	
	float ray = step(sin(angle*7.0), 0.0);
	ray *= random;
	a = ray * (0.4-l);
	a = clamp(a, 0.0, 1.0);
	
	
	COLOR = vec4(vec3(ray)*color.rgb, a * color.a);
}