extends PanelContainer

@export var text_to_cloud = "Aujourd'hui, j'ai l'impression d'avoir enfin trouvé la bonne combinaison, celle que je cherchais depuis le début de l'année. Je suis particulièrement fier de la planification de ce cours, qui a fait toute la différence. Ma stratégie d'enseignement était simple : j'ai mis en place un plan clair pour le taux d'achèvement de la tâche, en m'assurant que chaque élève comprenait les consignes. C'est cette minutieuse planification qui m'a permis de reprendre le contrôle de ma gestion de classe.

La gestion de classe a été une réussite complète. J'ai vu un niveau de participation et de collaboration que je n'avais jamais atteint auparavant. Le climat d'apprentissage était extraordinaire. Les élèves se sont approprié l'activité et ont fait preuve d'une autonomie impressionnante. C'était un vrai plaisir de les voir travailler ensemble, sans les interruptions habituelles. La gestion de classe s'est faite d'elle-même, car les élèves étaient tellement engagés. J'ai pu observer cette participation active tout au long de la période, ce qui est une preuve de l'efficacité de ma stratégie d'enseignement.

J'ai pu circuler librement dans la classe, non pas pour éteindre des feux, mais pour offrir un soutien ciblé. Cette stratégie d'enseignement a permis de créer un environnement où l'erreur n'est plus une source d'angoisse. J'ai vu la collaboration s'opérer de manière naturelle. Leur autonomie m'a permis de me concentrer sur les élèves qui en avaient le plus besoin. L'efficacité de ma planification a été démontrée par le taux d'achèvement exceptionnel. Le plaisir que j'ai vu dans leurs yeux et dans leurs rires était contagieux. C'est ça l'efficacité que je veux atteindre.

Je finis la journée avec un sentiment de plaisir et de fierté. J'ai l'impression que ma posture enseignante a enfin trouvé son équilibre. C'est la preuve que je peux avoir un impact positif. Ça me donne l'énergie de continuer et l'espoir que je pourrai reproduire cette efficacité à l'avenir. C'est un grand plaisir de voir mes efforts porter leurs fruits, et je suis optimiste pour la suite."
@export var min_font_size: int = 12
@export var max_font_size: int = 24

@onready var label = $RichTextLabel

func _ready() -> void:
	label.text = ""
	var word_counts = get_word_frequencies(text_to_cloud)
	var filtered_word_counts = filter_stop_words(word_counts)
	filtered_word_counts.sort()
	var min_max_freq = get_min_max_frequency(filtered_word_counts)
	for word in filtered_word_counts :
		var frequency = filtered_word_counts[word]
		var font_size = get_font_size_power(frequency, min_max_freq, min_font_size, max_font_size)
		print(font_size)
		var bbcode_string = "  [font_size=" + str(font_size) + "]" + word + "[/font_size]  "
		label.text += bbcode_string

func _update_cloud() :
	label.text = ""
	var word_counts = get_word_frequencies(text_to_cloud)
	var filtered_word_counts = filter_stop_words(word_counts)
	filtered_word_counts.sort()
	print(filtered_word_counts)
	var min_max_freq = get_min_max_frequency(filtered_word_counts)
	for word in filtered_word_counts :
		var frequency = filtered_word_counts[word]
		var font_size = get_font_size_power(frequency, min_max_freq, min_font_size, max_font_size)
		var bbcode_string = "  [font_size=" + str(font_size) + "]" + word + "[/font_size]  "
		label.text += bbcode_string

func get_word_frequencies(text: String) -> Dictionary:
	var word_counts = {}
	var delimiters = [" ", "'", "\n"]
	var words = [text.to_lower()] # Start with a list containing the whole string

	for delimiter in delimiters:
		var new_words = []
		for word_part in words:
			# Split each existing word part by the new delimiter
			new_words.append_array(word_part.split(delimiter, false))
			words = new_words
	
	for word in words:
		# Remove punctuation
		var cleaned_word = word.strip_edges().replace(",", "").replace(".", "").replace("!", "").replace("?", "")
			
		if not cleaned_word == "":
			if word_counts.has(cleaned_word):
				word_counts[cleaned_word] += 1
			else:
				word_counts[cleaned_word] = 1
	return word_counts
	
