shader_type canvas_item;
uniform sampler2D gradient: hint_black;
// alpha = 1 always color,0 trasnparent

void fragment() {
    vec2 uv = vec2(UV.x*2.0 -0.5 , UV.y);
     uv.x = uv.x * SCREEN_UV.x/SCREEN_UV.y;

    vec4 bg = texture(TEXTURE, UV);
    float alpha = bg.a;
    float drw = sin(uv.x + TIME*-10.0)*0.9+2.1;
    vec4 sample_color = texture(gradient, UV);
    if (alpha > 0.0){
        bg = (bg + sample_color);
        alpha = clamp((alpha*drw),0.0,1.0);
        COLOR = vec4(bg.rgb, alpha);
       } else {
          COLOR = bg;
       }
   
 
   }