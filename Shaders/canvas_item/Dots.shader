shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color : hint_color;
uniform float dot_radius : hint_range(0.0, 1.0) = 0.25;
uniform float distance_cutoff : hint_range(0.0, 1.0) = 0.4;
uniform vec2 uv_size = vec2(40, 40);
uniform float seed : hint_range(1,10) = 1.0;
uniform float time_scale : hint_range(0.0, 1.0) = 0.05;
uniform float freq = 0.5;

vec2 hash( float n ) {
    float sn = sin(n);
    return fract(vec2(sn,sn*42125.13)*seed);
}
// by Leukbaars from https://www.shadertoy.com/view/4tK3zR
float circleNoise(vec2 uv) {
    float uv_y = floor(uv.y);
    uv.x += uv_y*.31;
    vec2 f = fract(uv);
    vec2 h = hash(floor(uv.x)*uv_y);
    float m = (length(f-dot_radius-(h.x*freq)));
    float r = h.y*dot_radius;
    return m = step(r-.10*r,m);
}

vec2 sphereify(vec2 coord) { 
	// from https://www.shadertoy.com/view/wdSXRz
	vec2 uv = coord - 0.5; 
	uv *= 2.2;
	uv = mix(uv,normalize(uv)*(2.0*asin(length(uv)) / 3.1415926),0.5);
    vec3 n = vec3(uv, sqrt(1.0 - uv.x*uv.x - uv.y*uv.y));
    uv = normalize(uv)*(2.0*asin(length(uv)) / 3.1415926);
	return uv;
}


void fragment() {
	vec2 uv = sphereify(UV);
	vec2 offset = vec2(TIME * time_scale, 10.0);
	
	float circle = circleNoise(uv * uv_size + offset);
	float dist = distance(UV, vec2(0.5));
	
	// alpha
	float a = step(dist, distance_cutoff);
	a *= 1.0 - circle;
	
	COLOR = vec4(color.rgb, color.a * a);
}