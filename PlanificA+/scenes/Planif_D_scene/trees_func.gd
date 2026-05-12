extends MarginContainer

var PDA = {
	"Secondaire 1": [
		"Propriétés de la matière (masse, volume, température)",
		"Changements d'état de la matière (fusion, vaporisation, condensation, solidification)",
		"Acidité et basicité des solutions",
		"Propriétés caractéristiques des substances (densité, solubilité)",
		"Transformations physiques et chimiques de la matière",
		"Structure de la matière (atomes, molécules, éléments)",
		"Classification périodique des éléments",
		"Forces et mouvements (types de mouvements, effets d'une force)",
		"Machines simples (leviers, plans inclinés, roues)",
		"Techniques de séparation des mélanges (filtration, décantation, évaporation)",
		"Techniques de mesure (masse, volume, température)",
		"Stratégies d'exploration (formulation d'hypothèses, schématisation)"
	],
	"Secondaire 2": [
		"Propriétés des solutions (concentration, électrolytes, pH)",
		"Transformations chimiques (réactions de combustion, neutralisation, précipitation)",
		"Transformations nucléaires (radioactivité, fission, fusion)",
		"Transformations de l'énergie (formes d'énergie, loi de la conservation de l'énergie)",
		"Structure de la matière (modèle atomique de Rutherford-Bohr, notation de Lewis)",
		"Classification périodique (numéro atomique, isotopes, masse atomique relative)",
		"Fluides (pression, compressibilité, relation pression-volume)",
		"Ondes (fréquence, longueur d'onde, amplitude, spectre électromagnétique)",
		"Électricité (charge électrique, loi d'Ohm, circuits électriques)",
		"Techniques de conception et de fabrication d'environnements (terrarium, aquarium)",
		"Stratégies d'analyse (diviser un problème complexe, raisonner par analogie)"
	],
	"Secondaire 3": [
		"Diversité de la vie (écologie, niche écologique, espèces, populations)",
		"Adaptations physiques et comportementales des êtres vivants",
		"Évolution et taxonomie (sélection naturelle, classification des vivants)",
		"Génétique (hérédité, gènes, chromosomes, ADN)",
		"Maintien de la vie (cellules végétales et animales, photosynthèse, respiration)",
		"Systèmes biologiques (digestif, respiratoire, circulatoire, excréteur)",
		"Reproduction (asexuée et sexuée, organes reproducteurs, fécondation)",
		"Division cellulaire (mitose, méiose, diversité génétique)",
		"Phénomènes géologiques (tectonique des plaques, orogenèse, volcanisme)",
		"Phénomènes astronomiques (gravitation, système Terre-Lune, lumière)",
		"Techniques de préparation de solutions (concentration, dilution)",
		"Stratégies de communication (organiser les données, échanger des informations)"
	],
	"Secondaire 4": [
		"Dynamique des écosystèmes (relations trophiques, productivité primaire, flux de matière et d'énergie)",
		"Écotoxicologie (contaminants, bioaccumulation, seuil de toxicité)",
		"Génétique (génotype, phénotype, synthèse des protéines)",
		"Systèmes nerveux et musculosquelettique (neurones, influx nerveux, muscles, os)",
		"Reproduction humaine (puberté, régulation hormonale, contraception)",
		"Phénomènes géologiques (érosion, cycle de l'eau, ressources énergétiques)",
		"Phénomènes astronomiques (système solaire, éclipses, saisons, comètes)",
		"Techniques de fabrication (usinage, assemblage, finition)",
		"Techniques de mesure avancées (pied à coulisse, ampéremètre)",
		"Stratégies d'analyse (sélection de critères, généralisation à partir de cas particuliers)"
	],
	"Secondaire 4 STE": [
		"Biotechnologie (pasteurisation, fabrication de vaccins, procréation médicalement assistée)",
		"Transformations génétiques (organismes génétiquement modifiés, clonage)",
		"Traitement des eaux usées et biodégradation des polluants",
		"Ingénierie électrique (fonctions d'alimentation, conduction, isolation, transformation de l'énergie)",
		"Matériaux (propriétés mécaniques, traitements thermiques, matériaux composites)",
		"Fabrication (cahier des charges, gamme de fabrication, techniques de montage et démontage)",
		"Techniques de vérification et contrôle (utilisation d'instruments de mesure, interprétation des résultats)",
		"Stratégies de communication (représentation des données, confrontation d'explications)"
	]
};
var PFEQ = {
		"Français, langue d'enseignement": [
			"Compétence 1 : Lire et apprécier des œuvres littéraires et des documents variés.",
			"Compétence 2 : Écrire des textes variés en fonction de la situation de communication.",
			"Compétence 3 : Communiquer oralement en fonction de la situation de communication."
		],
		"Mathématiques": [
			"Compétence 1 : Résoudre des problèmes en utilisant des concepts et des procédures mathématiques.",
			"Compétence 2 : Utiliser des outils technologiques pour résoudre des problèmes mathématiques.",
			"Compétence 3 : Communiquer des raisonnements et des résultats mathématiques."
		],
		"Sciences et technologie": [
			"Compétence 1 : Chercher des réponses ou des solutions à des problèmes d'ordre scientifique ou technologique.",
			"Compétence 2 : Mettre à profit ses connaissances scientifiques et technologiques.",
			"Compétence 3 : Communiquer à l'aide des langages utilisés en science et technologie."
		],
		"Histoire et éducation à la citoyenneté": [
			"Compétence 1 : Interpréter des documents historiques.",
			"Compétence 2 : Expliquer des phénomènes historiques.",
			"Compétence 3 : Exprimer son point de vue sur des enjeux historiques."
		],
		"Arts plastiques": [
			"Compétence 1 : Créer des œuvres en utilisant des procédés et des matériaux variés.",
			"Compétence 2 : Interpréter des œuvres d'art.",
			"Compétence 3 : Communiquer par l'art."
		],
		"Éthique et culture religieuse": [
			"Compétence 1 : Réfléchir sur des questions éthiques.",
			"Compétence 2 : S'ouvrir à la diversité culturelle et religieuse.",
			"Compétence 3 : Exprimer son point de vue sur des questions éthiques et religieuses."
		],
		"Éducation physique et à la santé": [
			"Compétence 1 : Agir en fonction de ses capacités physiques.",
			"Compétence 2 : Adopter des comportements favorables à la santé.",
			"Compétence 3 : Interagir de manière harmonieuse avec les autres."
		]
}

