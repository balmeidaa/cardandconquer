shader_type canvas_item;

uniform vec4 line_color : hint_color = vec4(1);
uniform float line_thickness : hint_range(0, 10) = 1.0;
uniform float shine_speed : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float shine_size : hint_range(0.01, 1.0, 0.01) = 0.01;
uniform vec4 shine_color : hint_color = vec4(1.0);
uniform bool active =  true;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    if(active){
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness / 2.0;
	float l = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	float u = texture(TEXTURE, UV + vec2(0, size.y)).a;
	float r = texture(TEXTURE, UV + vec2(size.x, 0)).a;
	float d = texture(TEXTURE, UV + vec2(0, -size.y)).a;
	float lu = texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	float ru = texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	float ld = texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	float rd = texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	
	float outline = min(1.0, l+r+u+d+lu+ru+ld+rd) - color.a;
	float inline = (1.0 - l * r * u * d * lu * ru * rd * ld) * color.a;
	
	vec4 outlined_result = mix(color, line_color, outline + inline);
      
	float shine = step(1.0 - shine_size * 0.5, 0.5 + 0.5 * sin(UV.x - UV.y + TIME * shine_speed));
    outlined_result.rbg = mix(outlined_result.rgb, shine_color.rgb, (outline + inline) * shine_color.a * shine);
    
	COLOR = mix(color, outlined_result, outlined_result.a);
    }
    else{
        COLOR = color;
       }
}