func filter_stop_words(word_counts: Dictionary) -> Dictionary:
	# This list can be expanded to include more words
	var go_words = [
	# Planification et conception
	"objectif", "objectifs",
	"intention", "intentions",
	"progression", "progressions",
	"didactique", "didactiques",
	"séquence didactique", "séquences didactiques",
	"plan de cours", "plans de cours",
	"planification", "planifications",
	"projet", "projets",
	"scénarisation", "scénarisations",
	"cohérence",
	"inattendu",
	"préparation", "préparé", "préparée", "préparés", "préparées",
	"matériel", "matériels",
	"critère", "critères",
	"exigence", "exigences",

	# Gestion de classe et comportement
	"gestion", "gestions",
	"temps",
	"climat", "climats",
	"dynamique", "dynamiques",
	"règle", "règles",
	"transition", "transitions",
	"autorité",
	"intervention", "interventions",
	"bavardage", "bavardages",
	"défi", "défis",
	"comportement", "comportements",
	"perturbation", "perturbations",
	"silence",
	"intimidation", "intimidé", "intimidée", "intimidés", "intimidées",
	"consigne", "consignes",
	"responsabilité", "responsabilités",
	"maîtrise",
	"écoute",
	"rythme", "rythmes",
	"routine", "routines",
	"fracture", "fractures",
	"briser", "bris", "brisé", "brisée", "brisés", "brisées",
	"casser", "cassé", "cassée", "cassés", "cassées",

	# Enseignement et méthodes
	"stratégie", "stratégies",
	"enseignement",
	"pédagogie active",
	"enseignement direct",
	"coopération",
	"collaboration",
	"méthode", "méthodes",
	"ancrage",
	"modélisation",
	"explication", "explications",
	"questionnement", "questionnements",
	"soutien", "soutiens",
	"support",
	"interdisciplinarité",
	"adaptation",
	"créativité",
	"résolution de problèmes",
	"compétence transversale", "compétences transversales",
	"compréhension",
	"mémorisation",
	"expérience", "expériences",
	"accompagnement",
	"posture", "postures",

	# Évaluation et apprentissages
	"évaluation", "évaluations",
	"évaluation formative", "évaluations formatives",
	"évaluation sommative", "évaluations sommatives",
	"rétroaction", "rétroactions",
	"feedback", "feedbacks",
	"grille", "grilles",
	"portfolio", "portfolios",
	"devoir", "devoirs",
	"examen", "examens",
	"note", "notes",
	"compétence", "compétences",
	"échelle", "échelles",
	"performance", "performances",
	"auto-évaluation", "auto-évaluations",
	"diagnostic", "diagnostics",
	"apprentissage", "apprentissages",
	"apprentissage conceptuel",
	"apprentissage procédural",
	"maîtrise",
	"transfert",
	"erreur", "erreurs",
	"triche", "tricherie", "triché", "trichée", "trichés", "trichées",
	"autocritique", "autocritiques",
	"autoréflexion",
	"ajustement", "ajustements",
	"efficacité",
	"bienveillance",

	# Engagement et facteurs humains
	"engagement",
	"motivation",
	"participation",
	"attention",
	"taux d'achèvement",
	"curiosité",
	"plaisir",
	"relation", "relations",
	"pertinence",
	"autonomie",
	"épuisement",
	"stress", "angoisse",
	"écoute",
	"relationnel",
	"fracture", "fractures",

	# Outils et technologies
	"technologie", "technologies",
	"numérique", "numériques",
	"virtuel", "virtuels", "virtuelle", "virtuelles",
	"tableau", "tableaux",
	"jeux", "jeu",
	"bureau", "bureaux"
]

	var word_counts_duplicate = word_counts.duplicate() # Make a copy to avoid modifying the original dictionary while iterating
	var filtered_counts = {}
	
	for key in word_counts_duplicate :
		if go_words.has(key) :
			filtered_counts[key] = word_counts_duplicate[key]
			
	#for word in go_words:
	#	if filtered_counts.has(word):
	#		filtered_counts.erase(word)
	
	
	return filtered_counts

func get_min_max_frequency(word_counts: Dictionary) -> Vector2:
	if word_counts.keys().size() == 0 :
		return Vector2(0, 0)
	
	var freqs = word_counts.values()
	var max_freq = 0
	var min_freq = 999999999
	
	for freq in freqs:
		max_freq = max(max_freq, freq)
		min_freq = min(min_freq, freq)
		
	return Vector2(min_freq, max_freq)


func get_font_size_power(frequency: int, min_max_freq: Vector2, min_font_size, max_font_size) -> int:
	var min_freq = min_max_freq.x
	var max_freq = min_max_freq.y
	
	if max_freq == min_freq:
		return min_font_size
		
	# A value greater than 1.0 will make the top words stand out more
	var exponent = 1.2
	
	# Normalize the frequency to a 0-1 range
	var normalized_freq = float(frequency - min_freq) / float(max_freq - min_freq)
	
	# Apply the power function to the normalized value
	var powered_value = pow(normalized_freq, exponent)
	
	# Interpolate to the final font size
	return int(lerp(float(min_font_size), float(max_font_size), powered_value))
