shader_type canvas_item;

uniform vec4 color_start : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Red
uniform vec4 color_end : source_color = vec4(0.0, 0.0, 1.0, 1.0);   // Blue
uniform float gradient_angle : hint_range(0.0, 360.0) = 30.0; // Angle in degrees

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv_rotated = UV;
    // Normalize angle to radians
	float angle_rad = radians(gradient_angle);

    // Rotate UV coordinates around the center of the button
	vec2 center = vec2(0.5, 0.5);
	mat2 rot_matrix = mat2(
		vec2(cos(angle_rad), sin(angle_rad)),
		vec2(-sin(angle_rad),  cos(angle_rad))
	);
	uv_rotated = rot_matrix * (UV - center) + center;

    // Calculate mix factor based on the rotated UV's x-component
    // (for a horizontal gradient relative to the rotated axis)
	float mix_factor = clamp(uv_rotated.x, 0.0, 1.0);

    // Interpolate between start and end colors
	COLOR = mix(color_start, color_end, mix_factor);
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
