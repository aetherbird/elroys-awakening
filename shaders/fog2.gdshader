shader_type canvas_item;

// Credit for the original shader goes to Gonkee: https://github.com/Gonkee/Gonkees-Shaders/blob/master/fog.shader
// Pixelate by Godot Shaders: https://godotshaders.com/shader/pixelate/

uniform vec4 color : source_color;
uniform int OCTAVES = 4;
uniform bool enable_pixelation = true;
uniform int pixelation_amount = 150;
uniform sampler2D fog_mask;  // Texture mask for fog control
uniform vec2 fog_direction = vec2(1.0, 1.0); // Use -1 and 1 values to change direction. Increase the speed in that direction with values higher/lower than 1
uniform bool scroll_noise_tex = true; 
uniform vec2 noise_scroll_direction = vec2(0.1, 0.0);  // Direction to scroll the noise texture
uniform float scroll_speed = 0.05;  // Control the speed of scrolling

float rand(vec2 coord){
    return fract(sin(dot(coord, vec2(56, 78)) * 1000.0) * 1000.0);
}

float noise(vec2 coord){
    vec2 i = floor(coord);
    vec2 f = fract(coord);

    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));

    vec2 cubic = f * f * (3.0 - 2.0 * f);

    return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float fbm(vec2 coord){
    float value = 0.0;
    float scale = 0.5;
    float total_scale = 0.0;

    for(int i = 0; i < OCTAVES; i++){
        value += noise(coord) * scale;
        total_scale += scale;
        coord *= 1.6;
        scale *= 0.55;
    }
    return value / total_scale;
}

void fragment() {
    vec2 grid_uv = UV;
    if (enable_pixelation) {
        grid_uv = round(UV * float(pixelation_amount)) / float(pixelation_amount);
    }
    
    vec2 coord = grid_uv * 15.0;

    // Scroll the noise texture slowly
    if (scroll_noise_tex) {
        coord += noise_scroll_direction * TIME * scroll_speed;  // Slow scrolling based on time
    }

    vec2 motion = vec2(fbm(coord + fog_direction * TIME * 0.2));  // Slow, smooth motion

    float final = fbm(coord + motion);

    final = pow(final, 1.5);  // Softens and rounds the noise

    float mask_value = texture(fog_mask, UV).r;
    
    final *= mask_value;

    COLOR = vec4(color.rgb, final * color.a * 0.6);
}
