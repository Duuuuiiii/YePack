#version 330

#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;
in vec2 texCoord0;
in vec3 skyRay;
out vec4 fragColor;

const float PI = 3.141592653589793;
const ivec2 PANORAMA_SIZE = ivec2(3074, 1536);

void main() {
    vec2 uv = texCoord0;
    // Keep normal UV sampling for Nuit square textures from other packs.
    if (all(equal(textureSize(Sampler0, 0), PANORAMA_SIZE))) {
        vec3 direction = normalize(skyRay);
        float longitude = atan(direction.z, direction.x);
        float latitude = asin(clamp(direction.y, -1.0, 1.0));
        float u = (longitude / (2.0 * PI) + 0.5) * 3072.0 + 1.0;
        uv = vec2(u / 3074.0, 0.5 - latitude / PI);
    }
    vec4 color = texture(Sampler0, uv);
    if (color.a == 0.0) discard;
    fragColor = color * ColorModulator;
}
