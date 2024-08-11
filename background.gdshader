shader_type canvas_item;

uniform vec4 color_1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_2 : source_color = vec4(0.0, 0.007, 0.13, 1.0);
uniform vec4 color_3 : source_color = vec4(0.0, 0.007, 0.13, 1.0);

uniform vec2 wave_direction = vec2(2.0,0.0);
uniform vec2 wave_2_direction = vec2(0.0,1.0);
uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.025;
uniform float color_2_threshold : hint_range(0.0, 1.0, 0.005) = 0.5;
uniform float color_3_threshold : hint_range(0.0, 1.0, 0.005) = 0.2;

uniform sampler2D texture_normal : repeat_enable;
uniform sampler2D texture_normal2 : repeat_enable;

uniform float wave_count : hint_range(1.0, 20.0, 1.0) = 20.0;
uniform float speed : hint_range(0.0, 10.0, 0.1) = 3.0;
uniform float height : hint_range(0.0, 0.1, 0.001) = 0.003;

void fragment() {
	// Time calculations for wave (normal map) movement
	vec2 time = (TIME * wave_direction) * time_scale;
	vec2 time2 = (TIME * wave_2_direction) * time_scale;
	vec2 real_uvs = vec2(UV.x / 128.0, UV.y / 128.0);

	real_uvs.x += sin(TIME * time_scale + (real_uvs.x + real_uvs.y) * 25.0) * 0.01;
	real_uvs.y += cos(TIME * time_scale + (real_uvs.x + real_uvs.y) * 25.0) * 0.01;

	// vec2 cPos = -1.0 + 2.0 * real_uvs / (1.0 / TEXTURE_PIXEL_SIZE);
	// float cLength = length(cPos);
	// vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy + (cPos/cLength) * cos(cLength * wave_count - TIME * speed) * height;
    
	vec4 pixelColor = mix(texture(texture_normal,real_uvs + time).rgba, texture(texture_normal2,real_uvs + time2).rgba, 0.5);
	vec4 output = color_1;

	if(pixelColor.x >= color_2_threshold) {
		float step = (pixelColor.x - color_2_threshold) / color_2_threshold; 

		output = mix(color_1, color_2, step);
	} else if(pixelColor.x <= color_3_threshold) {
		float step = 1.0 - (pixelColor.x / color_3_threshold); 

		output = mix(color_1, color_3, step);
	};

	COLOR = output;
}