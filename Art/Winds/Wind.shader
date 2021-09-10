shader_type particles;
uniform vec3 overallVelocity;
uniform sampler2D map;
uniform float spawnDistance;
uniform vec2 spawnOrigin;

uniform float scale = 1;
uniform float scale_random = 0;

const float PI = 3.14159265358979323846;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

float rand_from_seed(inout uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
	s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
		s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

void vertex() {
	uint alt_seed = hash(NUMBER + uint(1) + RANDOM_SEED);
	float scale_rand = rand_from_seed(alt_seed);
	
	
	//spawn at random location
	if (RESTART){
		float x = (rand(vec2(float(NUMBER) + TIME, 0.0)) - 0.5) * 2.0;
		float y = (rand(vec2(float(NUMBER) + TIME + 1.0, 0.0)) - 0.5) * 2.0;
		TRANSFORM[3][0] = spawnOrigin[0] + x * spawnDistance;
		TRANSFORM[3][1] = spawnOrigin[1] + y * spawnDistance;
	}
	float angle = (texture(map, vec2(TRANSFORM[3][0], TRANSFORM[3][1]) / 512.0).r - 0.5) * PI / 3.0;
	//float newx = (VELOCITY.x + (overallVelocity.x * cos(angle) - overallVelocity.y * sin(angle)) / 5.0);
	//float newy = (VELOCITY.y + (overallVelocity.x * sin(angle) + overallVelocity.y * cos(angle)) / 5.0);
	//VELOCITY = normalize(vec3(newx, newy, 0.0)) * length(overallVelocity);
	float newx = (overallVelocity.x + (overallVelocity.x * cos(angle) - overallVelocity.y * sin(angle)));
	float newy = (overallVelocity.y + (overallVelocity.x * sin(angle) + overallVelocity.y * cos(angle)));
	VELOCITY = vec3(newx, newy, 0.0);
	//COLOR.rgb = vec3(angle+0.5);
	float facing = - PI/2.0 - atan(overallVelocity.y, overallVelocity.x) - angle;
	//set rotation to match velocity
	TRANSFORM[0][0] =   cos(facing); //
	TRANSFORM[0][1] = - sin(facing); //
	TRANSFORM[1][0] =   sin(facing); //
	TRANSFORM[1][1] =   cos(facing); //
	
	float scaling = scale + (scale_random * (scale_rand - 0.5) * 2.0);
	//scale down the transformation matrix
	TRANSFORM[0][0] = TRANSFORM[0][0] * scaling; //
	TRANSFORM[0][1] = TRANSFORM[0][1] * scaling; //
	TRANSFORM[1][0] = TRANSFORM[1][0] * scaling; //
	TRANSFORM[1][1] = TRANSFORM[1][1] * scaling; //
	
	//snap around visibilityrectangle edges to make it look better
	TRANSFORM[3][0] = mod(TRANSFORM[3][0], 2560);
	TRANSFORM[3][1] = mod(TRANSFORM[3][1], 2560);
}