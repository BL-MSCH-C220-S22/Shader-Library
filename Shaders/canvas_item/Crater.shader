shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color1 : hint_color;
uniform vec4 color2 : hint_color;
uniform vec4 color3 : hint_color;


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

vec2 sinhash(float n) {
	float sn = sin(n);
    return sin(vec2(sn,sn*42125.13)*seed);
}

// by Leukbaars from https://www.shadertoy.com/view/4tK3zR
vec3 circleNoise(vec2 uv) {
    float uv_y = floor(uv.y);
    uv.x += uv_y;//*.31;
    vec2 f = fract(uv);
    vec2 h = hash(floor(uv.x)*uv_y);
    float m = (length(f-dot_radius-(h.x*freq)));
    float r = h.y*dot_radius;
    return vec3(h.x, h.y, m);// = smoothstep(r-.10*r,r,m);
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

vec2 rotate(vec2 vec, float angle) {
	vec -=vec2(0.5);
	vec *= mat2(vec2(cos(angle),-sin(angle)), vec2(sin(angle),cos(angle)));
	vec += vec2(0.5);
	return vec;
}

void fragment() {
	vec2 uv = sphereify(UV);
	vec2 offset = vec2(TIME * time_scale, 7.0);
	float dist = distance(UV, vec2(0.5));
	
	// alpha
	float a = step(dist, distance_cutoff);
	
	vec3 crater = circleNoise(uv * uv_size + offset);
	// by checking differences between this and next diff, we can only use values that get larger (craters only get bigger)
	float diff = crater.y - sinhash(floor(uv.x*uv_size.x+offset.x) * floor(uv.y*uv_size.x+offset.y)+TIME*time_scale*0.05).x;
	float diff_next = crater.y - sinhash(floor(uv.x*uv_size.x+offset.x) * floor(uv.y*uv_size.x+offset.y)+TIME*time_scale*0.05-.01).x;
	
	float color_progress = -crater.z * diff;//step(crater.z * diff, 0.2);
	if (diff > diff_next) { // only use values that become bigger
		color_progress = 0.0;
		a = 0.0;
	}
	
	vec4 col = color1;
	if (color_progress > 0.01) {
		col = color2;
	}
	if (color_progress > 0.03) {
		col = color3;
	}
	
	
	col.a *= step(crater.z, -diff);
	col.a *= step(-diff_next - crater.y * 0.1, crater.z + 0.1);
	// dont make craters too big, or they create harsh edges with fracted UV's
	if (crater.z > dot_radius) {
		a = 0.0;
	}
	
	COLOR = vec4(col.rgb, col.a * a);
}