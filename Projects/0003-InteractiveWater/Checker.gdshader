shader_type canvas_item;

// 棋盘格颜色
uniform vec4 color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// 棋盘格大小
uniform float checker_size = 5.0;

void fragment() {
	// 根据UV坐标计算棋盘格图案
	vec2 uv = UV / checker_size;
	
	// 使用floor函数创建整数坐标
	vec2 cell = floor(uv);
	
	// 计算奇偶性：如果x+y是偶数，使用color_a，否则使用color_b
	float pattern = mod(cell.x + cell.y, 2.0);
	
	// 根据pattern值选择颜色
	vec4 final_color = mix(color1, color2, pattern);
	
	// 输出颜色
	COLOR = final_color;
}
