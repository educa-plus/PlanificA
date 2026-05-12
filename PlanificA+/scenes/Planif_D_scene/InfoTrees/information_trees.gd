extends Control

@onready var timer = Timer.new()

#@onready var ExtendInfoBarButton : Button = $EveryThing/InfoBar/RessourcesAndButton/ExtendButton
@onready var info_bar = $TreesAndCanva/Trees/InfoBar
@onready var canva_vbox = $TreesAndCanva/PersonalCanva/CanvaVbox/ScrollContainer/VBoxContainer

@onready var search_results_box = %SearchResults

@onready var plus_icon = load("res://_theme/_icons/PlusIcon.png")

@export var tree_base_height: int = 20  # Base height of the tree
@export var tree_item_height: int = 30  # Estimated height per item
@export var tree_max_height: int = 300

var dict = {
  "Science et technologie": {
	"Secondaire 1": {
	  "Univers matériel": {
		"1. Propriétés de la matière": {
		  "a. Propriétés caractéristiques": [
			"i. Distinguer une propriété caractéristique d’une propriété non caractéristique",
			"ii. Déterminer des propriétés caractéristiques (ex. : point de fusion, point d’ébullition, masse volumique, acidité/basicité, conductibilité électrique)"
		  ],
		  "b. Masse": [
			"i. Définir le concept de masse",
			"ii. Comparer les masses de différentes substances ayant le même volume"
		  ],
		  "c. Volume": [
			"i. Définir le concept de volume",
			"ii. Choisir l’unité de mesure appropriée pour exprimer un volume (ex. : 120 mL ou 0,12 L ou 120 cm³)"
		  ],
		  "d. Température": [
			"i. Définir le concept de température",
			"ii. Distinguer chaleur et température"
		  ],
		  "e. États de la matière": [
			"i. Décrire les trois états de la matière à l’aide du modèle particulaire (solide, liquide, gaz)",
			"ii. Nommer les différents changements d’état de la matière (vaporisation, condensation, solidification, fusion, condensation solide, sublimation)"
		  ],
		  "f. Acidité et basicité": [
			"i. Déterminer le pH d’une substance à l’aide d’indicateurs (ex. : papier tournesol, papier pH)",
			"ii. Situer une substance sur l’échelle pH"
		  ]
		},
		"2. Changements de la matière": {
		  "a. Changements physiques": [
			"i. Reconnaître un changement physique (ex. : changement d’état, dissolution, déformation)"
		  ],
		  "b. Mélanges": [
			"i. Distinguer un mélange homogène d’un mélange hétérogène",
			"ii. Décrire des méthodes de séparation des mélanges (ex. : décantation, filtration, évaporation)"
		  ],
		  "c. Changements chimiques": [
			"i. Reconnaître un changement chimique à partir de ses indices (ex. : changement de couleur, dégagement gazeux, formation d’un précipité, dégagement ou absorption de chaleur)",
			"ii. Différencier un changement chimique d'un changement physique"
		  ]
		}
	  },
	  "Terre et Espace": {
		"1. Phénomènes géologiques": {
		  "a. Minéraux": [
			"i. Reconnaître des minéraux à l’aide de leurs propriétés (ex. : couleur, dureté, éclat)"
		  ],
		  "b. Roches": [
			"i. Classer les roches en trois catégories (ignées, sédimentaires, métamorphiques) selon leur mode de formation"
		  ],
		  "c. Sols": [
			"i. Décrire les principaux horizons d’un sol (couches superficielles, terre arable, sous-sol, roche mère)",
			"ii. Expliquer l’influence de certains facteurs sur l’épaisseur des couches du sol (ex. : climat, végétation, type de roche)"
		  ]
		},
		"2. Phénomènes astronomiques": {
		  "a. Système solaire": [
			"i. Situer la Terre dans le système solaire",
			"ii. Décrire les caractéristiques des planètes (très grande taille, quasi-sphérique, orbite autour d’une étoile, etc.)",
			"iii. Distinguer une planète d’une étoile"
		  ],
		  "b. Phénomènes liés aux mouvements de la Terre et de la Lune": [
			"i. Expliquer la durée du jour et de la nuit par la rotation de la Terre",
			"ii. Expliquer les saisons par l’inclinaison et la révolution de la Terre",
			"iii. Décrire les phases de la Lune"
		  ]
		}
	  },
	  "Univers vivant": {
		"1. Caractéristiques du vivant": {
		  "a. Cellule": [
			"i. Identifier les constituants de base de la cellule (membrane, cytoplasme, noyau) et leur fonction principale",
			"ii. Distinguer la cellule animale de la cellule végétale"
		  ],
		  "b. Organisation de la vie": [
			"i. Décrire les niveaux d’organisation biologique (cellule, tissu, organe, système, organisme)"
		  ]
		},
		"2. Maintien de la vie": {
		  "a. Nutrition": [
			"i. Décrire la fonction globale de la nutrition (fournir l’énergie et les matériaux nécessaires au fonctionnement des cellules)",
			"ii. Identifier les principaux nutriments (glucides, lipides, protéines) et leur rôle"
		  ],
		  "b. Respiration": [
			"i. Décrire la fonction globale de la respiration (permettre les échanges gazeux entre l’organisme et son environnement)"
		  ],
		  "c. Photosynthèse": [
			"i. Décrire la photosynthèse comme une transformation d’énergie lumineuse en énergie chimique"
		  ]
		},
		"3. Diversité de la vie": {
		  "a. Classification": [
			"i. Utiliser une clé de détermination simple pour classer des vivants",
			"ii. Classer des vertébrés en cinq classes (mammifères, oiseaux, reptiles, amphibiens, poissons)"
		  ],
		  "b. Habitat et niche écologique": [
			"i. Définir un habitat comme le lieu où vit une espèce",
			"ii. Définir une niche écologique comme le rôle d’une espèce dans son écosystème"
		  ]
		}
	  },
	  "Univers technologique": {
		"1. Ingénierie mécanique": {
		  "a. Liaisons et guidage": [
			"i. Identifier les types de liaisons dans un objet technique (complète, partielle)",
			"ii. Identifier les types de guidage dans un objet technique (en rotation, en translation)"
		  ],
		  "b. Systèmes de transmission et de transformation du mouvement": [
			"i. Identifier des systèmes de transmission du mouvement (ex. : roues de friction, engrenages, poulies et courroie)",
			"ii. Identifier des systèmes de transformation du mouvement (ex. : came et galet, bielle et manivelle)"
		  ]
		},
		"2. Ingénierie électrique": {
		  "a. Circuits électriques": [
			"i. Identifier les composantes d’un circuit électrique simple (source d’alimentation, fils, interrupteur, ampoule)",
			"ii. Distinguer un circuit en série d’un circuit en parallèle"
		  ],
		  "b. Fonctions électriques": [
			"i. Décrire la fonction des principales composantes d’un circuit (alimentation, conduction, isolation, commande, transformation de l’énergie)"
		  ]
		},
		"3. Matériaux": {
		  "a. Catégories de matériaux": [
			"i. Classer les matériaux selon leur origine (bois, métaux, plastiques, céramiques, composites)"
		  ],
		  "b. Propriétés des matériaux": [
			"i. Décrire les propriétés mécaniques des matériaux (dureté, élasticité, ductilité, malléabilité, résistance à la corrosion)"
		  ]
		}
	  }
	}
  }
}

