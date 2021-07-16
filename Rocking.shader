shader_type canvas_item;

uniform float speed = 1.0;
uniform float amplitude = 1.0;
uniform float vertical : hint_range(0.1, 0.9);


vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float cosa = cos(rotation);
    float sina = sin(rotation);
	vec2 uvOriginal=uv;
	uvOriginal -= pivot;
    return vec2(
        cosa * uvOriginal.x - sina * uvOriginal.y,
        cosa * uvOriginal.y + sina * uvOriginal.x 
    ) + pivot;
}

void fragment(){
	//COLOR = (UV.y < 0.5) ? texture(TEXTURE, UV) : vec4(0);
}

void vertex() {
    //VERTEX = rotateUV(VERTEX, vec2(0.5), TIME * speed);
	float rotation_ang = sin(TIME*speed);
	//rotation_ang=rotation_ang*rotation_ang*rotation_ang;
	float rotation = rotation_ang*amplitude;
	VERTEX = rotateUV(VERTEX, vec2(0, vertical)/TEXTURE_PIXEL_SIZE, rotation);
}