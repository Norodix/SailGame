shader_type canvas_item;

uniform sampler2D wavemap;
uniform sampler2D wake;
uniform float speed = 1.0;
uniform float strength=0.7;
uniform vec4 tint : hint_color;

vec3 rgb2hsb( in vec3 c ){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                 vec4(c.gb, K.xy),
                 step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                 vec4(c.r, p.yzx),
                 step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}

vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                             6.0)-3.0)-1.0,
                     0.0,
                     1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

float ridgenoise(float x){
	return 2.0 * (0.5-abs(0.5-x));
}

float waveNoise(in vec2 uv, float time){
	vec2 uv1 = mod(vec2(uv.x + time*speed, uv.y), vec2(1.0, 1.0));
	vec2 uv2 = mod(vec2(uv.x - time*speed, uv.y + time*speed), vec2(1.0, 1.0));
	vec2 uv3 = mod(vec2(uv.x, uv.y - time*speed), vec2(1.0, 1.0));
	
	float noise_r = ridgenoise(texture(wavemap, uv1).r);
	float noise_g = ridgenoise(texture(wavemap, uv2).g);
	float noise_b = ridgenoise(texture(wavemap, uv3).b);
	
	vec3 new_color = vec3(noise_r, noise_g, noise_b);
	
	float multiplier = noise_r * noise_g * noise_b;
	float newMultiplier = strength * (multiplier*multiplier*multiplier*multiplier);

	return clamp(0., 1., newMultiplier);
}

void fragment(){
	float waveVal = waveNoise(UV, TIME);
	//float wakeVal = texture(wake, UV).x;
	
	
//	float p = waveNoise(UV, TIME);
//	float h1 = waveNoise(UV + vec2(SCREEN_PIXEL_SIZE.x, 0.), TIME);
//	float v1 = waveNoise(UV + vec2(0., SCREEN_PIXEL_SIZE.y), TIME);
//
//	vec2 norm = (vec2(p) - vec2(h1, v1)) * 3.5 + vec2(0.5);
   	//return (p - vec2(h1, v1));
	
//	vec3 white = vec3(1, 1, 1);
	
	vec3 tint_hsb = rgb2hsb(tint.rgb);
	tint_hsb.y -= waveVal;
	tint_hsb.z -= (0.12-waveVal);
	
	COLOR.rgb = hsb2rgb(tint_hsb);
	//COLOR.rgb= vec3(wakeVal);
	//COLOR.rgb = tint.rgb;
	//NORMAL = vec3(norm, 1.) * vec3(2., 2., 1.) - vec3(1., 1., 0.);
	//COLOR.rgb = vec3(norm, 1.);
}