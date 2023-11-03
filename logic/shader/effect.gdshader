shader_type canvas_item;

uniform bool white_color_effect = false;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	
	if (white_color_effect) {
		COLOR = white_color;
	} else {
		COLOR = previous_color;	
	}
}
