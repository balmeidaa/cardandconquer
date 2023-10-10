shader_type canvas_item;

float remove_black(vec4 color){
    if (color.r == 0.0 && color.b == 0.0 && color.g == 0.0){
        return 0.0;
       }
    return color.a;
   }

void fragment() {
    vec4 bg = texture(TEXTURE, UV);

    bg.a = remove_black(bg);

    COLOR = bg;
 
   }