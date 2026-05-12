extends Resource

class_name SaveOptionsData

#timetable and groups
@export var groups: Array = []
@export var groups_colors = {}
@export var timetable_cycle: int = 0
@export var number_of_period_AM: int = 0
@export var number_of_period_PM: int = 0
@export var school_year: String = ""
@export var group_schedules = [] #pas de distinction entre les groupes, toutes les périodes dans l'horaire
#group_schedules = [{"day","group","local","period"}]
@export var note_schedule_dict = [] # {schedule : {"noon": , "evening": }}
@export var period_duration = []

#sequences informations
@export var list_of_teacher_workday = []
@export var list_of_free_day = [] # [{"year":, "month":, "day":}]
@export var first_day = {}
@export var last_day = {}
#@export var groups_sequences = {} #dictionnaire key = groupe et data = dictionnaire de date spécifique au groupe
@export var filtered_dict_of_school_days = {} # {{day, month, year} : schedule}
@export var filtered_dict_of_school_days_group = {} #{{day, month, year, period} : group_code}
