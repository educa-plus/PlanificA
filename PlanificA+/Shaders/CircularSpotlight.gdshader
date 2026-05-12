shader_type canvas_item;

uniform vec2 target_pos;   // Centre du cercle (en pixels)
uniform float target_radius; // Rayon du cercle (en pixels)
uniform float feather : hint_range(0.0, 50.0) = 5.0;

void fragment() {
    vec2 current_pixel = FRAGCOORD.xy;
    
    // Calcul de la distance réelle entre le pixel et le centre
    float d = length(current_pixel - target_pos);
    
    // On soustrait le rayon pour que la "distance" soit 0 au bord du cercle, 
    // négative à l'intérieur (trou) et positive à l'extérieur.
    float dist_to_edge = d - target_radius;
    
    // Créer le masque fluide
    float mask = smoothstep(-feather, feather, dist_to_edge);
    
    COLOR.a *= mask;
}