var PDA2 = {
	"Secondaire 1": {
		"L'univers matériel": {
			"A. Propriétés": {
				"1. Propriétés de la matière": {
					"a. Masse": [
						"Définir le concept de masse",
						"Comparer les masses de différentes substances ayant le même volume"
					],
					"b. Volume": [
						"Définir le concept de volume",
						"Choisir l'unité de mesure appropriée pour exprimer un volume (ex. : 120 mL ou 0,12 L ou 120 cm )",
						"Comparer les volumes de différentes substances ayant la même masse"
					],
					"c. Température": [
						"Décrire l'effet d'un apport de chaleur sur le degré d'agitation des particules",
						"Définir la température comme étant une mesure du degré d'agitation des particules",
						"Expliquer la dilatation thermique des corps"
					],
					"d. États de la matière": [
						"Nommer les différents changements d'état de la matière (vaporisation, condensation, solidification, fusion, condensation solide, sublimation)",
						"Interpréter le diagramme de changement d'état d'une substance pure"
					],
					"e. Acidité/basicité": [
						"Déterminer les propriétés observables de solutions acides, basiques ou neutres (ex. : réaction au tournesol, réactivité avec un métal)",
						"Déterminer le caractère acide ou basique de substances usuelles (ex. : eau, jus de citron, vinaigre, boissons gazeuses, lait de magnésie, produit nettoyant)"
					],
					"f. Propriétés caractéristiques": [
						"Définir une propriété caractéristique comme étant une propriété qui aide à l'identification d'une substance ou d'un groupe de substances",
						"Distinguer des groupes de substances par leurs propriétés caractéristiques communes (ex. : les acides rougissent le tournesol)",
						"Associer une propriété caractéristique d'une substance ou d'un matériau à l'usage qu'on en fait (ex. : on utilise le métal pour fabriquer une casserole parce qu'il conduit bien la chaleur)"
					]
				},
				"3. Propriétés des solutions": {
					"a. Solutions": [
						"Décrire les propriétés d'une solution aqueuse (ex. : une seule phase visible,translucide)"
					]
				}
			},
			"B. Transformations": {
				"1. Transformations de la matière": {
					"a. Conservation de la matière": [
						"Démontrer que la matière se conserve lors d'un changement chimique (ex. : conservation de la masse lors d'une réaction de précipitation)"
					],
					"b. Mélanges": [
						"Décrire les propriétés d'un mélange (ex. : composé de plusieurs substances, présentant une ou plusieurs phases)",
						"Distinguer une solution ou un mélange homogène (ex. : eau potable, air, alliage) d'un mélange hétérogène (ex. : jus de tomates, smog, roche)"
					],
					"d. Séparation des mélanges": [
						"Associer une technique de séparation au type de mélange qu'elle permet de séparer",
						"Décrire les étapes à suivre pour séparer un mélange complexe (ex. : pour séparer de l'eau salée contenant du sable, on effectue une sédimentation, une décantation, puis une évaporation)"
					]
				},
				"2. Transformations physiques": {
					"a. Changement physique": [
						"Décrire les caractéristiques d'un changement physique (ex. : la substance conserve ses propriétés; les molécules impliquées demeurent intactes)",
						"Reconnaître différents changements physiques (ex. : changements d'état, préparation ou séparation d'un mélange)"
					]
				},
				"3. Transformations chimiques": {
					"a. Changement chimique": [
						"Décrire les indices d'un changement chimique (formation d'un précipité, effervescence, changement de couleur, dégagement de chaleur ou émission de lumière)",
						"Expliquer un changement chimique à l'aide des modifications des propriétés des substances impliquées",
						"Nommer différents types de changements chimiques (ex. : décomposition, oxydation)"
					]
				}
			},
			"C. Organisation": {
				"1. Structure de la matière": {
					"a. Atome": [
						"Décrire le modèle atomique de Dalton",
						"Définir l'atome comme étant l'unité de base de la molécule"
					],
					"b. Molécule": [
						"Décrire une molécule à l'aide du modèle atomique de Dalton (combinaison d'atomes liés chimiquement)",
						"Représenter la formation d'une molécule à l'aide du modèle atomique de Dalton"
					],
					"c. Élément": [
						"Définir un élément comme étant une substance pure formée d'une seule sorte d'atomes (ex. : Fe, N2)"
					],
					"d. Tableau périodique": [
						"Décrire le tableau périodique comme un répertoire organisé des éléments"
					]
				}
			}
		},
		"L'univers vivant": {
			"A. Diversité de la vie": {
				"1. Écologie": {
					"a. Habitat": [
						"Nommer les caractéristiques qui définissent un habitat (ex. : situation géographique, climat, flore, faune, proximité de constructions humaines)",
						"Décrire l'habitat de certaines espèces"
					],
					"b. Niche écologique": [
						"Nommer des caractéristiques qui définissent une niche écologique (ex. : habitat, régime alimentaire, rythme journalier)",
						"Décrire la niche écologique d'une espèce animale"
					],
					"c. Espèce": [
						"Nommer les caractéristiques qui définissent une espèce (caractères physiques communs, reproduction naturelle, viable et féconde)"
					],
					"d. Population": [
						"Distinguer une population d'une espèce",
						"Calculer le nombre d'individus d'une espèce qui occupe un territoire donné"
					]
				},
				"2. Diversité chez les vivants": {
					"a. Adaptations physiques et comportementales": [
						"Décrire des adaptations physiques qui permettent à un animal ou à un végétal d'augmenter ses chances de survie (ex. : pelage de la même couleur que le milieu de vie, forme des feuilles)",
						"Décrire des adaptations comportementales qui permettent à un animal ou à un végétal d'augmenter ses chances de survie (ex. : déplacement en groupes, phototropisme)"
					],
					"b. Évolution": [
						"Décrire des étapes de l'évolution des êtres vivants",
						"Expliquer le processus de la sélection naturelle"
					],
					"c. Taxonomie": [
						"Définir la taxonomie comme étant un système de classification des vivants principalement basé sur leurs caractéristiques anatomiques et génétiques",
						"Identifier une espèce à l'aide d'une clé taxonomique"
					],
					"d. Gènes et chromosomes": [
						"Situer les chromosomes dans la cellule",
						"Définir un gène comme étant une portion d'un chromosome",
						"Décrire le rôle des gènes (transmission des caractères héréditaires)"
					]
				}
			},
			"B. Maintien de la vie": {
				"": {
					"a. Caractéristiques du vivant": [
						"Décrire certaines caractéristiques communes à tous les êtres vivants (nutrition, relation, adaptation, reproduction)"
					],
					"b. Cellules végétales et animales": [
						"Définir la cellule comme étant l'unité structurale de la vie",
						"Nommer des fonctions vitales assurées par la cellule",
						"Distinguer une cellule animale d'une cellule végétale"
					],
					"c. Constituants cellulaires visibles au microscope": [
						"Identifier les principaux constituants cellulaires visibles au microscope (membrane cellulaire, cytoplasme, noyau, vacuoles)",
						"Décrire le rôle des principaux constituants cellulaires visibles au microscope"
					],
					"d. Intrants et extrants (énergie, nutriments, déchets)": [
						"Nommer des intrants cellulaires",
						"Nommer des extrants cellulaires"
					],
					"e. Osmose et diffusion": [
						"Distinguer l'osmose de la diffusion"
					],
					"f. Photosynthèse et respiration": [
						"Nommer les intrants et les extrants impliqués dans le processus de la photosynthèse",
						"Nommer les intrants et les extrants impliqués dans le processus de la respiration"
					]
				}
			},
			"E. Perpétuation des espèces": {
				"1. Reproduction": {
					"a. Reproduction asexuée ou sexuée": [
						"Distinguer la reproduction asexuée de la reproduction sexuée (ex. : la reproduction sexuée requiert des gamètes)"
					],
					"b. Modes de reproduction chez les végétaux": [
						"Décrire des modes de reproduction asexuée chez les végétaux (ex. : bouturage, marcottage)",
						"Décrire le mode de reproduction sexuée des végétaux (plantes à fleurs)"
					],
					"c. Modes de reproduction chez les animaux": [
						"Décrire les rôles du mâle et de la femelle lors de la reproduction chez certains groupes d'animaux (ex. : oiseaux, poissons, mammifères)"
					],
					"d. Organes reproducteurs": [
						"Nommer les principaux organes reproducteurs masculins et féminins (pénis, testicules, vagin, ovaires, trompes de Fallope, utérus)"
					],
					"e. Gamètes": [
						"Nommer les gamètes mâles et femelles",
						"Décrire le rôle des gamètes dans la reproduction"
					],
					"f. Fécondation": [
						"Décrire le processus de la fécondation chez l'humain"
					],
					"g. Grossesse": [
						"Nommer les étapes du développement d'un humain lors de la grossesse (zygote, embryon, foetus)"
					],
					"h. Stades du développement humain": [
						"Décrire les stades du développement humain (enfance, adolescence, âge adulte)"
					],
					"i. Contraception": [
						"Décrire des moyens de contraception (ex. : condom, anovulants)",
						"Décrire les avantages et inconvénients de certains moyens de contraception"
					],
					"j. Moyens empêchant la fixation du zygote dans l'utérus": [
						"Nommer les moyens empêchant la fixation du zygote dans l'utérus (stérilet, pilule du lendemain)"
					],
					"k. Infections transmissibles sexuellement et par le sang (ITSS)": [
						"Nommer des ITSS",
						"Décrire des comportements permettant d'éviter de contracter une ITSS (ex. : port du condom)",
						"Décrire des comportements responsables à adopter à la suite du diagnostic d'une ITSS (ex. : informer son ou sa partenaire)"
					]
				}
			}
		},
		"La Terre et l'espace": {
			"A.  Caractéristiques de la Terre": {
				"1. Caractéristiques générales de la Terre": {
					"a. Structure interne de la Terre": [
						"Décrire les principales caractéristiques des trois parties de la structure interne de la Terre (croûte, manteau, noyau)"
					]
				},
				"2. Lithosphère": {
					"a. Caractéristiques générales de la lithosphère": [
						"Définir la lithosphère comme étant l'enveloppe externe de la Terre formée de la croûte et de la partie supérieure du manteau",
						"Décrire les principales relations entre la lithosphère et les activités humaines (ex. : maintien de la vie, agriculture, exploitation minière, aménagement du territoire)"
					],
					"b. Relief": [
						"Décrire des relations entre le relief terrestre (topologie) et les phénomènes géologiques et géophysiques (ex. : le retrait d'un glacier entraîne la formation d'une plaine)",
						"Décrire l'influence du relief terrestre sur les activités humaines (ex. : transport, construction, sports, agriculture)"
					],
					"h. Types de roches": [
						"Décrire les modes de formation de trois types de roches : ignées, métamorphiques et sédimentaires",
						"Classer des roches selon leur mode de formation (ex. : le granite est une roche ignée, le calcaire est une roche sédimentaire et l'ardoise est une roche métamorphique)",
						"Distinguer une roche d'un minéral"
					],
					"i. Minéraux": [
						"Identifier des minéraux de base à l'aide de leurs propriétés (ex. : couleur de la masse, dureté, magnétisme)"
					],
					"j. Types de sols": [
						"Classer des sols selon leur composition (ex. : teneur en sable, en argile, en matière organique)"
					]
				},
				"3. Hydrosphère": {
					"a. Caractéristiques générales de l'hydrosphère": [
						"Décrire la répartition de l'eau douce et de l'eau salée sur la surface de la Terre (ex. : les glaciers contiennent de l'eau douce non accessible)",
						"Décrire les principales interactions entre l'hydrosphère et l'atmosphère (ex. : échanges thermiques, régulation climatique, phénomènes météorologiques)"
					]
				},
				"4. Atmosphère": {
					"a. Caractéristiques générales de l'atmosphère": [
						"Situer les principales couches de l'atmosphère (troposphère, stratosphère, mésosphère, thermosphère)",
						"Décrire la composition de l'air pur au niveau de la mer (azote, oxygène, gaz carbonique, vapeur d'eau)",
						"Décrire les relations entre l'atmosphère et certaines activités humaines (ex. : loisir, transport, exploitation de l'énergie)"
					]
				}
			},
			"B. Phénomènes géologiques et géophysiques": {
				"": {
					"a. Plaque tectonique": [
						"Décrire les principaux éléments de la théorie de la tectonique des plaques (ex. : plaque, zone de subduction, dorsale océanique)"
					],
					"b. Orogenèse": [
						"Décrire le processus de formation des montagnes, des plissements et des failles (mouvements des plaques tectoniques)"
					],
					"c. Volcan": [
						"Décrire le déroulement d'une éruption volcanique",
						"Décrire la distribution géographique des volcans"
					],
					"d. Tremblement de terre": [
						"Décrire des processus à l'origine d'un tremblement de terre (ex. : mouvements des plaques tectoniques, glissements)"
					],
					"e. Érosion": [
						"Décrire certains processus d'érosion du relief terrestre (ex. : assèchement des sols par le vent, fragmentation des roches par le gel et le dégel de l'eau)"
					],
					"f. Vents": [
						"Nommer les principaux facteurs à l'origine des vents (ex. : mouvements de convection, déplacement des masses d'air)"
					],
					"g. Cycle de l'eau": [
						"Expliquer le cycle de l'eau (changement d'état et échange d'énergie)"
					],
					"h. Manifestations naturelles de l'énergie": [
						"Décrire le rôle de l'énergie solaire lors de manifestations naturelles de l'énergie (ex. : vents, tornades, ouragans, orages)"
					],
					"i. Ressources énergétiques renouvelables et non renouvelables": [
						"Distinguer des ressources énergétiques renouvelables et non renouvelables (ex. : soleil, roche en fusion, eau en mouvement, pétrole)"
					]
				}
			},
			"C. Phénomènes astronomiques": {
				"1. Notions d'astronomie": {
					"a. Gravitation universelle": [
						"Définir la gravitation comme étant une force d'attraction mutuelle qui s'exerce entre les corps"
					],
					"c. Lumière": [
						"Définir la lumière comme étant une forme d'énergie rayonnante",
						"Décrire des propriétés de la lumière : propagation en ligne droite, réflexion diffuse par des surfaces",
						"Expliquer divers phénomènes à l'aide des propriétés de la lumière (cycle du jour et de la nuit, saisons, phases de la Lune, éclipse)"
					]
				},
				"2. Système solaire": {
					"a. Caractéristiques du système solaire": [
						"Comparer certaines caractéristiques des planètes du système solaire (ex. : distances, dimensions relatives, composition)"
					],
					"b. Cycle du jour et de la nuit": [
						"Expliquer l'alternance du jour et de la nuit à l'aide du mouvement de rotation terrestre"
					],
					"c. Phases de la Lune": [
						"Décrire les phases du cycle lunaire"
					],
					"d. Éclipses": [
						"Expliquer le déroulement d'une éclipse lunaire ou solaire"
					],
					"e. Saisons": [
						"Expliquer le phénomène des saisons par la position de la Terre par rapport au Soleil (inclinaison, révolution)"
					],
					"f. Comètes": [
						"Décrire les principales parties d'une comète (noyau de glace et de roche, queues de gaz et de poussière)"
					],
					"g. Aurores boréales": [
						"Situer les régions géographiques où se produisent les aurores boréales (régions polaires)",
						"Identifier la couche atmosphérique dans laquelle se produisent les aurores boréales"
					],
					"h. Impacts météoritiques": [
						"Repérer des traces laissées par les impacts météoritiques sur le territoire québécois (ex. : cratères, astroblèmes)"
					]
				}
			}
		},
		"L'univers technologique": {
			"A. Langage des lignes": {
				"": {
					"a. Schéma de principes": [
						"Définir un schéma de principes comme étant une représentation permettant d'expliquer efficacement le fonctionnement d'un objet technique",
						"Associer aux éléments fonctionnels d'objets techniques le schéma de principes qui s'y rattache",
						"Expliquer le fonctionnement d'un objet technique simple en réalisant un schéma qui montre la ou les forces d'action ainsi que le ou les mouvements qui en résultent",
						"Nommer les parties essentielles (sous-ensembles et pièces) liées au fonctionnement d'un objet technique",
						"Indiquer certains principes des machines simples mis en évidence dans un objet technique (ex. : un levier dans une brouette et un coin dans une hache)"
					],
					"b. Schéma de construction": [
						"Définir le schéma de construction comme étant une représentation permettant d'expliquer efficacement la construction et l'assemblage d'un objet technique",
						"Associer des objets techniques quant à la forme et à l'agencement des pièces au schéma de construction qui s'y rattache",
						"Expliquer la construction d'un objet technique simple en réalisant un schéma qui met en relief l'assemblage et la combinaison des pièces",
						"Nommer les parties (pièces constitutives) d'un objet technique simple",
						"Indiquer les liaisons et les guidages sur un schéma de construction"
					]
				}
			},
			"B. Ingénierie mécanique": {
				"1. Forces et mouvements": {
					"a. Types de mouvements": [
						"Repérer des pièces qui effectuent des mouvements spécifiques dans un objet technique (mouvement de translation rectiligne, de rotation, hélicoïdal)"
					],
					"b. Effets d'une force": [
						"Expliquer les effets d'une force dans un objet technique (modification du mouvement d'un objet ou déformation d'un matériau)"
					],
					"c. Machines simples": [
						"Repérer des roues, des plans inclinés et des leviers dans des objets techniques simples (ex. : une brouette est constituée d'un levier interrésistant et d'une roue)",
						"Décrire qualitativement l'avantage mécanique de différents types de leviers (interappui, intermoteur ou interforce, interrésistant) dans des applications variées"
					]
				},
				"2. Systèmes technologiques": {
					"a. Système": [
						"Repérer un système (ensemble d'éléments reliés entre eux et exerçant une influence les uns sur les autres) dans un objet technique ou dans une application technologique",
						"Décrire la fonction globale d'un système technologique",
						"Identifier les intrants et les extrants d'un système technologique",
						"Identifier les procédés et les éléments de contrôle d'un système technologique"
					],
					"b. Composantes d'un système": [
						"Décrire le rôle des composantes d'un système technologique (ex. : expliquer le rôle des parties d'un système d'éclairage)"
					],
					"c. Transformation de l'énergie": [
						"Associer l'énergie à un rayonnement, à de la chaleur ou à un mouvement",
						"Définir la transformation de l'énergie",
						"Repérer des transformations d'énergie dans un objet technique ou un système technologique"
					]
				},
				"3. Ingénierie": {
					"a. Fonctions mécaniques élémentaires (liaison, guidage)": [
						"Décrire le rôle des liaisons et des guidages dans un objet technique Repérer un guidage dans un objet technique en considérant les liaisons en cause (ex. : la roue d'un couteau à pizza est guidée par l'intermédiaire du pivot qui lui sert de liaison)"
					],
					"h. Mécanismes de transmission du mouvement": [
						"Repérer des mécanismes de transmission du mouvement dans des objets techniques"
					],
					"k. Mécanismes de transformation du mouvement": [
						"Repérer des mécanismes de transformation du mouvement dans des objets techniques"
					]
				}
			},
			"D. Matériaux": {
				"1. Ressources matérielles": {
					"a. Matière première": [
						"Associer la matière première à la matière non transformée à la base d'une industrie (ex. : le minerai de bauxite est la matière première des usines de première transformation de l'aluminium)"
					],
					"b. Matériau": [
						"Identifier les matériaux présents dans un objet technique (ex. : une casserole est faite de deux matériaux : le métal pour le récipient et le plastique pour le revêtement de la poignée)",
						"Déterminer l'origine des matériaux qui composent un objet technique (animale, végétale, minérale ou ligneuse)"
					],
					"c. Matériel": [
						"Définir l'outillage et l'équipement comme étant le matériel nécessaire à la fabrication d'un objet (usinage, contrôle et assemblage)"
					]
				}
			},
			"E. Fabrication": {
				"": {
					"a. Cahier des charges": [
						"Définir le cahier des charges comme étant l'ensemble des contraintes liées à la conception d'un objet technique",
						"Évaluer un prototype ou un objet technique en fonction des milieux décrits dans le cahier des charges (humain, technique, industriel, économique, physique et environnemental)"
					],
					"b. Gamme de fabrication": [
						"Définir la gamme de fabrication comme étant l'ensemble des étapes à suivre pour usiner les pièces qui composent un objet technique",
						"Suivre une gamme de fabrication et d'assemblage pour fabriquer un objet ou une partie d'un objet comportant peu de pièces"
					]
				}
			}
		},
		"Techniques": {
			"A. Technologie": {
				"1. Langage graphique": {
					"a. Techniques de dessin": [
						"Choisir la vue la plus explicite d'un objet technique pour représenter la vue de face (élévation) sur un dessin",
						"Représenter les arêtes vues par une ligne pleine",
						"Représenter les arêtes cachées par une ligne pointillée",
						"Indiquer les dimensions hors tout d'un objet sur un dessin"
					],
					"b. Techniques de lecture de plans": [
						"Associer les vues représentées aux faces d'un objet technique",
						"Associer les lignes représentées aux arêtes d'un objet technique"
					],
					"c. Techniques de schématisation": [
						"Choisir la vue la plus explicite de l'objet technique à décrire",
						"Utiliser des couleurs différentes pour représenter chacune des pièces d'un objet technique",
						"Inscrire toutes les informations nécessaires pour expliquer le fonctionnement ou la construction d'un objet"
					],
					"d. Techniques d'utilisation d'échelles": [
						"Associer la vraie mesure à chacune des cotes d'un dessin",
						"Réduire ou multiplier les dimensions d'un objet technique en considérant l'échelle"
					],
					"e. Techniques d'utilisation d'instruments de dessin": [
						"Utiliser des instruments de dessin (ex. : règle, équerre) pour réaliser des schémas"
					]
				},
				"2. Fabrication": {
					"a. Techniques d'utilisation sécuritaire des machines et des outils": [
						"Utiliser des outils de façon sécuritaire (ex. : couteau à lame rétractable, marteau, tournevis, pinces)"
					],
					"b. Techniques de mesurage et traçage": [
						"Repérer l'unité de mesure sur l'instrument",
						"Positionner l'instrument de mesure de façon à avoir des points de référence fiables",
						"Adopter une bonne position lors de la lecture d'un instrument",
						"Marquer les matériaux à façonner à l'aide d'un crayon ou d'un pointeau"
					],
					"c. Techniques d'usinage et formage": [
						"Choisir les matériaux, les outils, les techniques et les procédés appropriés",
						"Tracer les lignes de référence requises",
						"Fixer la pièce à façonner",
						"Façonner la pièce en respectant les étapes des procédés d'usinage suivants : sciage, perçage, ponçage, limage"
					],
					"d. Techniques de finition": [
						"Poncer les faces ou ébavurer les arêtes de chaque pièce après le façonnage",
						"Utiliser le fini approprié (teinture, peinture)"
					],
					"e. Techniques d'assemblage": [
						"Marquer les repères (trous, points ou lignes guides)",
						"Fixer les pièces collées durant la prise",
						"Percer selon le diamètre des vis, des clous ou des rivets utilisés",
						"Fraisurer l'ouverture des trous de vis à tête plate"
					],
					"f. Techniques de montage et démontage": [
						"Identifier et rassembler les pièces et la quincaillerie",
						"Choisir les outils adéquats",
						"Pour le démontage, numéroter et noter l'emplacement des pièces"
					]
				}
			},
			"B. Science": {
				"": {
					"a. Techniques d'utilisation sécuritaire du matériel de laboratoire": [
						"Utiliser le matériel de laboratoire de façon sécuritaire (ex. : laisser refroidir une plaque chauffante, utiliser une pince à bécher)",
						"Manipuler les produits chimiques de façon sécuritaire (ex. : prélever à l'aide d'une spatule, aspirer avec une poire à pipette)"
					],
					"b. Techniques de séparation des mélanges": [
						"Effectuer la séparation de mélanges hétérogènes à l'aide des techniques de sédimentation et de décantation",
						"Effectuer la séparation de mélanges hétérogènes à l'aide d'une filtration",
						"Effectuer la séparation de diverses solutions aqueuses par évaporation ou distillation"
					],
					"c. Techniques de conception et de fabrication d'environnements": [
						"Utiliser des techniques de conception et de fabrication qui permettent de respecter les caractéristiques de l'habitat lors de la réalisation d'environnements (ex. : terrarium, aquarium, milieu de compostage)"
					],
					"d. Techniques d'utilisation d'instruments de mesure": [
						"Adopter une bonne position lors de la lecture d'un instrument",
						"Mesurer la masse d'une substance à l'aide d'une balance",
						"Mesurer le volume d'un liquide à l'aide d'un cylindre gradué approprié",
						"Mesurer le volume d'un solide insoluble par déplacement d'eau",
						"Mesurer la température à l'aide d'un thermomètre gradué"
					],
					"e. Techniques d'utilisation d'instruments d'observation": [
						"Utiliser de façon adéquate un instrument d'observation (ex. : loupe, stéréomicroscope [binoculaire], microscope)"
					]
				}
			}
		}
	},
	"Secondaire 2": {
		"L'univers matériel": {
			"A. Propriétés": {
				"1. Propriétés de la matière": {
					"a. Masse": [
						"*Définir le concept de masse",
						"*Comparer les masses de différentes substances ayant le même volume"
					],
					"b. Volume": [
						"*Définir le concept de volume",
						"*Choisir l'unité de mesure appropriée pour exprimer un volume (ex. : 120 mL ou 0,12 L ou 120 cm )",
						"*Comparer les volumes de différentes substances ayant la même masse"
					],
					"c. Température": [
						"*Décrire l'effet d'un apport de chaleur sur le degré d'agitation des particules",
						"*Définir la température comme étant une mesure du degré d'agitation des particules",
						"*Expliquer la dilatation thermique des corps"
					],
					"d. États de la matière": [
						"*Nommer les différents changements d'état de la matière (vaporisation, condensation, solidification, fusion, condensation solide, sublimation)",
						"*Interpréter le diagramme de changement d'état d'une substance pure"
					],
					"e. Acidité/basicité": [
						"*Déterminer les propriétés observables de solutions acides, basiques ou neutres (ex. : réaction au tournesol, réactivité avec un métal)",
						"*Déterminer le caractère acide ou basique de substances usuelles (ex. : eau, jus de citron, vinaigre, boissons gazeuses, lait de magnésie, produit nettoyant)"
					],
					"f. Propriétés caractéristiques": [
						"*Définir une propriété caractéristique comme étant une propriété qui aide à l'identification d'une substance ou d'un groupe de substances",
						"*Distinguer des groupes de substances par leurs propriétés caractéristiques communes (ex. : les acides rougissent le tournesol)",
						"*Associer une propriété caractéristique d'une substance ou d'un matériau à l'usage qu'on en fait (ex. : on utilise le métal pour fabriquer une casserole parce qu'il conduit bien la chaleur)"
					]
				},
				"3. Propriétés des solutions": {
					"a. Solutions": [
						"*Décrire les propriétés d'une solution aqueuse (ex. : une seule phase visible,translucide)"
					]
				}
			},
			"B. Transformations": {
				"1. Transformations de la matière": {
					"a. Conservation de la matière": [
						"*Démontrer que la matière se conserve lors d'un changement chimique (ex. : conservation de la masse lors d'une réaction de précipitation)"
					],
					"b. Mélanges": [
						"*Décrire les propriétés d'un mélange (ex. : composé de plusieurs substances, présentant une ou plusieurs phases)",
						"*Distinguer une solution ou un mélange homogène (ex. : eau potable, air, alliage) d'un mélange hétérogène (ex. : jus de tomates, smog, roche)"
					],
					"d. Séparation des mélanges": [
						"*Associer une technique de séparation au type de mélange qu'elle permet de séparer",
						"*Décrire les étapes à suivre pour séparer un mélange complexe (ex. : pour séparer de l'eau salée contenant du sable, on effectue une sédimentation, une décantation, puis une évaporation)"
					]
				},
				"2. Transformations physiques": {
					"a. Changement physique": [
						"*Décrire les caractéristiques d'un changement physique (ex. : la substance conserve ses propriétés; les molécules impliquées demeurent intactes)",
						"*Reconnaître différents changements physiques (ex. : changements d'état, préparation ou séparation d'un mélange)"
					]
				},
				"3. Transformations chimiques": {
					"a. Changement chimique": [
						"*Décrire les indices d'un changement chimique (formation d'un précipité, effervescence, changement de couleur, dégagement de chaleur ou émission de lumière)",
						"*Expliquer un changement chimique à l'aide des modifications des propriétés des substances impliquées",
						"*Nommer différents types de changements chimiques (ex. : décomposition, oxydation)"
					]
				}
			},
			"C. Organisation": {
				"1. Structure de la matière": {
					"a. Atome": [
						"*Décrire le modèle atomique de Dalton",
						"*Définir l'atome comme étant l'unité de base de la molécule"
					],
					"b. Molécule": [
						"*Décrire une molécule à l'aide du modèle atomique de Dalton (combinaison d'atomes liés chimiquement)",
						"*Représenter la formation d'une molécule à l'aide du modèle atomique de Dalton"
					],
					"c. Élément": [
						"*Définir un élément comme étant une substance pure formée d'une seule sorte d'atomes (ex. : Fe, N2)"
					],
					"d. Tableau périodique": [
						"*Décrire le tableau périodique comme un répertoire organisé des éléments"
					]
				}
			}
		},
		"L'univers vivant": {
			"A. Diversité de la vie": {
				"1. Écologie": {
					"a. Habitat": [
						"*Nommer les caractéristiques qui définissent un habitat (ex. : situation géographique, climat, flore, faune, proximité de constructions humaines)",
						"*Décrire l'habitat de certaines espèces"
					],
					"b. Niche écologique": [
						"*Nommer des caractéristiques qui définissent une niche écologique (ex. : habitat, régime alimentaire, rythme journalier)",
						"*Décrire la niche écologique d'une espèce animale"
					],
					"c. Espèce": [
						"*Nommer les caractéristiques qui définissent une espèce (caractères physiques communs, reproduction naturelle, viable et féconde)"
					],
					"d. Population": [
						"*Distinguer une population d'une espèce",
						"*Calculer le nombre d'individus d'une espèce qui occupe un territoire donné"
					]
				},
				"2. Diversité chez les vivants": {
					"a. Adaptations physiques et comportementales": [
						"*Décrire des adaptations physiques qui permettent à un animal ou à un végétal d'augmenter ses chances de survie (ex. : pelage de la même couleur que le milieu de vie, forme des feuilles)",
						"*Décrire des adaptations comportementales qui permettent à un animal ou à un végétal d'augmenter ses chances de survie (ex. : déplacement en groupes, phototropisme)"
					],
					"b. Évolution": [
						"*Décrire des étapes de l'évolution des êtres vivants",
						"*Expliquer le processus de la sélection naturelle"
					],
					"c. Taxonomie": [
						"*Définir la taxonomie comme étant un système de classification des vivants principalement basé sur leurs caractéristiques anatomiques et génétiques",
						"*Identifier une espèce à l'aide d'une clé taxonomique"
					],
					"d. Gènes et chromosomes": [
						"*Situer les chromosomes dans la cellule",
						"*Définir un gène comme étant une portion d'un chromosome",
						"*Décrire le rôle des gènes (transmission des caractères héréditaires)"
					]
				}
			},
			"B. Maintien de la vie": {
				"": {
					"a. Caractéristiques du vivant": [
						"*Décrire certaines caractéristiques communes à tous les êtres vivants (nutrition, relation, adaptation, reproduction)"
					],
					"b. Cellules végétales et animales": [
						"*Définir la cellule comme étant l'unité structurale de la vie",
						"*Nommer des fonctions vitales assurées par la cellule",
						"*Distinguer une cellule animale d'une cellule végétale"
					],
					"c. Constituants cellulaires visibles au microscope": [
						"*Identifier les principaux constituants cellulaires visibles au microscope (membrane cellulaire, cytoplasme, noyau, vacuoles)",
						"*Décrire le rôle des principaux constituants cellulaires visibles au microscope"
					],
					"d. Intrants et extrants (énergie, nutriments, déchets)": [
						"*Nommer des intrants cellulaires",
						"*Nommer des extrants cellulaires"
					],
					"e. Osmose et diffusion": [
						"*Distinguer l'osmose de la diffusion"
					],
					"f. Photosynthèse et respiration": [
						"*Nommer les intrants et les extrants impliqués dans le processus de la photosynthèse",
						"*Nommer les intrants et les extrants impliqués dans le processus de la respiration"
					]
				}
			},
			"E. Perpétuation des espèces": {
				"1. Reproduction": {
					"a. Reproduction asexuée ou sexuée": [
						"*Distinguer la reproduction asexuée de la reproduction sexuée (ex. : la reproduction sexuée requiert des gamètes)"
					],
					"b. Modes de reproduction chez les végétaux": [
						"*Décrire des modes de reproduction asexuée chez les végétaux (ex. : bouturage, marcottage)",
						"*Décrire le mode de reproduction sexuée des végétaux (plantes à fleurs)"
					],
					"c. Modes de reproduction chez les animaux": [
						"*Décrire les rôles du mâle et de la femelle lors de la reproduction chez certains groupes d'animaux (ex. : oiseaux, poissons, mammifères)"
					],
					"d. Organes reproducteurs": [
						"*Nommer les principaux organes reproducteurs masculins et féminins (pénis, testicules, vagin, ovaires, trompes de Fallope, utérus)"
					],
					"e. Gamètes": [
						"*Nommer les gamètes mâles et femelles",
						"*Décrire le rôle des gamètes dans la reproduction"
					],
					"f. Fécondation": [
						"*Décrire le processus de la fécondation chez l'humain"
					],
					"g. Grossesse": [
						"*Nommer les étapes du développement d'un humain lors de la grossesse (zygote, embryon, foetus)"
					],
					"h. Stades du développement humain": [
						"*Décrire les stades du développement humain (enfance, adolescence, âge adulte)"
					],
					"i. Contraception": [
						"*Décrire des moyens de contraception (ex. : condom, anovulants)",
						"*Décrire les avantages et inconvénients de certains moyens de contraception"
					],
					"j. Moyens empêchant la fixation du zygote dans l'utérus": [
						"*Nommer les moyens empêchant la fixation du zygote dans l'utérus (stérilet, pilule du lendemain)"
					],
					"k. Infections transmissibles sexuellement et par le sang (ITSS)": [
						"*Nommer des ITSS",
						"*Décrire des comportements permettant d'éviter de contracter une ITSS (ex. : port du condom)",
						"*Décrire des comportements responsables à adopter à la suite du diagnostic d'une ITSS (ex. : informer son ou sa partenaire)"
					]
				}
			}
		},
		"La Terre et l'espace": {
			"A.  Caractéristiques de la Terre": {
				"1. Caractéristiques générales de la Terre": {
					"a. Structure interne de la Terre": [
						"Décrire les principales caractéristiques des trois parties de la structure interne de la Terre (croûte, manteau, noyau)"
					]
				},
				"2. Lithosphère": {
					"a. Caractéristiques générales de la lithosphère": [
						"Définir la lithosphère comme étant l'enveloppe externe de la Terre formée de la croûte et de la partie supérieure du manteau",
						"Décrire les principales relations entre la lithosphère et les activités humaines (ex. : maintien de la vie, agriculture, exploitation minière, aménagement du territoire)"
					],
					"b. Relief": [
						"Décrire des relations entre le relief terrestre (topologie) et les phénomènes géologiques et géophysiques (ex. : le retrait d'un glacier entraîne la formation d'une plaine)",
						"Décrire l'influence du relief terrestre sur les activités humaines (ex. : transport, construction, sports, agriculture)"
					],
					"h. Types de roches": [
						"*Décrire les modes de formation de trois types de roches : ignées, métamorphiques et sédimentaires",
						"*Classer des roches selon leur mode de formation (ex. : le granite est une roche ignée, le calcaire est une roche sédimentaire et l'ardoise est une roche métamorphique)",
						"*Distinguer une roche d'un minéral"
					],
					"i. Minéraux": [
						"*Identifier des minéraux de base à l'aide de leurs propriétés (ex. : couleur de la masse, dureté, magnétisme)"
					],
					"j. Types de sols": [
						"*Classer des sols selon leur composition (ex. : teneur en sable, en argile, en matière organique)"
					]
				},
				"3. Hydrosphère": {
					"a. Caractéristiques générales de l'hydrosphère": [
						"*Décrire la répartition de l'eau douce et de l'eau salée sur la surface de la Terre (ex. : les glaciers contiennent de l'eau douce non accessible)",
						"*Décrire les principales interactions entre l'hydrosphère et l'atmosphère (ex. : échanges thermiques, régulation climatique, phénomènes météorologiques)"
					]
				},
				"4. Atmosphère": {
					"a. Caractéristiques générales de l'atmosphère": [
						"*Situer les principales couches de l'atmosphère (troposphère, stratosphère, mésosphère, thermosphère)",
						"*Décrire la composition de l'air pur au niveau de la mer (azote, oxygène, gaz carbonique, vapeur d'eau)",
						"*Décrire les relations entre l'atmosphère et certaines activités humaines (ex. : loisir, transport, exploitation de l'énergie)"
					]
				}
			},
			"B. Phénomènes géologiques et géophysiques": {
				"": {
					"a. Plaque tectonique": [
						"*Décrire les principaux éléments de la théorie de la tectonique des plaques (ex. : plaque, zone de subduction, dorsale océanique)"
					],
					"b. Orogenèse": [
						"*Décrire le processus de formation des montagnes, des plissements et des failles (mouvements des plaques tectoniques)"
					],
					"c. Volcan": [
						"*Décrire le déroulement d'une éruption volcanique",
						"*Décrire la distribution géographique des volcans"
					],
					"d. Tremblement de terre": [
						"*Décrire des processus à l'origine d'un tremblement de terre (ex. : mouvements des plaques tectoniques, glissements)"
					],
					"e. Érosion": [
						"*Décrire certains processus d'érosion du relief terrestre (ex. : assèchement des sols par le vent, fragmentation des roches par le gel et le dégel de l'eau)"
					],
					"f. Vents": [
						"*Nommer les principaux facteurs à l'origine des vents (ex. : mouvements de convection, déplacement des masses d'air)"
					],
					"g. Cycle de l'eau": [
						"*Expliquer le cycle de l'eau (changement d'état et échange d'énergie)"
					],
					"h. Manifestations naturelles de l'énergie": [
						"*Décrire le rôle de l'énergie solaire lors de manifestations naturelles de l'énergie (ex. : vents, tornades, ouragans, orages)"
					],
					"i. Ressources énergétiques renouvelables et non renouvelables": [
						"*Distinguer des ressources énergétiques renouvelables et non renouvelables (ex. : soleil, roche en fusion, eau en mouvement, pétrole)"
					]
				}
			},
			"C. Phénomènes astronomiques": {
				"1. Notions d'astronomie": {
					"a. Gravitation universelle": [
						"*Définir la gravitation comme étant une force d'attraction mutuelle qui s'exerce entre les corps"
					],
					"c. Lumière": [
						"*Définir la lumière comme étant une forme d'énergie rayonnante",
						"*Décrire des propriétés de la lumière : propagation en ligne droite, réflexion diffuse par des surfaces",
						"*Expliquer divers phénomènes à l'aide des propriétés de la lumière (cycle du jour et de la nuit, saisons, phases de la Lune, éclipse)"
					]
				},
				"2. Système solaire": {
					"a. Caractéristiques du système solaire": [
						"*Comparer certaines caractéristiques des planètes du système solaire (ex. : distances, dimensions relatives, composition)"
					],
					"b. Cycle du jour et de la nuit": [
						"*Expliquer l'alternance du jour et de la nuit à l'aide du mouvement de rotation terrestre"
					],
					"c. Phases de la Lune": [
						"*Décrire les phases du cycle lunaire"
					],
					"d. Éclipses": [
						"*Expliquer le déroulement d'une éclipse lunaire ou solaire"
					],
					"e. Saisons": [
						"*Expliquer le phénomène des saisons par la position de la Terre par rapport au Soleil (inclinaison, révolution)"
					],
					"f. Comètes": [
						"*Décrire les principales parties d'une comète (noyau de glace et de roche, queues de gaz et de poussière)"
					],
					"g. Aurores boréales": [
						"*Situer les régions géographiques où se produisent les aurores boréales (régions polaires)",
						"*Identifier la couche atmosphérique dans laquelle se produisent les aurores boréales"
					],
					"h. Impacts météoritiques": [
						"*Repérer des traces laissées par les impacts météoritiques sur le territoire québécois (ex. : cratères, astroblèmes)"
					]
				}
			}
		},
		"L'univers technologique": {
			"A. Langage des lignes": {
				"": {
					"a. Schéma de principes": [
						"*Définir un schéma de principes comme étant une représentation permettant d'expliquer efficacement le fonctionnement d'un objet technique",
						"*Associer aux éléments fonctionnels d'objets techniques le schéma de principes qui s'y rattache",
						"*Expliquer le fonctionnement d'un objet technique simple en réalisant un schéma qui montre la ou les forces d'action ainsi que le ou les mouvements qui en résultent",
						"*Nommer les parties essentielles (sous-ensembles et pièces) liées au fonctionnement d'un objet technique",
						"*Indiquer certains principes des machines simples mis en évidence dans un objet technique (ex. : un levier dans une brouette et un coin dans une hache)"
					],
					"b. Schéma de construction": [
						"*Définir le schéma de construction comme étant une représentation permettant d'expliquer efficacement la construction et l'assemblage d'un objet technique",
						"*Associer des objets techniques quant à la forme et à l'agencement des pièces au schéma de construction qui s'y rattache",
						"*Expliquer la construction d'un objet technique simple en réalisant un schéma qui met en relief l'assemblage et la combinaison des pièces",
						"*Nommer les parties (pièces constitutives) d'un objet technique simple",
						"*Indiquer les liaisons et les guidages sur un schéma de construction"
					]
				}
			},
			"B. Ingénierie mécanique": {
				"1. Forces et mouvements": {
					"a. Types de mouvements": [
						"*Repérer des pièces qui effectuent des mouvements spécifiques dans un objet technique (mouvement de translation rectiligne, de rotation, hélicoïdal)"
					],
					"b. Effets d'une force": [
						"*Expliquer les effets d'une force dans un objet technique (modification du mouvement d'un objet ou déformation d'un matériau)"
					],
					"c. Machines simples": [
						"*Repérer des roues, des plans inclinés et des leviers dans des objets techniques simples (ex. : une brouette est constituée d'un levier interrésistant et d'une roue)",
						"*Décrire qualitativement l'avantage mécanique de différents types de leviers (interappui, intermoteur ou interforce, interrésistant) dans des applications variées"
					]
				},
				"2. Systèmes technologiques": {
					"a. Système": [
						"*Repérer un système (ensemble d'éléments reliés entre eux et exerçant une influence les uns sur les autres) dans un objet technique ou dans une application technologique",
						"*Décrire la fonction globale d'un système technologique",
						"*Identifier les intrants et les extrants d'un système technologique",
						"*Identifier les procédés et les éléments de contrôle d'un système technologique"
					],
					"b. Composantes d'un système": [
						"*Décrire le rôle des composantes d'un système technologique (ex. : expliquer le rôle des parties d'un système d'éclairage)"
					],
					"c. Transformation de l'énergie": [
						"*Associer l'énergie à un rayonnement, à de la chaleur ou à un mouvement",
						"*Définir la transformation de l'énergie",
						"*Repérer des transformations d'énergie dans un objet technique ou un système technologique"
					]
				},
				"3. Ingénierie": {
					"a. Fonctions mécaniques élémentaires (liaison, guidage)": [
						"*Décrire le rôle des liaisons et des guidages dans un objet technique Repérer un guidage dans un objet technique en considérant les liaisons en cause (ex. : la roue d'un couteau à pizza est guidée par l'intermédiaire du pivot qui lui sert de liaison)"
					],
					"h. Mécanismes de transmission du mouvement": [
						"*Repérer des mécanismes de transmission du mouvement dans des objets techniques"
					],
					"k. Mécanismes de transformation du mouvement": [
						"*Repérer des mécanismes de transformation du mouvement dans des objets techniques"
					]
				}
			},
			"D. Matériaux": {
				"1. Ressources matérielles": {
					"a. Matière première": [
						"*Associer la matière première à la matière non transformée à la base d'une industrie (ex. : le minerai de bauxite est la matière première des usines de première transformation de l'aluminium)"
					],
					"b. Matériau": [
						"*Identifier les matériaux présents dans un objet technique (ex. : une casserole est faite de deux matériaux : le métal pour le récipient et le plastique pour le revêtement de la poignée)",
						"*Déterminer l'origine des matériaux qui composent un objet technique (animale, végétale, minérale ou ligneuse)"
					],
					"c. Matériel": [
						"*Définir l'outillage et l'équipement comme étant le matériel nécessaire à la fabrication d'un objet (usinage, contrôle et assemblage)"
					]
				}
			},
			"E. Fabrication": {
				"": {
					"a. Cahier des charges": [
						"*Définir le cahier des charges comme étant l'ensemble des contraintes liées à la conception d'un objet technique",
						"*Évaluer un prototype ou un objet technique en fonction des milieux décrits dans le cahier des charges (humain, technique, industriel, économique, physique et environnemental)"
					],
					"b. Gamme de fabrication": [
						"*Définir la gamme de fabrication comme étant l'ensemble des étapes à suivre pour usiner les pièces qui composent un objet technique",
						"*Suivre une gamme de fabrication et d'assemblage pour fabriquer un objet ou une partie d'un objet comportant peu de pièces"
					]
				}
			}
		},
		"Techniques": {
			"A. Technologie": {
				"1. Langage graphique": {
					"a. Techniques de dessin": [
						"*Choisir la vue la plus explicite d'un objet technique pour représenter la vue de face (élévation) sur un dessin",
						"*Représenter les arêtes vues par une ligne pleine",
						"*Représenter les arêtes cachées par une ligne pointillée",
						"*Indiquer les dimensions hors tout d'un objet sur un dessin"
					],
					"b. Techniques de lecture de plans": [
						"*Associer les vues représentées aux faces d'un objet technique",
						"*Associer les lignes représentées aux arêtes d'un objet technique"
					],
					"c. Techniques de schématisation": [
						"Choisir la vue la plus explicite de l'objet technique à décrire",
						"*Utiliser des couleurs différentes pour représenter chacune des pièces d'un objet technique",
						"Inscrire toutes les informations nécessaires pour expliquer le fonctionnement ou la construction d'un objet"
					],
					"d. Techniques d'utilisation d'échelles": [
						"*Associer la vraie mesure à chacune des cotes d'un dessin",
						"*Réduire ou multiplier les dimensions d'un objet technique en considérant l'échelle"
					],
					"e. Techniques d'utilisation d'instruments de dessin": [
						"*Utiliser des instruments de dessin (ex. : règle, équerre) pour réaliser des schémas"
					]
				},
				"2. Fabrication": {
					"a. Techniques d'utilisation sécuritaire des machines et des outils": [
						"*Utiliser des outils de façon sécuritaire (ex. : couteau à lame rétractable, marteau, tournevis, pinces)"
					],
					"b. Techniques de mesurage et traçage": [
						"*Repérer l'unité de mesure sur l'instrument",
						"*Positionner l'instrument de mesure de façon à avoir des points de référence fiables",
						"*Adopter une bonne position lors de la lecture d'un instrument",
						"*Marquer les matériaux à façonner à l'aide d'un crayon ou d'un pointeau"
					],
					"c. Techniques d'usinage et formage": [
						"*Choisir les matériaux, les outils, les techniques et les procédés appropriés",
						"*Tracer les lignes de référence requises",
						"*Fixer la pièce à façonner",
						"*Façonner la pièce en respectant les étapes des procédés d'usinage suivants : sciage, perçage, ponçage, limage"
					],
					"d. Techniques de finition": [
						"*Poncer les faces ou ébavurer les arêtes de chaque pièce après le façonnage",
						"*Utiliser le fini approprié (teinture, peinture)"
					],
					"e. Techniques d'assemblage": [
						"*Marquer les repères (trous, points ou lignes guides)",
						"*Fixer les pièces collées durant la prise",
						"*Percer selon le diamètre des vis, des clous ou des rivets utilisés",
						"*Fraisurer l'ouverture des trous de vis à tête plate"
					],
					"f. Techniques de montage et démontage": [
						"*Identifier et rassembler les pièces et la quincaillerie",
						"*Choisir les outils adéquats"]
				}
			}
		}
	}
}

