#version 100

uniform mat4 viewProjectionMatrix;
attribute vec2 pos;

void main() {
	gl_Position = viewProjectionMatrix * vec4(pos, 0.0, 1.0);
}