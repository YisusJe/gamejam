shader_type canvas_item;

void fragment(){
    vec4 pixelColor = texture(TEXTURE, UV);

	vec4 output = vec4(0.0, 0.0, 0.0, 1.0);

	if(pixelColor.x > 0.8) {
		float step = (pixelColor.x - 0.8) / 0.2; 

		output = mix(vec4(0.0, 0.0, 0.0, 1.0), vec4(0.0, 0.007, 0.13, 1.0), step);
	};

	COLOR = output;
}