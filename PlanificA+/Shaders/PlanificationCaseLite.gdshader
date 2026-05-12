shader_type canvas_item;

// La force de l'éclaircissement (0.0 = pas de changement, 1.0 = blanc pur en haut)
uniform float light_strength : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    // 1. Récupérer la texture et la couleur de modulation de base
    vec4 tex = texture(TEXTURE, UV);
    vec4 base_color = tex * COLOR;
    
    // 2. Calculer le facteur d'éclaircissement
    // UV.y vaut 0.0 en haut et 1.0 en bas.
    // (1.0 - UV.y) inversé donne 1.0 en haut et 0.0 en bas.
    float light_factor = (1.0 - UV.y) * light_strength;
    
    // 3. Mélanger la couleur de base vers le blanc (ou une couleur plus claire)
    // On ajoute le facteur aux composantes RGB pour éclaircir
    vec3 light_rgb = base_color.rgb + light_factor;
    
    // 4. Appliquer la couleur finale
    // On utilise clamp pour éviter de dépasser la valeur 1.0 (blanc maximum)
    COLOR = vec4(clamp(light_rgb, 0.0, 1.0), base_color.a);
}
