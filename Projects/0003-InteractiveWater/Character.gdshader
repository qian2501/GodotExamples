shader_type canvas_item;

// 从CPU传递的深度值（0-1）
uniform float depth_value = 0.5;

// 染色颜色
uniform vec4 tint_color : source_color = vec4(0.6, 0.6, 1.0, 1.0);

// 白线参数
uniform float line_width : hint_range(0.0, 0.1) = 0.02;
uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float waveSize = 20.0;
uniform float waveStrength = 4.0;
uniform float waveSpeed = 4.0;

vec2 randVec2(vec2 uv, float time) {
    float x = sin(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453123 + time);
    float y = sin(sin(dot(uv, vec2(58.156,34.4164))) * 56368.6514632 + time);

    return vec2(x, y);
}

float perlin(vec2 uv) {
    vec2 gridId = floor(uv);
    vec2 gridUv = fract(uv);

    vec2 randVec[4] = {
        randVec2(gridId + vec2(0.0, 0.0), waveSpeed * TIME),
        randVec2(gridId + vec2(1.0, 0.0), waveSpeed * TIME),
        randVec2(gridId + vec2(0.0, 1.0), waveSpeed * TIME),
        randVec2(gridId + vec2(1.0, 1.0), waveSpeed * TIME)
    };

    vec2 pixelVec[4] = {
        gridUv - vec2(0.0, 0.0),
        gridUv - vec2(1.0, 0.0),
        gridUv - vec2(0.0, 1.0),
        gridUv - vec2(1.0, 1.0)
    };

    float value[4] = {
        dot(randVec[0], pixelVec[0]),
        dot(randVec[1], pixelVec[1]),
        dot(randVec[2], pixelVec[2]),
        dot(randVec[3], pixelVec[3])
    };

    gridUv = smoothstep(0.0, 1.0, gridUv);

    return mix(mix(value[0], value[1], gridUv.x), mix(value[2], value[3], gridUv.x), gridUv.y);
}

float fBmPerlin(vec2 uv) {
    float value = 0.0;
    float amplitude = 1.0;

    for (int i = 0; i < 4; i++) {
        value = value + perlin(uv) * amplitude;
        amplitude *= 0.5;
        uv *= 2.0;
    }

    return value;
}

void fragment() {
	float vertical_pos = 1.0 - UV.y;
	
    vec2 uv = UV;
    if (vertical_pos < depth_value) {
        // UV manipulation for waving effect
        vec2 noise = vec2(
            fBmPerlin(UV / TEXTURE_PIXEL_SIZE / waveSize),
            fBmPerlin(UV / TEXTURE_PIXEL_SIZE / waveSize + vec2(2.3, 6.1))
        ) * waveStrength;

        uv = uv + noise * TEXTURE_PIXEL_SIZE;
    }

	vec4 color = texture(TEXTURE, uv);

    if (vertical_pos > depth_value - line_width && vertical_pos < depth_value) {
        color = line_color;
    } else if (vertical_pos < depth_value) {
        color *= tint_color;
    }

	COLOR = color;
}
