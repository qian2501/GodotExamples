shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform int size = 9;

void fragment() {
	vec4 origin = texture(SCREEN_TEXTURE, SCREEN_UV);
    float offset = float(size) / 2.0;
    vec4 result = vec4(0.0);
	vec4 amount = vec4(0.0);

    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            amount = texture(
                SCREEN_TEXTURE,
                SCREEN_UV + vec2(
                    SCREEN_PIXEL_SIZE.x * float(i) - SCREEN_PIXEL_SIZE.x * float(offset), 
                    SCREEN_PIXEL_SIZE.y * float(j) - SCREEN_PIXEL_SIZE.y * float(offset)
                )
            );

			vec3 filtered = vec3(0.0);
			if (amount.r > 1.0) filtered.r = amount.r;
			if (amount.g > 1.0) filtered.g = amount.g;
			if (amount.b > 1.0) filtered.b = amount.b;
			amount = vec4(filtered, 1.0);

			result += amount;
        }
    }

    result = result / float(size) / float(size);
	
	COLOR = vec4(origin.rgb + result.rgb, origin.a);
}
