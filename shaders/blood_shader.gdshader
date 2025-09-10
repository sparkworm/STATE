shader_type canvas_item;

uniform sampler2D noise;
uniform vec2 dimensions;
uniform float alpha=1;

// Called for every vertex the material is visible on.
void vertex() {
}

// Called for every pixel the material is visible on.
void fragment() {
	vec2 pixel_uv = floor(UV*dimensions)/dimensions;
	// necessary if using something like a spritesheet
	float asp_ratio = dimensions.y / dimensions.x;
	float noise_val = texture(noise, vec2(pixel_uv.x,pixel_uv.y*asp_ratio)).x;
	//noise_val += 0.3;
	noise_val = 1.0 / noise_val;
	noise_val *= pow(noise_val,-2.0);
	noise_val *= alpha;
	float dist = distance(pixel_uv, vec2(0.5));
	//noise_val = 1.0-noise_val;
	//noise_val = pow(noise_val,2);
	//noise_val = smoothstep(0.3, 0.4, noise_val) * noise_val;
	COLOR.rgb -= noise_val;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
