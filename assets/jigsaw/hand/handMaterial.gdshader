shader_type canvas_item;

uniform sampler2D u_screenSpace : filter_nearest, repeat_enable;

uniform vec2 u_gridOffset;
uniform float u_pointSize = 0.1;
uniform float u_edgeSize = 0.05;

uniform vec3 pointColor : source_color;
uniform vec3 edgeColor : source_color;

void fragment() {
	vec2 screenPos = (SCREEN_UV * (vec2(1.0) / SCREEN_PIXEL_SIZE)) + u_gridOffset;
	vec2 worldPos = screenPos / 64.0;
	vec4 screenColor = texture(u_screenSpace, screenPos / 256.0);
	
	float r = mod(worldPos.x, 1.0f);
	float g = mod(worldPos.y, 1.0f);
	r = max(r, 1.0f - r);
	g = max(g, 1.0f - g);
	
	float points = step(1.0f - u_pointSize, r) * step(1.0f - u_pointSize, g);
	float edges = step(1.0f - u_edgeSize, r) + step(1.0f - u_edgeSize, g);
	
	vec3 color = mix(mix(COLOR.rgb, edgeColor, edges), pointColor, points);
	
	COLOR = vec4(color * screenColor.rgb, COLOR.a);
}