var PDA3 = {
	"Secondaire 1": {
		"L’univers matériel": {
			"A. Propriétés": {
				"1. Propriétés de la matière": {
					"a. Masse": [
						"Définir le concept de masse",
						"Comparer les masses de différentes substances ayant le même volume"
					],
					"b. Volume": [
						"Définir le concept de volume",
						"Choisir l’unité de mesure appropriée pour exprimer un volume (ex. : 120 mL ou 0,12 L ou 120 cm )",
						"Comparer les volumes de différentes substances ayant la même masse"
					],
					"c. Température": [
						"Décrire l’effet d’un apport de chaleur sur le degré d’agitation des particules",
						"Définir la température comme étant une mesure du degré d’agitation des particules",
						"Expliquer la dilatation thermique des corps"
					],
					"d. États de la matière": [
						"Nommer les différents changements d’état de la matière (vaporisation, condensation, solidification, fusion, condensation solide, sublimation)",
						"Interpréter le diagramme de changement d’état d’une substance pure"
					],
					"e. Acidité/basicité": [
						"Déterminer les propriétés observables de solutions acides, basiques ou neutres (ex. : réaction au tournesol, réactivité avec un métal)",
						"Déterminer le caractère acide ou basique de substances usuelles (ex. : eau, jus de citron, vinaigre, boissons gazeuses, lait de magnésie, produit nettoyant)"
					],
					"f. Propriétés caractéristiques": [
						"Définir une propriété caractéristique comme étant une propriété qui aide à l’identification d’une substance ou d’un groupe de substances",
						"Distinguer des groupes de substances par leurs propriétés caractéristiques communes (ex. : les acides rougissent le tournesol)",
						"Associer une propriété caractéristique d’une substance ou d’un matériau à l’usage qu’on en fait (ex. : on utilise le métal pour fabriquer une casserole parce qu’il conduit bien la chaleur)"
					]
				},
				"3. Propriétés des solutions": {
					"a. Solutions": [
						"Décrire les propriétés d’une solution aqueuse (ex. : une seule phase visible,translucide)"
					]
				}
			},
			"B. Transformations": {
				"1. Transformations de la matière": {
					"a. Conservation de la matière": [
						"Démontrer que la matière se conserve lors d’un changement chimique (ex. : conservation de la masse lors d’une réaction de précipitation)"
					],
					"b. Mélanges": [
						"Décrire les propriétés d’un mélange (ex. : composé de plusieurs substances, présentant une ou plusieurs phases)",
						"Distinguer une solution ou un mélange homogène (ex. : eau potable, air, alliage) d’un mélange hétérogène (ex. : jus de tomates, smog, roche)"
					],
					"d. Séparation des mélanges": [
						"Associer une technique de séparation au type de mélange qu’elle permet de séparer",
						"Décrire les étapes à suivre pour séparer un mélange complexe (ex. : pour séparer de l’eau salée contenant du sable, on effectue une sédimentation, une décantation, puis une évaporation)"
					]
				},
				"2. Transformations physiques": {
					"a. Changement physique": [
						"Décrire les caractéristiques d’un changement physique (ex. : la substance conserve ses propriétés; les molécules impliquées demeurent intactes)",
						"Reconnaître différents changements physiques (ex. : changements d’état, préparation ou séparation d’un mélange)"
					]
				},
				"3. Transformations chimiques": {
					"a. Changement chimique": [
						"Décrire les indices d’un changement chimique (formation d’un précipité, effervescence, changement de couleur, dégagement de chaleur ou émission de lumière)",
						"Expliquer un changement chimique à l’aide des modifications des propriétés des substances impliquées",
						"Nommer différents types de changements chimiques (ex. : décomposition, oxydation)"
					]
				}
			},
			"C. Organisation": {
				"1. Structure de la matière": {
					"a. Atome": [
						"Décrire le modèle atomique de Dalton",
						"Définir l’atome comme étant l’unité de base de la molécule"
					],
					"b. Molécule": [
						"Décrire une molécule à l’aide du modèle atomique de Dalton (combinaison d’atomes liés chimiquement)",
						"Représenter la formation d’une molécule à l’aide du modèle atomique de Dalton"
					],
					"c. Élément": [
						"Définir un élément comme étant une substance pure formée d’une seule sorte d’atomes (ex. : Fe, N2)"
					],
					"d. Tableau périodique": [
						"Décrire le tableau périodique comme un répertoire organisé des éléments"
					]
				}
			}
		},
		"L’univers vivant": {
			"A. Diversité de la vie": {
				"1. Écologie": {
					"a. Habitat": [
						"Nommer les caractéristiques qui définissent un habitat (ex. : situation géographique, climat, flore, faune, proximité de constructions humaines)",
						"Décrire l’habitat de certaines espèces"
					],
					"b. Niche écologique": [
						"Nommer des caractéristiques qui définissent une niche écologique (ex. : habitat, régime alimentaire, rythme journalier)",
						"Décrire la niche écologique d’une espèce animale"
					],
					"c. Espèce": [
						"Nommer les caractéristiques qui définissent une espèce (caractères physiques communs, reproduction naturelle, viable et féconde)"
					],
					"d. Population": [
						"Distinguer une population d’une espèce",
						"Calculer le nombre d'individus d'une espèce qui occupe un territoire donné"
					]
				},
				"2. Diversité chez les vivants": {
					"a. Adaptations physiques et comportementales": [
						"Décrire des adaptations physiques qui permettent à un animal ou à un végétal d’augmenter ses chances de survie (ex. : pelage de la même couleur que le milieu de vie, forme des feuilles)",
						"Décrire des adaptations comportementales qui permettent à un animal ou à un végétal d’augmenter ses chances de survie (ex. : déplacement en groupes, phototropisme)"
					],
					"b. Évolution": [
						"Décrire des étapes de l’évolution des êtres vivants",
						"Expliquer le processus de la sélection naturelle"
					],
					"c. Taxonomie": [
						"Définir la taxonomie comme étant un système de classification des vivants principalement basé sur leurs caractéristiques anatomiques et génétiques",
						"Identifier une espèce à l’aide d’une clé taxonomique"
					],
					"d. Gènes et chromosomes": [
						"Situer les chromosomes dans la cellule",
						"Définir un gène comme étant une portion d’un chromosome",
						" Décrire le rôle des gènes (transmission des caractères héréditaires)"
					]
				}
			},
			"B. Maintien de la vie": {
				"2. Diversité chez les vivants": {
					"a. Caractéristiques du vivant": [
						"Décrire certaines caractéristiques communes à tous les êtres vivants (nutrition, relation, adaptation, reproduction)"
					],
					"b. Cellules végétales et animales": [
						"Définir la cellule comme étant l’unité structurale de la vie",
						"Nommer des fonctions vitales assurées par la cellule",
						"Distinguer une cellule animale d’une cellule végétale"
					],
					"c. Constituants cellulaires visibles au microscope": [
						"Identifier les principaux constituants cellulaires visibles au microscope (membrane cellulaire, cytoplasme, noyau, vacuoles)",
						"Décrire le rôle des principaux constituants cellulaires visibles au microscope"
					],
					"d. Intrants et extrants (énergie, nutriments, déchets)": [
						"Nommer des intrants cellulaires",
						"Nommer des extrants cellulaires"
					],
					"e. Osmose et diffusion": [
						"Distinguer l’osmose de la diffusion"
					],
					"f. Photosynthèse et respiration": [
						"Nommer les intrants et les extrants impliqués dans le processus de la photosynthèse",
						"Nommer les intrants et les extrants impliqués dans le processus de la respiration"
					]
				}
			},
			"E. Perpétuation des espèces": {
				"1. Reproduction": {
					"a. Reproduction asexuée ou sexuée": [
						"Distinguer la reproduction asexuée de la reproduction sexuée (ex. : la reproduction sexuée requiert des gamètes)"
					],
					"b. Modes de reproduction chez les végétaux": [
						"Décrire des modes de reproduction asexuée chez les végétaux (ex. : bouturage, marcottage)",
						"Décrire le mode de reproduction sexuée des végétaux (plantes à fleurs)"
					],
					"c. Modes de reproduction chez les animaux": [
						"Décrire les rôles du mâle et de la femelle lors de la reproduction chez certains groupes d’animaux (ex. : oiseaux, poissons, mammifères)"
					],
					"d. Organes reproducteurs": [
						"Nommer les principaux organes reproducteurs masculins et féminins (pénis, testicules, vagin, ovaires, trompes de Fallope, utérus)"
					],
					"e. Gamètes": [
						"Nommer les gamètes mâles et femelles",
						"Décrire le rôle des gamètes dans la reproduction"
					],
					"f. Fécondation": [
						"Décrire le processus de la fécondation chez l’humain"
					],
					"g. Grossesse": [
						"Nommer les étapes du développement d’un humain lors de la grossesse (zygote, embryon, foetus)"
					],
					"h. Stades du développement humain": [
						"Décrire les stades du développement humain (enfance, adolescence, âge adulte)"
					],
					"i. Contraception": [
						"Décrire des moyens de contraception (ex. : condom, anovulants)",
						"Décrire les avantages et inconvénients de certains moyens de contraception"
					],
					"j. Moyens empêchant la fixation du zygote dans l’utérus": [
						"Nommer les moyens empêchant la fixation du zygote dans l’utérus (stérilet, pilule du lendemain)"
					],
					"k. Infections transmissibles sexuellement et par le sang (ITSS)": [
						"Nommer des ITSS",
						"Décrire des comportements permettant d’éviter de contracter une ITSS (ex. : port du condom)",
						"Décrire des comportements responsables à adopter à la suite du diagnostic d’une ITSS (ex. : informer son ou sa partenaire)"
					]
				}
			}
		},
		"La Terre et l’espace": {
			"A.  Caractéristiques de la Terre": {
				"1. Caractéristiques générales de la Terre": {
					"a. Structure interne de la Terre": [
						"Décrire les principales caractéristiques des trois parties de la structure interne de la Terre (croûte, manteau, noyau)"
					]
				},
				"2. Lithosphère": {
					"a. Caractéristiques générales de la lithosphère": [
						"Définir la lithosphère comme étant l’enveloppe externe de la Terre formée de la croûte et de la partie supérieure du manteau",
						"Décrire les principales relations entre la lithosphère et les activités humaines (ex. : maintien de la vie, agriculture, exploitation minière, aménagement du territoire)"
					],
					"b. Relief": [
						"Décrire des relations entre le relief terrestre (topologie) et les phénomènes géologiques et géophysiques (ex. : le retrait d’un glacier entraîne la formation d’une plaine)",
						"Décrire l’influence du relief terrestre sur les activités humaines (ex. : transport, construction, sports, agriculture)"
					],
					"h. Types de roches": [
						"Décrire les modes de formation de trois types de roches : ignées, métamorphiques et sédimentaires",
						"Classer des roches selon leur mode de formation (ex. : le granite est une roche ignée, le calcaire est une roche sédimentaire et l’ardoise est une roche métamorphique)",
						"Distinguer une roche d’un minéral"
					],
					"i. Minéraux": [
						"Identifier des minéraux de base à l’aide de leurs propriétés (ex. : couleur de la masse, dureté, magnétisme)"
					],
					"j. Types de sols": [
						"Classer des sols selon leur composition (ex. : teneur en sable, en argile, en matière organique)"
					]
				},
				"3. Hydrosphère": {
					"a. Caractéristiques générales de l’hydrosphère": [
						"Décrire la répartition de l’eau douce et de l’eau salée sur la surface de la Terre (ex. : les glaciers contiennent de l’eau douce non accessible)",
						"Décrire les principales interactions entre l’hydrosphère et l’atmosphère (ex. : échanges thermiques, régulation climatique, phénomènes météorologiques)"
					]
				},
				"4. Atmosphère": {
					"a. Caractéristiques générales de l’atmosphère": [
						"Situer les principales couches de l’atmosphère (troposphère, stratosphère, mésosphère, thermosphère)",
						"Décrire la composition de l’air pur au niveau de la mer (azote, oxygène, gaz carbonique, vapeur d’eau)",
						"Décrire les relations entre l’atmosphère et certaines activités humaines (ex. : loisir, transport, exploitation de l’énergie)"
					]
				}
			},
			"B. Phénomènes géologiques et géophysiques": {
				"4. Atmosphère": {
					"a. Plaque tectonique": [
						"Décrire les principaux éléments de la théorie de la tectonique des plaques (ex. : plaque, zone de subduction, dorsale océanique)"
					],
					"b. Orogenèse": [
						"Décrire le processus de formation des montagnes, des plissements et des failles (mouvements des plaques tectoniques)"
					],
					"c. Volcan": [
						"Décrire le déroulement d’une éruption volcanique",
						"Décrire la distribution géographique des volcans"
					],
					"d. Tremblement de terre": [
						"Décrire des processus à l’origine d’un tremblement de terre (ex. : mouvements des plaques tectoniques, glissements)"
					],
					"e. Érosion": [
						"Décrire certains processus d’érosion du relief terrestre (ex. : assèchement des sols par le vent, fragmentation des roches par le gel et le dégel de l’eau)"
					],
					"f. Vents": [
						"Nommer les principaux facteurs à l’origine des vents (ex. : mouvements de convection, déplacement des masses d’air)"
					],
					"g. Cycle de l’eau": [
						"Expliquer le cycle de l’eau (changement d’état et échange d’énergie)"
					],
					"h. Manifestations naturelles de l’énergie": [
						"Décrire le rôle de l’énergie solaire lors de manifestations naturelles de l’énergie (ex. : vents, tornades, ouragans, orages)"
					],
					"i. Ressources énergétiques renouvelables et non renouvelables": [
						"Distinguer des ressources énergétiques renouvelables et non renouvelables (ex. : soleil, roche en fusion, eau en mouvement, pétrole)"
					]
				}
			},
			"C. Phénomènes astronomiques": {
				"1. Notions d’astronomie": {
					"a. Gravitation universelle": [
						"Définir la gravitation comme étant une force d’attraction mutuelle qui s’exerce entre les corps"
					],
					"c. Lumière": [
						"Définir la lumière comme étant une forme d’énergie rayonnante",
						"Décrire des propriétés de la lumière : propagation en ligne droite, réflexion diffuse par des surfaces",
						"Expliquer divers phénomènes à l’aide des propriétés de la lumière (cycle du jour et de la nuit, saisons, phases de la Lune, éclipse)"
					]
				},
				"2. Système solaire": {
					"a. Caractéristiques du système solaire": [
						"Comparer certaines caractéristiques des planètes du système solaire (ex. : distances, dimensions relatives, composition)"
					],
					"b. Cycle du jour et de la nuit": [
						"Expliquer l’alternance du jour et de la nuit à l’aide du mouvement de rotation terrestre"
					],
					"c. Phases de la Lune": [
						"Décrire les phases du cycle lunaire"
					],
					"d. Éclipses": [
						"Expliquer le déroulement d’une éclipse lunaire ou solaire"
					],
					"e. Saisons": [
						"Expliquer le phénomène des saisons par la position de la Terre par rapport au Soleil (inclinaison, révolution)"
					],
					"f. Comètes": [
						"Décrire les principales parties d’une comète (noyau de glace et de roche, queues de gaz et de poussière)"
					],
					"g. Aurores boréales": [
						"Situer les régions géographiques où se produisent les aurores boréales (régions polaires)",
						"Identifier la couche atmosphérique dans laquelle se produisent les aurores boréales"
					],
					"h. Impacts météoritiques": [
						"Repérer des traces laissées par les impacts météoritiques sur le territoire québécois (ex. : cratères, astroblèmes)"
					]
				}
			}
		},
		"L'univers technologique": {
			"A. Langage des lignes": {
				"2. Système solaire": {
					"a. Schéma de principes": [
						"Définir un schéma de principes comme étant une représentation permettant d’expliquer efficacement le fonctionnement d’un objet technique",
						"Associer aux éléments fonctionnels d’objets techniques le schéma de principes qui s’y rattache",
						"Expliquer le fonctionnement d’un objet technique simple en réalisant un schéma qui montre la ou les forces d’action ainsi que le ou les mouvements qui en résultent",
						"Nommer les parties essentielles (sous-ensembles et pièces) liées au fonctionnement d’un objet technique",
						"Indiquer certains principes des machines simples mis en évidence dans un objet technique (ex. : un levier dans une brouette et un coin dans une hache)"
					],
					"b. Schéma de construction": [
						"Définir le schéma de construction comme étant une représentation permettant d’expliquer efficacement la construction et l’assemblage d’un objet technique",
						"Associer des objets techniques quant à la forme et à l’agencement des pièces au schéma de construction qui s’y rattache",
						"Expliquer la construction d’un objet technique simple en réalisant un schéma qui met en relief l’assemblage et la combinaison des pièces",
						"Nommer les parties (pièces constitutives) d’un objet technique simple",
						"Indiquer les liaisons et les guidages sur un schéma de construction"
					]
				}
			},
			"B. Ingénierie mécanique": {
				"1. Forces et mouvements": {
					"a. Types de mouvements": [
						"Repérer des pièces qui effectuent des mouvements spécifiques dans un objet technique (mouvement de translation rectiligne, de rotation, hélicoïdal)"
					],
					"b. Effets d’une force": [
						"Expliquer les effets d’une force dans un objet technique (modification du mouvement d’un objet ou déformation d’un matériau)"
					],
					"c. Machines simples": [
						"Repérer des roues, des plans inclinés et des leviers dans des objets techniques simples (ex. : une brouette est constituée d'un levier interrésistant et d’une roue)",
						"Décrire qualitativement l’avantage mécanique de différents types de leviers (interappui, intermoteur ou interforce, interrésistant) dans des applications variées"
					]
				},
				"2. Systèmes technologiques": {
					"a. Système": [
						"Repérer un système (ensemble d’éléments reliés entre eux et exerçant une influence les uns sur les autres) dans un objet technique ou dans une application technologique",
						"Décrire la fonction globale d’un système technologique",
						"Identifier les intrants et les extrants d’un système technologique",
						" Identifier les procédés et les éléments de contrôle d’un système technologique"
					],
					"b. Composantes d’un système": [
						"Décrire le rôle des composantes d’un système technologique (ex. : expliquer le rôle des parties d’un système d’éclairage)"
					],
					"c. Transformation de l’énergie": [
						"Associer l’énergie à un rayonnement, à de la chaleur ou à un mouvement",
						"Définir la transformation de l’énergie",
						"Repérer des transformations d’énergie dans un objet technique ou un système technologique"
					]
				},
				"3. Ingénierie": {
					"a. Fonctions mécaniques élémentaires (liaison, guidage)": [
						"Décrire le rôle des liaisons et des guidages dans un objet technique Repérer un guidage dans un objet technique en considérant les liaisons en cause (ex. : la roue d’un couteau à pizza est guidée par l’intermédiaire du pivot qui lui sert de liaison)"
					],
					"h. Mécanismes de transmission du mouvement": [
						"Repérer des mécanismes de transmission du mouvement dans des objets techniques"
					],
					"k. Mécanismes de transformation du mouvement": [
						"Repérer des mécanismes de transformation du mouvement dans des objets techniques"
					]
				}
			},
			"D. Matériaux": {
				"1. Ressources matérielles": {
					"a. Matière première": [
						"Associer la matière première à la matière non transformée à la base d’une industrie (ex. : le minerai de bauxite est la matière première des usines de première transformation de l’aluminium)"
					],
					"b. Matériau": [
						"Identifier les matériaux présents dans un objet technique (ex. : une casserole est faite de deux matériaux : le métal pour le récipient et le plastique pour le revêtement de la poignée)",
						"Déterminer l’origine des matériaux qui composent un objet technique (animale, végétale, minérale ou ligneuse)"
					],
					"c. Matériel": [
						"Définir l’outillage et l’équipement comme étant le matériel nécessaire à la fabrication d’un objet (usinage, contrôle et assemblage)"
					]
				}
			},
			"E. Fabrication": {
				"1. Ressources matérielles": {
					"a. Cahier des charges": [
						"Définir le cahier des charges comme étant l’ensemble des contraintes liées à la conception d’un objet technique",
						"Évaluer un prototype ou un objet technique en fonction des milieux décrits dans le cahier des charges (humain, technique, industriel, économique, physique et environnemental)"
					],
					"b. Gamme de fabrication": [
						"Définir la gamme de fabrication comme étant l’ensemble des étapes à suivre pour usiner les pièces qui composent un objet technique",
						"Suivre une gamme de fabrication et d’assemblage pour fabriquer un objet ou une partie d’un objet comportant peu de pièces"
					]
				}
			}
		},
		"Techniques": {
			"A. Technologie": {
				"1. Langage graphique": {
					"a. Techniques de dessin": [
						"Choisir la vue la plus explicite d’un objet technique pour représenter la vue de face (élévation) sur un dessin",
						"Représenter les arêtes vues par une ligne pleine",
						"Représenter les arêtes cachées par une ligne pointillée",
						"Indiquer les dimensions hors tout d’un objet sur un dessin"
					],
					"b. Techniques de lecture de plans": [
						"Associer les vues représentées aux faces d’un objet technique",
						"Associer les lignes représentées aux arêtes d’un objet technique"
					],
					"c. Techniques de schématisation": [
						"Choisir la vue la plus explicite de l’objet technique à décrire",
						"Utiliser des couleurs différentes pour représenter chacune des pièces d’un objet technique",
						"Inscrire toutes les informations nécessaires pour expliquer le fonctionnement ou la construction d’un objet"
					],
					"d. Techniques d’utilisation d’échelles": [
						"Associer la vraie mesure à chacune des cotes d’un dessin",
						"Réduire ou multiplier les dimensions d’un objet technique en considérant l’échelle"
					],
					"e. Techniques d’utilisation d’instruments de dessin": [
						"Utiliser des instruments de dessin (ex. : règle, équerre) pour réaliser des schémas"
					]
				},
				"2. Fabrication": {
					"a. Techniques d’utilisation sécuritaire des machines et des outils": [
						"Utiliser des outils de façon sécuritaire (ex. : couteau à lame rétractable, marteau, tournevis, pinces)"
					],
					"b. Techniques de mesurage et traçage": [
						"Repérer l’unité de mesure sur l’instrument",
						"Positionner l’instrument de mesure de façon à avoir des points de référence fiables",
						"Adopter une bonne position lors de la lecture d’un instrument",
						"Marquer les matériaux à façonner à l’aide d’un crayon ou d’un pointeau"
					],
					"c. Techniques d’usinage et formage": [
						"Choisir les matériaux, les outils, les techniques et les procédés appropriés",
						"Tracer les lignes de référence requises",
						"Fixer la pièce à façonner",
						"Façonner la pièce en respectant les étapes des procédés d’usinage suivants : sciage, perçage, ponçage, limage"
					],
					"d. Techniques de finition": [
						"Poncer les faces ou ébavurer les arêtes de chaque pièce après le façonnage",
						"Utiliser le fini approprié (teinture, peinture)"
					],
					"e. Techniques d’assemblage": [
						"Marquer les repères (trous, points ou lignes guides)",
						"Fixer les pièces collées durant la prise",
						"Percer selon le diamètre des vis, des clous ou des rivets utilisés",
						"Fraisurer l’ouverture des trous de vis à tête plate"
					],
					"f. Techniques de montage et démontage": [
						"Identifier et rassembler les pièces et la quincaillerie",
						"Choisir les outils adéquats",
						"Pour le démontage, numéroter et noter l’emplacement des pièces"
					]
				}
			},
			"B. Science": {
				"2. Fabrication": {
					"a. Techniques d’utilisation sécuritaire du matériel de laboratoire": [
						"Utiliser le matériel de laboratoire de façon sécuritaire (ex. : laisser refroidir une plaque chauffante, utiliser une pince à bécher)",
						"Manipuler les produits chimiques de façon sécuritaire (ex. : prélever à l’aide d’une spatule, aspirer avec une poire à pipette)"
					],
					"b. Techniques de séparation des mélanges": [
						"Effectuer la séparation de mélanges hétérogènes à l’aide des techniques de sédimentation et de décantation",
						"Effectuer la séparation de mélanges hétérogènes à l’aide d’une filtration",
						"Effectuer la séparation de diverses solutions aqueuses par évaporation ou distillation"
					],
					"c. Techniques de conception et de fabrication d’environnements": [
						"Utiliser des techniques de conception et de fabrication qui permettent de respecter les caractéristiques de l’habitat lors de la réalisation d’environnements (ex. : terrarium, aquarium, milieu de compostage)"
					],
					"d. Techniques d’utilisation d’instruments de mesure": [
						"Adopter une bonne position lors de la lecture d’un instrument",
						"Mesurer la masse d’une substance à l’aide d’une balance",
						"Mesurer le volume d’un liquide à l’aide d’un cylindre gradué approprié",
						"Mesurer le volume d’un solide insoluble par déplacement d’eau",
						"Mesurer la température à l’aide d’un thermomètre gradué"
					],
					"e. Techniques d’utilisation d’instruments d’observation": [
						"Utiliser de façon adéquate un instrument d’observation (ex. : loupe, stéréomicroscope [binoculaire], microscope)"
					]
				}
			}
		}
	}
}

