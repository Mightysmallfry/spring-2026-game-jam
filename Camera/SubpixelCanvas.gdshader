shader_type canvas_item;

uniform vec2 cam_offset = vec2(0.0, 0.0);

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX += cam_offset;
}

