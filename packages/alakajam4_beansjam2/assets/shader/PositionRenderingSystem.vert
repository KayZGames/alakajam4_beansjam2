#version 100

uniform mat4 viewProjectionMatrix;
attribute vec2 pos;
attribute vec4 aColor;
varying vec4 vColor;

void main() {
	gl_Position = viewProjectionMatrix * vec4(pos, 0.0, 1.0);
	vColor = aColor;
}