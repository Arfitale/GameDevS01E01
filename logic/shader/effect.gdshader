shader_type canvas_item;

uniform bool hit_effect = false;
uniform vec3 hit_color: source_color;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 hit_color_effect = vec4(hit_color.r, hit_color.g, hit_color.b, previous_color.a);
	
	if (hit_effect) {
		COLOR = hit_color_effect;
	} else {
		COLOR = previous_color;	
	}
}
