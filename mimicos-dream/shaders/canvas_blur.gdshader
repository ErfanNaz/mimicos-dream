shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_size : hint_range(0.0, 20.0) = 5.0;

void fragment() {
    vec2 p = SCREEN_PIXEL_SIZE * blur_size;

    vec4 color = vec4(0.0);

    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-p.x, -p.y));
    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2( 0.0, -p.y));
    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2( p.x, -p.y));

    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-p.x,  0.0));
    color += texture(SCREEN_TEXTURE, SCREEN_UV);
    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2( p.x,  0.0));

    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-p.x,  p.y));
    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2( 0.0,  p.y));
    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2( p.x,  p.y));

    COLOR = color / 9.0;
}