var PDA = GouvDocumentation.science_et_technologie_sec_4_ST_STE

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
var Matériel = {
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

var Stratégies = GouvDocumentation.strategie_apprentissage

var total_dict_access: Dictionary = {
		"Notions": PDA, 
		"Compétences": PFEQ, 
		"Matériel": Matériel
	}
@onready var TreesPaths: Array[NodePath] = []

var infos: Dictionary = {}
var dict_access: Dictionary = {}
var ShortInfos: Dictionary = {}
var customisable_dict: Dictionary = {}
var Infos_And_Paths: Dictionary = {}

var dragging: bool = false
var offset: Vector2 = Vector2.ZERO

var custom_canvas_dict = {}
var custom_local_group_dict = {}

var menu_options = ["Ajouter un élément", "Ajouter une catégorie", "Supprimer", "Fermer"]

signal add_new_canva_to_tree
signal apply_a_canva_to_planif(packed_scene, local_groups)

func _ready():
	info_bar.set_h_size_flags(Control.SIZE_EXPAND | Control.SIZE_FILL)
	#ExtendInfoBarButton.pressed.connect(func(): toggle_info_bar(info_bar))
	
	load_instance_data_resource()
	_create_personnal_notion_tree()
	
	infos = {
		PDA: "Progression Des Apprentissages", 
		PFEQ: "Programme de Formation de l'École Québécoise", 
		Matériel: "Matériel",
		Stratégies: "Stratégies"
		
	}
	dict_access = {
		"PDA": PDA, 
		"Programme de Formation de l'École Québécoise": PFEQ, 
		"Matériel": Matériel,
		"Stratégies": Stratégies
	}
	ShortInfos = {PDA: "Notions", PFEQ: "Compétences", Matériel: "Matériel", Stratégies: "Stratégies"}
	customisable_dict = {PDA: false, PFEQ: false, Matériel: true, Stratégies: false}
	
	for tree in get_tree().get_nodes_in_group("InfoTrees"):
		TreesPaths.append(tree.get_path())
	var info_count = 0
	for info in infos:
		Infos_And_Paths[info] = TreesPaths[info_count]
		info_count += 1
	for tree_separator in get_tree().get_nodes_in_group("TreeSeparator"):
		tree_separator.connect("gui_input", global_variables._on_separator_input.bind(tree_separator))
	
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 0.25  # Temps d'attente en secondes
	
	for data in Infos_And_Paths.keys():
		var tree = get_node(Infos_And_Paths[data])
		tree.columns = 1
		tree.set_column_titles_visible(true)
		tree.hide_root = false
		tree.select_mode = Tree.SELECT_ROW
		tree.allow_rmb_select = true
		#tree.item_selected.connect(func(): _on_item_selected(tree.get_selected()))
		tree.item_mouse_selected.connect(_on_mouse_item_selected.bind(tree))
		
		timer.timeout.connect(func(): _on_timeout(tree))
		_populate_tree(tree, data)
		_collapse_all_items(tree)
		_update_tree_size(tree)
		tree.item_collapsed.connect(_on_item_collapsed)
		tree.column_title_clicked.connect(func(column_index, tree_item): _collapsing_with_title(column_index, tree_item, tree))
		tree.connect("button_clicked", _on_new_element.bind(tree))
		tree.set_hide_root(true)
	
func _update_trees():
	_create_personnal_notion_tree()
	infos = {
		PDA: "Progression Des Apprentissages", 
		PFEQ: "Programme de Formation de l'École Québécoise", 
		Matériel: "Matériel",
		Stratégies: "Stratégies"
		
	}
	dict_access = {
		"PDA": PDA, 
		"Programme de Formation de l'École Québécoise": PFEQ, 
		"Matériel": Matériel,
		"Stratégies": Stratégies
	}
	ShortInfos = {PDA: "Notions", PFEQ: "Compétences", Matériel: "Matériel", Stratégies: "Stratégies"}
	customisable_dict = {PDA: false, PFEQ: false, Matériel: true, Stratégies: false}
	
	for data in Infos_And_Paths.keys():
		var tree = get_node(Infos_And_Paths[data])
		tree.clear()
		_populate_tree(tree, data)
		_collapse_all_items(tree)
		_update_tree_size(tree)

func _create_personnal_notion_tree():
	var corresponding_PDA = {}
	var corresponding_PFEQ = {}
	for group in global_variables.groups :
		var year_code = group.level + " " + group.year
		var subject_code = group.subject + " " + year_code
		corresponding_PDA[group.subject] = GouvDocumentation.domaine_apprentissage_dict[group.level][group.subject][group.year]
		
		corresponding_PFEQ["Domaine d'apprentissage"] = {group.subject : {}}
		var PFEQ_dict = GouvDocumentation.PFEQ_competences_dict[group.level][group.year]
		corresponding_PFEQ["Domaine d'apprentissage"][group.subject] = PFEQ_dict[group.subject]
		corresponding_PFEQ["Domaine généraux de formation"] = GouvDocumentation.PFEQ_domaine_generaux_formation
		corresponding_PFEQ["Compétences transversales"] = GouvDocumentation.PFEQ_competences_tranversales
	
	PDA = corresponding_PDA
	PFEQ = corresponding_PFEQ
		
func _on_search_bar_text_changed(new_text: String) -> void:
	var vbox = search_results_box
	for child in vbox.get_children() :
		child.queue_free()
		
	var empty_results = {}
	var path = []
	var search_results = _search_in_dict(new_text.to_lower(), total_dict_access, empty_results, path)
	if search_results.size() <= 15 :
		for result in search_results :
			#search_result_label.text += "- " + result 
			#search_result_label.text += "[font_size=8]" + search_results[result] + "[/font_size]" + "\n"
			var hbox = HBoxContainer.new()
			var button = Button.new()
			var to_cut = result.length() >= 45
			button.text = result.substr(0, 45)
			if to_cut :
				button.text += "..."
			button.tooltip_text = search_results[result]
			button.add_theme_font_size_override("font_size", 12)
			#button.gui_input.connect(func(event):handle_drag(event, button))
			button.connect("button_down", _on_search_result_pressed.bind(result))
			#var label = Label.new()
			#label.text = search_results[result]
			#label.add_theme_font_size_override("font_size", 8)
			hbox.add_child(button)
			#hbox.add_child(label)
			vbox.add_child(hbox)

func _search_in_dict(text, dict, results, current_path):
	for key in dict :
		current_path.append(key)
		
		if dict[key] is Dictionary :
			_search_in_dict(text, dict[key], results, current_path)
		
		elif dict[key] is Array :
			var final_list = dict[key]
			
			for element in final_list :
				var lower_element = element.to_lower()
				
				if lower_element.contains(text) :
					var complete_path = ""
					for path in current_path :
						complete_path += "/" + path
					results[element] = complete_path

		current_path.pop_back()
	
	return results
	
func _on_search_result_pressed(result_text):
	var text = result_text
	print("Élément sélectionné :", text)
	var mouse_position = get_local_mouse_position()
	var control_parent = Control.new()
	add_child(control_parent)
	# Créer un nouveau bouton
	var button = Button.new()
	control_parent.add_child(button)
	button.text = text
	#button.tooltip_text = "text"
	button.custom_minimum_size = Vector2(100, 30)
	button.position = mouse_position - button.custom_minimum_size / 2
		
	button.mouse_filter = Control.MOUSE_FILTER_STOP

	button.size_flags_horizontal = 0
	button.size_flags_vertical = 0
	dragging = true
	button.grab_click_focus()
	offset = button.position - get_global_mouse_position()
	button.gui_input.connect(func(event):handle_drag(event, button))

func toggle_info_bar(container):
	if container.get_h_size_flags() == 3:
		container.set_h_size_flags(Control.SIZE_SHRINK_END)
		#ExtendInfoBarButton.set_text("<<")
	else :
		container.set_h_size_flags(Control.SIZE_EXPAND | Control.SIZE_FILL)
		#ExtendInfoBarButton.set_text(">>")
		
var customisable = false
func _populate_tree(tree: Tree, data, parent: TreeItem = null):
	# Définir la racine si aucun parent n'est fourni
	if parent == null:
		var data_name = infos[data]
		customisable = customisable_dict[data]
		parent = tree.create_item()
		parent.set_text(0, data_name)
		tree.set_column_title(0, ShortInfos[data])

	if data is Dictionary:
	# Boucle sur les clés du dictionnaire
		if data :
			for key in data.keys():
				var item = tree.create_item(parent)
				item.set_text(0, key)
				# Vérifier si la valeur associée est un dictionnaire (sous-niveau)
				if data[key] is Dictionary or data[key] is Array:
					_populate_tree(tree, data[key], item)  # Récursion
				# Sinon, c'est une feuille (dernière profondeur)
				
				else:
					if data[key] != null :
						var leaf = tree.create_item(item)
						leaf.set_text(0, str(data[key]))  # Convertir la valeur en texte si besoin
		else :
			pass

	elif data is Array:
		if data == [] :
			var button_leaf = tree.create_item(parent)
			button_leaf.add_button(0, plus_icon, 1)
			button_leaf.set_text(0, "Ajouter un élément")
		
		for i in data.size():
			var element = data[i]
			if element is Dictionary :
				_populate_tree(tree, element, parent)
			else :
				var leaf = tree.create_item(parent)
				leaf.set_text(0, str(element))
			
			if i == data.size() - 1 and customisable:
				var button_leaf = tree.create_item(parent)
				button_leaf.add_button(0, plus_icon, 1)
				button_leaf.set_text(0, "Ajouter un élément")
				
func _on_new_element(item, column, _id, _mouse, tree, category = false):
	var rect = tree.get_item_area_rect(item, column)
	var line_edit = LineEdit.new()
	tree.add_child(line_edit)
	if rect.size.x > 0 and rect.size.y > 0: # Only position if item is visible
		line_edit.position = Vector2(0, rect.position.y)
		line_edit.size = rect.size
		line_edit.visible = true
		line_edit.max_length = 40
		line_edit.grab_focus()
		line_edit.connect("text_submitted", _on_text_submitted.bind(line_edit, item, tree, category))
		line_edit.connect("focus_exited", _on_focus_exited.bind(line_edit))
				
func _on_focus_exited(line_edit):
	line_edit.queue_free()
	
func _on_text_submitted(text, line_edit, item, tree, category):
	line_edit.queue_free()
	var parent = item.get_parent()
	var new_tree_item = tree.create_item(parent)
	new_tree_item.set_text(0, text)
	new_tree_item.move_before(item)
	_update_new_item(new_tree_item, new_tree_item, text, tree, false, category)
	#print(new_tree_item.get_parent().get_text(0))

var path_elements: Array[String] = []
func _update_new_item(item, first_item, text, tree, delete, category):
	var parent = item.get_parent()
	if parent == null:
		var root = path_elements[path_elements.size() - 1]
		var current = dict_access[root]
		#print(path_elements)
		for i in range(path_elements.size() - 2, -1, -1):
			
			if current is Array:
				var dup_current = current.duplicate()
				for j in range(dup_current.size()) :
					#print(dup_current[j])
					if dup_current[j] is Dictionary :
						#print(path_elements[i])
						var dup_dict = dup_current[j]
						if dup_dict.has(path_elements[i]) :
							#print("why?")
							current = dup_dict[path_elements[i]]
						
			else:
				current = current[path_elements[i]]
		if delete:
			#current.erase(text)
			var dup_current = current.duplicate()
			for j in range(dup_current.size()):
				if dup_current[j] is String :
					if dup_current[j] == text:
						current.erase(text)
				if dup_current[j] is Dictionary :
					if dup_current[j].has(text)  :
						current.erase(dup_current[j])
				if dup_current[j] is Array :
					if dup_current[j] == []:
						current.erase(dup_current[j])
						
			first_item.free()
		else :
			
			if current is Dictionary and category:
				current[text] = []
				var button_leaf = tree.create_item(first_item)
				button_leaf.add_button(0, plus_icon, 1)
				button_leaf.set_text(0, "Ajouter un élément")
			
			if current is Dictionary and not category:
				current[text] = null
				
			if current is Array and category :
				var new_dict = {}
				new_dict[text] = []
				var button_leaf = tree.create_item(first_item)
				button_leaf.add_button(0, plus_icon, 1)
				button_leaf.set_text(0, "Ajouter un élément")
				current.append(new_dict)
				
			elif current is Array and not category:
				current.append(text)
	
		save_instance_data_resource()
		path_elements = []
		#print(dict_access[root])
	else:
		#print(parent.get_text(0))
		path_elements.append(parent.get_text(0))
		_update_new_item(parent, first_item, text, tree, delete, category)
	
func _on_item_collapsed(item: TreeItem):
	var parent = item.get_tree()
	_update_tree_size(parent)

func _update_tree_size(tree: Tree):
	var total_items = _count_visible_items(tree)
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
		tree.set_hide_root(true)
	else:
		root.set_collapsed(true)
		tree.set_hide_root(true)

func _on_mouse_item_selected(_pos, id, tree: Tree):
	var item = tree.get_selected()
	var column = 0
	match id:
		MOUSE_BUTTON_LEFT:
			print("  Left mouse button clicked.")
			_on_item_selected(item)

		MOUSE_BUTTON_RIGHT:
			print("  Right mouse button clicked.")
			var popup_menu = PopupMenu.new()
			for i in range(menu_options.size()):
				popup_menu.add_item(menu_options[i], i) # The second argument is the ID
				
			$".".add_child(popup_menu)
			#popup_menu.popup_at_global_position(DisplayServer.mouse_get_position())
			popup_menu.position = get_global_mouse_position()
			popup_menu.id_pressed.connect(_on_menu_item_pressed.bind(item, tree, column))
			popup_menu.popup()

		MOUSE_BUTTON_MIDDLE:
			print("  Middle mouse button clicked.")

func _on_menu_item_pressed(id, item, tree, column):
	#["Ajouter un élément", "Ajouter une catégorie", "Supprimer", "Fermer"]
	var selected_option = menu_options[id]
	var _id = 0
	var _mouse = 0
	match selected_option:
		"Ajouter un élément":
			_on_new_element(item, column, _id, _mouse, tree)
		"Ajouter une catégorie":
			_on_new_element(item, column, _id, _mouse, tree, true)
		"Supprimer":
			var text = item.get_text(0)
			if item.get_first_child() != null :
				print("dict")
			_update_new_item(item, item, text, tree, true, false)
		"Fermer":
			pass

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
		button.tooltip_text = text
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
				var new_text = "\n- " + button.text
				if hovered_node.text == "" :
					new_text = "- " + button.text
				hovered_node.text += new_text
				hovered_node.emit_signal("text_changed")
			button.get_parent().queue_free()

	if event is InputEventMouseMotion and dragging :
		button.position = get_global_mouse_position() + offset

func get_intersection(text_edit: Node) -> bool:
	var rect_size = Vector2(2, 2)
	var mouse_rect = Rect2(get_global_mouse_position() - rect_size / 2, rect_size)
	var text_edit_rect = text_edit.get_global_rect()
	return mouse_rect.intersects(text_edit_rect)

func save_instance_data_resource():
	var save_resource = collect_save_data_into_resource()
	var filename = generate_date_coded_filename_resource()
	var file_path = "user://" + filename
	var error = ResourceSaver.save(save_resource, file_path, ResourceSaver.FLAG_COMPRESS) # Optionnel: ajouter FLAG_COMPRESS
	if error == OK:
		print("Planification save in : ", file_path)
	else:
		print("Error during the save of : ", file_path, " Erreur: ", error)
		
func collect_save_data_into_resource():
	var new_custom_canvas_dict = {}
	var new_custom_local_group_dict = {}
	var filename = "tree_data" + ".tres"
	var file_path = "user://" + filename
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		if loaded_resource is SaveTreeData:
			new_custom_canvas_dict = loaded_resource.custom_canvas_dict
			new_custom_local_group_dict = loaded_resource.custom_local_group_dict
	
	var save_resource = SaveTreeData.new()
	save_resource.material = Matériel
	save_resource.custom_canvas_dict = new_custom_canvas_dict
	save_resource.custom_local_group_dict = new_custom_local_group_dict
	
	return save_resource

func generate_date_coded_filename_resource():
	return "tree_data" + ".tres"

func load_instance_data_resource():
	var filename = "tree_data" + ".tres"
	var file_path = "user://" + filename
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		if loaded_resource is SaveTreeData:
			print("Resource loaded with success : ", file_path)
			apply_save_data_from_resource(loaded_resource)
			
			return true
		else:
			print("The resource is not valid : ", file_path)
			return false
	else:
		return false
		
func apply_save_data_from_resource(save_resource: SaveTreeData):
	Matériel = save_resource.material
	custom_canvas_dict = save_resource.custom_canvas_dict
	custom_local_group_dict = save_resource.custom_local_group_dict
	
	var canva_vbox_size = canva_vbox.get_children().size()
	var children = canva_vbox.get_children()
	if canva_vbox_size > 0 :
		for i in range(canva_vbox_size) :
			children[i].queue_free()
	
	for entry in custom_canvas_dict :
		var packed_scene = custom_canvas_dict[entry]
		var local_groups = custom_local_group_dict[entry]
		var new_button = Button.new()
		new_button.text = entry
		new_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		new_button.connect("gui_input", _manage_saved_canva_input.bind(packed_scene, local_groups, new_button))
				
		canva_vbox.add_child(new_button)
		canva_vbox.move_child(new_button, canva_vbox.get_child_count() - 2)

func _manage_saved_canva_input(event, packed_scene, local_groups, button):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				_apply_a_canva_to_planif(packed_scene, local_groups)
				
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				print("right")
				_handle_saved_canva_menu(packed_scene, local_groups, button)

func _handle_saved_canva_menu(packed_scene, local_groups, button):
	var popup_menu = PopupMenu.new()
	var options = ["Supprimer"]
	for i in range(options.size()):
		popup_menu.add_item(options[i], i) # The second argument is the ID
		
	$".".add_child(popup_menu)
	#popup_menu.popup_at_global_position(DisplayServer.mouse_get_position())
	popup_menu.position = get_global_mouse_position()
	popup_menu.id_pressed.connect(_suppress_saved_canva.bind(packed_scene, local_groups, button))
	popup_menu.popup()

func _suppress_saved_canva(_id, packed_scene, local_groups, button):
	var key = button.text
	var filename = "tree_data" + ".tres"
	var file_path = "user://" + filename
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		loaded_resource.custom_canvas_dict.erase(key)
		loaded_resource.custom_local_group_dict.erase(key)
		var error = ResourceSaver.save(loaded_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
		if error == OK:
			print("Planification save in : ", file_path)
		else:
			print("Error during the save of : ", file_path, " Erreur: ", error)
			
	button.queue_free()

func _apply_a_canva_to_planif(packed_scene, local_groups) -> void:
	apply_a_canva_to_planif.emit(packed_scene, local_groups)
	
func _on_add_canva_pressed() -> void:
	add_new_canva_to_tree.emit()
