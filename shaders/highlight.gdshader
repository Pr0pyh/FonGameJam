shader_type spatial;


uniform sampler2D noise;
uniform float radius = 0.5;
uniform float e = 2.0;
uniform float m = 2.0;
uniform float s = 2.0;
uniform float d = 2.0;


void vertex() {
	VERTEX = (inverse(MODELVIEW_MATRIX) * vec4(VERTEX,0.0)).rgb;
}

void fragment() {
	float dist = distance(UV,vec2(0.5));
	ALPHA *= pow(dist/radius,e)*radius*m;
	ALPHA = clamp(ALPHA, 0.0, 1.0);
	ALPHA = 1.0-ALPHA;
	EMISSION = vec3(2.0,2.0,0.0);
	vec2 dir_vector = (vec2(0.5, 0.5)-UV)*2.0;
	float angle = atan(dir_vector.y, dir_vector.x)/6.0;
	ALPHA *= step(texture(noise, vec2(angle,angle+dist*d-TIME*0.05)).r, s)*0.6 + 0.02;
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
