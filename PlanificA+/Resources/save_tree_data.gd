extends Resource

class_name SaveTreeData

@export var custom_canvas_dict = {}
@export var custom_local_group_dict = {}

@export var material = {
	"Matériel général": {
		"Équipement de base et ressources communes": [
			"Tableau blanc/noir et marqueurs/craies",
			"Projecteur et écran",
			"Ordinateur avec accès à Internet",
			"Manuels scolaires et cahiers d'exercices (générique)",
			"Cartes du monde (physiques et politiques)"
		]
	},
	"Mathématiques": {
		"Manipulation et visualisation": [
			"Tuiles algébriques",
			"Balance d'équations ou balance mathématique",
			"Modèles 3D de solides géométriques",
			"Blocs base 10",
			"Jeux de dés et cartes",
			"Rubans à mesurer",
			"pieds à coulisse"
		],
		"Instruments de géométrie": [
			"Règles graduées",
			"Équerres (30-60-90 et 45-45-90)",
			"Rapporteur",
			"Compas"
		],
		"Matériel de calcul et de représentation": [
			"Calculatrices graphiques",
			"Calculatrices scientifiques",
			"Feuilles de papier quadrillé",
			"Feuilles de papier quadrillé isométrique",
			"Papier millimétré et papier logarithmique"
		],
		"Logiciels et ressources numériques": [
			"Logiciels de géométrie dynamique",
			"Tableur (ex: Microsoft Excel, Google Sheets)",
			"Logiciels de calcul formel (ex: Maple, Mathematica, Wolfram Alpha)",
			"Plateformes d'exercices interactifs et de simulation"
		]
	},
	"Sciences": {
		"Biologie": {
			"Observation": [
				"Microscopes optiques (composé et/ou stéréoscopique)",
				"Lames préparées (cellules végétales, animales, microorganismes, tissus spécifiques)",
				"Lames et lamelles vierges pour les préparations microscopiques",
				"Loupes binoculaires et loupes à main",
				"Caméra pour microscope"
			],
			"Dissection": [
				"Plateaux de dissection et kits de dissection (scalpels, ciseaux, pinces fines, aiguilles montées)",
				"Spécimens préservés (grenouilles, rats, cœurs, yeux)",
			],
			"Modèles et démonstrations": [
				"Modèles anatomiques",
				"Modèles de molécules d'ADN et d'ARN",
				"Modèles cellulaires (cellule animale, cellule végétale)",
				"Planches anatomiques et cycles de vie d'organismes"
			],
			"Matériel de laboratoire": [
				"Matériel de verrerie de base (béchers, éprouvettes graduées, erlenmeyers, pipettes Pasteur)",
				"Milieux de culture",
				"Boîtes de Pétri",
				"Réactifs pour tests biochimiques (ex: Lugol pour l'amidon)",
				"Tubes à essai et supports"
			]
		},
		"Chimie": {
			"Verrerie et ustensiles": [
				"Béchers, erlenmeyers, fioles jaugées, éprouvettes graduées",
				"Pipettes graduées et volumétriques (jaugées) avec propipettes/poires",
				"Burettes et supports",
				"Agitateurs en verre, spatules",
				"Entonnoirs (verre et plastique), verre de montre",
				"Pissettes (eau distillée)"
			],
			"Chauffage et sécurité": [
				"Becs Bunsen",
				"Plaques chauffantes électriques",
				"Supports universels et pinces (à bécher, à éprouvette)",
				"Lunettes de protection, gants de laboratoire",
				"Hotte de laboratoire (indispensable pour certains produits)"
			],
			"Mesure et analyse": [
				"Balances de précision",
				"pH-mètres (électroniques)",
				"Papier pH (tournesol)",
				"Thermomètres de laboratoire",
				"Conductimètres (pour la conductivité des solutions)"
			],
			"Réactifs": [
				"Produits chimiques de base (acides, bases, sels, métaux)",
				"Indicateurs colorés (phénolphtaléine, bleu de bromothymol, hélianthine)",
				"Eau distillée ou déminéralisée en grande quantité"
			],
			"Modélisation": [
				"Kits de modèles atomiques et moléculaires",
				"Tableau périodique des éléments"
			]
		},
		"Physique": {
			"Mécanique": [
				"Dynamomètres",
				"Masses marquées et crochets",
				"Chariots et rails de frottement réduit",
				"Poulies (simples, doubles, multiples) et supports",
				"Plans inclinés réglables",
				"Chronographes et chronomètres de précision",
				"Mètre ruban et règles"
			],
			"Optique": [
				"Sources lumineuses (lampe à fente, laser)",
				"Lentilles convergentes et divergentes, miroirs (plan, concave, convexe)",
				"Bancs d'optique avec supports pour lentilles/miroirs",
				"Prismes, réseaux de diffraction",
				"Écrans de projection"
			],
			"Électricité et magnétisme": [
				"Générateurs de courant (continuel et alternatif)",
				"Ampèremètres, voltmètres, ohmmètres (multimètres)",
				"Résistances, condensateurs, bobines d'induction",
				"Fils de connexion, pinces crocodiles",
				"Interrupteurs",
				"Ampoules et supports",
				"Aimants permanents, limaille de fer, boussoles",
				"Bobines de Helmholtz (pour champs magnétiques uniformes)"
			],
			"Thermodynamique et Ondes": [
				"Thermomètres (à alcool, numériques)",
				"Calorimètres",
				"Générateur de fonctions et haut-parleur",
				"Corde vibrante et vibrateur",
				"Cuve à ondes"
			]
		}
	},
	"Français": {
		"Ressources linguistiques": [
			"Dictionnaires (Le Robert, Larousse)",
			"Thésaurus (synonymes, antonymes)",
			"Grammaires de référence (ex: Le Bon Usage)",
			"Béscherelle (conjugaison)",
		],
		"Matériel d'écriture et de correction": [
			"Feuilles lignées, cahiers d'écriture",
			"Crayons, stylos, surligneurs, effaceurs",
			"Guides de correction et grilles d'évaluation"
		],
		"Littérature": [
			"Anthologies littéraires (textes classiques et contemporains)",
			"Collections de romans, pièces de théâtre, recueils de poésie",
			"Livres jeunesse et albums",
			"Extraits de films ou séries adaptés d'œuvres littéraires"
		],
		"Production orale": [
			"Enregistreur audio",
			"Microphone",
			"Matériel pour la préparation de présentations orales (cartons, chevalet)"
		],
		"Créativité et jeux": [
			"Jeux de société axés sur le langage (Scrabble, Mots Croisés, Taboo, Dixit)",
			"Cartes de vocabulaire thématiques",
			"Matériel pour l'écriture créative (magazines, images d'inspiration)"
		]
	},
	"Anglais": {
		"Ressources linguistiques": [
			"Dictionnaires bilingues et unilingues",
			"Thésaurus anglais",
			"Grammaires anglaises de référence",
			"Cartes du monde anglophone"
		],
		"Compréhension et expression orale": [
			"Lecteur CD / Haut-parleurs",
			"Enregistreur audio",
			"Microphone",
			"Films, séries, vidéos en anglais",
			"Podcasts, chansons en anglais",
			"Matériel pour jeux de rôle et simulations"
		],
		"Lecture et écriture": [
			"Livres de lecture gradés (graded readers)",
			"Romans, nouvelles, pièces de théâtre en anglais",
			"Journaux et magazines anglophones",
			"Manuels et cahiers d'exercices"
		],
		"Jeu et interactivité": [
			"Jeux de société axés sur l'anglais",
			"Flashcards",
			"Matériel pour créer des cartes mentales ou des affiches"
		]
	},
	"Histoire et Géographie": {
		"Histoire": {
			"Documentation et références": [
				"Atlas historiques (papier et/ou numériques)",
				"Frises chronologiques murales ou à construire",
				"Manuels scolaires avec cartes et illustrations",
				"Documents d'archives (reproductions)",
				"Livres d'histoire spécialisés"
			],
			"Visualisation et interactivité": [
				"Cartes historiques murales",
				"Globes terrestres (politiques et physiques)",
				"Maquettes ou modèles (châteaux, cités)",
				"Vidéos documentaires, extraits de films historiques",
				"Logiciels de cartographie historique"
			],
			"Objets d'étude": [
				"Reproductions d'artefacts (monnaies, outils, poteries)"
			]
		},
		"Géographie": {
			"Cartographie et localisation": [
				"Atlas géographiques (physiques, politiques, économiques)",
				"Cartes murales détaillées (monde, Canada, Québec)",
				"Globes terrestres",
				"Logiciels SIG (ex: Google Earth Pro)",
				"Cartes topographiques"
			],
			"Matériel de terrain et d'analyse": [
				"Boussoles",
				"GPS (Global Positioning System)",
				"Mètre ruban",
				"Matériel de collecte d'échantillons (sacs, loupes)",
				"Thermomètres, baromètres, anémomètres (simples)"
			],
			"Modélisation et illustration": [
				"Modèles de reliefs ou matériel pour les créer",
				"Échantillons de roches et minéraux",
				"Photos aériennes et satellitaires",
				"Infographies sur les phénomènes géographiques"
			]
		}
	},
	"Éducation Physique et à la Santé": {
		"Sécurité et premiers soins": [
			"Trousse de premiers secours complète",
			"Mannequins de réanimation",
			"Défibrillateur de formation (DEA)",
			"Gilets de sécurité (visibilité)"
		],
		"Équipement sportif de base": [
			"Ballons (basketball, volleyball, soccer, rugby, handball)",
			"Filets et poteaux (volleyball, badminton)",
			"Raquettes (badminton, tennis de table, tennis)",
			"Cerceaux, cordes à sauter",
			"Cônes, pions, échelles d'agilité",
			"Sacs de fèves, balles de jonglage",
			"Matériel d'athlétisme léger (javelots en mousse, disques en plastique)"
		],
		"Mesure et suivi": [
			"Chronomètres numériques",
			"Sifflet",
			"Compte-tours / Pédaleurs",
			"Dynamomètres manuels (force de préhension)",
			"Balances et mètres ruban"
		],
		"Matériel pédagogique": [
			"Manuels et guides sur les règles des sports, la nutrition",
			"Affiches sur l'anatomie, la physiologie, l'hygiène",
			"Système audio pour la musique"
		]
	},
	"Arts Plastiques": {
		"Support et base": [
			"Papiers (dessin, aquarelle, kraft, carton)",
			"Toiles, cartons entoilés",
			"Panneaux de contreplaqué ou MDF",
			"Chevalets de table ou de sol"
		],
		"Dessin et graphisme": [
			"Crayons à mine (différentes duretés)",
			"Fusains, sanguines, pastels secs et gras",
			"Feutres, marqueurs",
			"Encres de Chine, plumes, calames",
			"Gommes (mie de pain, plastique)",
			"Taille-crayons, estompes"
		],
		"Peinture": [
			"Peintures (gouache, acrylique, aquarelle)",
			"Pinceaux (différentes tailles et formes)",
			"Palettes",
			"Godets et récipients pour l'eau"
		],
		"Modelage et sculpture": [
			"Argile, pâte à modeler",
			"Outils de modelage (mirettes, ébauchoirs)",
			"Fil de fer, grillage pour armatures",
			"Matériaux de récupération",
			"Colles (blanche, à bois, pistolet à colle chaude)"
		],
		"Gravure et estampe": [
			"Plaques à graver (linoleum, bois, polystyrène)",
			"Gouges et burins",
			"Encres de gravure",
			"Rouleaux encreurs (brayers)",
			"Presse à gravure ou baren"
		],
		"Divers": [
			"Ciseaux, cutters (avec tapis de coupe)",
			"Règles et équerres",
			"Vaporisateurs d'eau",
			"Tabliers ou blouses de protection",
			"Supports de séchage",
			"Livres d'art, reproductions d'œuvres"
		]
	},
	"Musique": {
		"Instruments": [
			"Claviers numériques (avec sorties casque)",
			"Guitares acoustiques et/ou classiques",
			"Basses électriques et amplificateurs",
			"Batteries (acoustique ou électronique)",
			"Percussions diverses (djembés, congas, shakers, etc.)",
			"Instruments Orff (xylophones, métallophones)",
			"Flûtes à bec, harmonicas"
		],
		"Audiovisuel et technologie": [
			"Système audio de bonne qualité",
			"Microphones et pieds de micro",
			"Interface audio et logiciel d'enregistrement (DAW)",
			"Logiciels de composition et notation (ex: MuseScore)",
			"Casques d'écoute"
		],
		"Théorie musicale et partitions": [
			"Pupitres à musique",
			"Métronome",
			"Accordeurs",
			"Partitions musicales",
			"Livres de théorie musicale et d'histoire de la musique",
			"Affiches murales (notes, rythmes, etc.)"
		],
		"Accessoires": [
			"Câbles audio (XLR, jack), adaptateurs",
			"Bancs et tabourets",
			"Sangles de guitare, médiators",
			"Pochettes et étuis pour les instruments"
		]
	}
}
