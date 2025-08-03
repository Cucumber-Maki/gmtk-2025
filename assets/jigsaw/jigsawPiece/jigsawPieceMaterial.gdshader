shader_type canvas_item;

uniform vec2 u_gridOffset;
uniform sampler2D u_screenSpace : filter_nearest, repeat_enable;

uniform vec3 u_color : source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
	vec2 screenPos = (SCREEN_UV * (vec2(1.0) / SCREEN_PIXEL_SIZE)) + u_gridOffset;
	vec2 worldPos = screenPos / 256.0;
	vec4 screenColor = texture(u_screenSpace, worldPos);
	
	vec4 baseColor = texture(TEXTURE, UV);
	vec3 col = baseColor.rgb * u_color * screenColor.rgb;
	COLOR *= vec4(col, baseColor.a);
}