@onready var TreesPaths: Array[NodePath] = []

var infos: Dictionary = {PDA: "Progression Des Apprentissages", PFEQ: "Programme de Formation de l'École Québécoise"}
var ShortInfos: Dictionary = {PDA: "PDA", PFEQ: "PFEQ"}
var Infos_And_Paths: Dictionary = {}
var dragging: bool = false
var offset: Vector2 = Vector2.ZERO

@onready var timer: Timer = Timer.new()

@onready var ExtendInfoBarButton : Button = $RessourcesAndButton/ExtendButton
@onready var info_bar : MarginContainer = $"."

@export var tree_base_height: int = 25  # Base height of the tree
@export var tree_item_height: int = 30  # Estimated height per item
var tree_max_height: int = 300

var is_resizing = false

func _ready():
	info_bar.set_h_size_flags(Control.SIZE_EXPAND | Control.SIZE_FILL)
	ExtendInfoBarButton.pressed.connect(func(): toggle_info_bar(info_bar))
	
	for tree in get_tree().get_nodes_in_group("InfoTrees"):
		TreesPaths.append(tree.get_path())
	var info_count = 0
	for info in infos:
		Infos_And_Paths[info] = TreesPaths[info_count]
		info_count += 1
		
	for separator in get_tree().get_nodes_in_group("Separator"):
		separator.connect("gui_input", _on_separator_input.bind(separator))
		
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 0.25  # Temps d'attente en secondes
	
	for data in Infos_And_Paths.keys():
		var tree = get_node(Infos_And_Paths[data])
		tree.columns = 1
		tree.set_column_titles_visible(true)
		tree.hide_root = false
		tree.select_mode = Tree.SELECT_ROW
		tree.item_selected.connect(func(): _on_item_selected(tree.get_selected()))
		timer.timeout.connect(func(): _on_timeout(tree))
		_populate_tree(tree, data)
		_collapse_all_items(tree)
		_update_tree_size(tree)
		tree.item_collapsed.connect(_on_item_collapsed)
		tree.column_title_clicked.connect(func(column_index, tree_item): _collapsing_with_title(column_index, tree_item, tree))
		tree.set_hide_root(true)
		

func toggle_info_bar(container):
	if container.get_h_size_flags() == 3:
		container.set_h_size_flags(Control.SIZE_SHRINK_END)
		ExtendInfoBarButton.set_text("<<")
	else :
		container.set_h_size_flags(Control.SIZE_EXPAND | Control.SIZE_FILL)
		ExtendInfoBarButton.set_text(">>")
		
func _populate_tree(tree: Tree, data, parent: TreeItem = null):
	# Définir la racine si aucun parent n'est fourni
	if parent == null:
		var data_name = infos[data]
		parent = tree.create_item()
		parent.set_text(0, data_name)
		tree.set_column_title(0, ShortInfos[data])

	if data is Dictionary:
	# Boucle sur les clés du dictionnaire
		for key in data.keys():
			var item = tree.create_item(parent)
			item.set_text(0, key)
			# Vérifier si la valeur associée est un dictionnaire (sous-niveau)
			if data[key] is Dictionary or data[key] is Array:
				_populate_tree(tree, data[key], item)  # Récursion
			# Sinon, c'est une feuille (dernière profondeur)
			else:
				var leaf = tree.create_item(item)
				leaf.set_text(0, str(data[key]))  # Convertir la valeur en texte si besoin
	
	elif data is Array:
		for element in data:
			var leaf = tree.create_item(parent)
			leaf.set_text(0, str(element))
			
