shader_type canvas_item;

uniform sampler2D noise_img1;
uniform sampler2D noise_img2;
uniform sampler2D noise_img3;
uniform float speed = 1.0;
uniform vec4 tint : hint_color;

void fragment(){
	vec2 uv1 = vec2(UV.x + TIME*speed, UV.y);
	vec2 uv2 = vec2(UV.x - TIME*speed, UV.y + TIME*speed);
	vec2 uv3 = vec2(UV.x, UV.y - TIME*speed);
	
	
	float noise_r = texture( noise_img1, uv1 ).r;
	float noise_g = texture( noise_img2, uv2 ).g;
	float noise_b = texture( noise_img3, uv3 ).b;
	
	vec3 new_color = vec3(noise_r, noise_g, noise_b);
	
	float multiplier = noise_r * noise_g * noise_b;
	vec3 white = vec3(1, 1, 1);
	
	COLOR.rgb = tint.rgb + 13.0 * ((multiplier*multiplier*multiplier) * white);
}