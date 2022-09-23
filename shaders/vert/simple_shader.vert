// GLSL VERSION
#version 450

// HARD CODING SOME VERTEXES
vec2 positions[3] = vec2[] (
    vec2 (0.0, -0.5),
    vec2 (0.5, 0.5),
    vec2 (-0.5, 0.5)
);

// MAIN FUNCTION
void main() {
    // GIVING VALUES TO THE OUTPUT VARIABLE
    gl_Position = vec4(positions[gl_VertexIndex], 0.0, 1.0);
}