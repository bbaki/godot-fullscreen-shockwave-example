shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 shockwave_positions[8];
uniform float shockwave_progresses[8];
uniform int shockwave_count = 0;
uniform float shockwave_strength = 0.05;
uniform float shockwave_speed = 0.5;
uniform float shockwave_width = 0.1;
uniform float chroma_strength = 0.005;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 total_offset = vec2(0.0);
    vec2 chroma_offset = vec2(0.0);

    for (int i = 0; i < shockwave_count && i < 8; i++) {
        float progress = shockwave_progresses[i];
        if (progress > 0.0 && progress <= 1.5) {
            vec2 dir = uv - shockwave_positions[i];
            float dist = length(dir);
            float radius = progress * shockwave_speed;

            float wave = smoothstep(radius - shockwave_width, radius, dist) *
                         smoothstep(radius + shockwave_width, radius, dist);
            float falloff = exp(-dist * 10.0);

            vec2 norm_dir = normalize(dir);
            total_offset += norm_dir * wave * shockwave_strength * falloff;
            chroma_offset += norm_dir * wave * chroma_strength * falloff;
        }
    }

    // Sample with chromatic aberration (R, G, B channels have slightly different UVs)
    vec3 col;
    col.r = texture(screen_texture, clamp(uv + total_offset + chroma_offset, vec2(0.0), vec2(1.0))).r;
    col.g = texture(screen_texture, clamp(uv + total_offset, vec2(0.0), vec2(1.0))).g;
    col.b = texture(screen_texture, clamp(uv + total_offset - chroma_offset, vec2(0.0), vec2(1.0))).b;

    COLOR.rgb = col;
}