func _on_item_collapsed(item: TreeItem):
	var parent = item.get_tree()
	_update_tree_size(parent)

func _update_tree_size(tree: Tree):
	var total_items = _count_visible_items(tree) - 1
	if (total_items * tree_item_height) < tree_max_height :
		tree.custom_minimum_size.y = tree_base_height + (total_items * tree_item_height)
	else :
		tree.custom_minimum_size.y = tree_max_height

func _count_visible_items(tree: Tree) -> int:
	if tree == null:
		return 0
	var root = tree.get_root()
	if root == null:
		return 0
		
	return _count_visible_items_from_item(root)

func _count_visible_items_from_item(item: TreeItem) -> int:
	var count = 1  # Count the current item
	if not item.is_collapsed():
		var child = item.get_first_child()
		while child:
			count += _count_visible_items_from_item(child)
			child = child.get_next()

	return count
	
func _collapse_all_items(tree):
	var root = tree.get_root()
	var child = root.get_first_child()
	while child:
		child.set_collapsed(true)  # Collapse the item
		_collapse_children(child)  # Recursively collapse all children
		child = child.get_next()
	root.set_collapsed(true)

func _collapse_children(item: TreeItem):
	var child = item.get_first_child()
	while child:
		child.set_collapsed(true)
		_collapse_children(child)
		child = child.get_next()

func _collapsing_with_title(_column_index: int, _tree_item: int, tree):
	var root = tree.get_root()
	
	if root.is_collapsed():
		root.set_collapsed(false)
		tree.set_hide_root(false)
	else:
		root.set_collapsed(true)
		tree.set_hide_root(true)
	
func _on_item_selected(selected_item: TreeItem):
	if selected_item:
		var text = selected_item.get_text(0)
		print("Élément sélectionné :", text)
		var mouse_position = get_local_mouse_position()
		var control_parent = Control.new()
		add_child(control_parent)
		# Créer un nouveau bouton
		var button = Button.new()
		control_parent.add_child(button)
		button.text = text
		button.custom_minimum_size = Vector2(100, 30)
		button.position = mouse_position - button.custom_minimum_size / 2
		
		button.mouse_filter = Control.MOUSE_FILTER_STOP

		button.size_flags_horizontal = 0
		button.size_flags_vertical = 0
		dragging = true
		button.grab_click_focus()
		offset = button.position - get_global_mouse_position()
		button.gui_input.connect(func(event):handle_drag(event, button))

	timer.start()

func _on_timeout(tree: Tree):
	# Désélectionner après le délai
	tree.deselect_all()
	
		
func handle_drag(event: InputEvent, button: Button):
	var hovered = get_tree().get_nodes_in_group("TextEdit").any(get_intersection)
	var hovered_node = null
	for node in get_tree().get_nodes_in_group("TextEdit"):
		if get_intersection(node): 
			hovered_node = node
			break
	
	if event is InputEventMouseButton:
		if event.pressed :
			dragging = true
			offset = button.position - get_global_mouse_position()
		elif not event.pressed:
			dragging = false
			if hovered:
				hovered_node.text += button.text
				hovered_node.emit_signal("text_changed")
			button.get_parent().queue_free()

	if event is InputEventMouseMotion and dragging:
		button.position = get_global_mouse_position() + offset
	
func get_intersection(text_edit: Node) -> bool:
	var rect_size = Vector2(2, 2)
	var mouse_rect = Rect2(get_global_mouse_position() - rect_size / 2, rect_size)
	var text_edit_rect = text_edit.get_global_rect()
	return mouse_rect.intersects(text_edit_rect)
	
func _on_separator_input(event, separator):
	if event is InputEventMouseMotion:
		if separator is HSeparator:
			separator.mouse_default_cursor_shape = Control.CURSOR_HSIZE
		if separator is HSeparator:
			separator.mouse_default_cursor_shape = Control.CURSOR_VSIZE
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_resizing = event.pressed
			 # Start or stop resizing
	elif event is InputEventMouseMotion and is_resizing:
		# Calculate new size based on mouse position
		var new_size = get_local_mouse_position()
		# Ensure minimum size
		new_size.x = max(new_size.x, 50)  # Minimum width
		new_size.y = max(new_size.y, 20)  # Minimum height
		var parent_node = separator.get_parent()  # Get the parent of the resize_handle
		var sibling : Node = null
		var last_child = null
		if parent_node:
				# Loop through all children of the parent node
			for child in parent_node.get_children():
				if child == separator:
					sibling = last_child  # The last visited child is the one above the separator
					break  # Stop searching once we found the separator
				last_child = child  # Update last_child before moving to the next one
		if separator is VSeparator:
			sibling.custom_minimum_size.x = new_size.x - sibling.position.x
		if separator is HSeparator:
			sibling.custom_minimum_size.y = new_size.y - sibling.position.y
