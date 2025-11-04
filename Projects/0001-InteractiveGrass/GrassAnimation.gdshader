shader_type canvas_item;

uniform vec2 frameCount;

varying float pressure;

void vertex() {
	pressure = clamp(INSTANCE_CUSTOM.r, -1.0, 1.0);
}

void fragment() {
	vec2 uv = UV / frameCount;
	uv.x += floor(frameCount.x * (pressure + 1.0) / 2.0) / frameCount.x;

	COLOR = texture(TEXTURE, uv);
}