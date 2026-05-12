shader_type canvas_item;

uniform vec2 target_pos;  // Centre de la cible (en pixels)
uniform vec2 target_size; // Taille de la cible (en pixels)
uniform float feather : hint_range(0.0, 50.0) = 5.0; // Adoucissement des bords

void fragment() {
    vec2 current_pixel = FRAGCOORD.xy;
    // Calcul de la distance par rapport aux bords du rectangle cible
    vec2 low = target_pos - (target_size / 2.0);
    vec2 high = target_pos + (target_size / 2.0);
    // Déterminer si le pixel est à l'intérieur du rectangle
    float d_x = max(low.x - current_pixel.x, current_pixel.x - high.x);
    float d_y = max(low.y - current_pixel.y, current_pixel.y - high.y);
    float distance = max(d_x, d_y);

    // Créer le masque (0 = trou, 1 = noir)
    float mask = smoothstep(-feather, feather, distance);
    // Appliquer la couleur du ColorRect avec l'opacité du masque
    COLOR.a *= mask;
}
