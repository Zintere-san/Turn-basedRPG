shader_type canvas_item;

uniform float pixelate_amount : hint_range(0.0, 1.0) = 0.0;
uniform float explode_amount : hint_range(0.0, 1.0) = 0.0;
uniform float dodge_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 uv = UV;

    // 💥 Pixelate (for death)
    float pixel_size = mix(1.0 / 512.0, 1.0 / 8.0, pixelate_amount);
    uv = floor(uv / pixel_size) * pixel_size;

    // 💨 Snappy Whoosh Dodge Effect (more intense movement)
    uv.x += dodge_amount * 0.6; // Faster slide right
    uv.y += sin(UV.x * 15.0) * dodge_amount * 0.05; // sharper wave distortion

    // 💣 Explode (for death)
    vec2 center = vec2(0.5);
    vec2 dir = uv - center;
    uv += dir * explode_amount * 0.3;

    vec4 tex = texture(TEXTURE, uv);

    // Fade out on explode
    tex.a *= 1.0 - explode_amount;

    COLOR = tex;
}
