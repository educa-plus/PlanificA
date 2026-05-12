extends Control

@onready var chart: Chart = $VBoxContainer/Chart

var list_of_retroaction_value_by_month = []

func _ready():
	pass

func _update_chart(x_axis, y_axis):
	# X values will be the hours of the day, starting with 0 ending on 23.
	#var x: Array = range(0, 24).map(func(i) -> String: return "%d - %d h" % [i, i+1])
	var x = x_axis
	# Arrays contain how many animals have been seen in each hour.
	#var retroactions_values: Array =   [0, 0, 0, 0, 0, 0, 0, 4, 5, 3, 6, 0, 0, 0, 2, 0, 0, 4, 5, 0, 0, 0, 0, 0]
	var retroactions_values = y_axis
	#var nightingale_spots: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 2, 1, 0, 4, 4, 0, 3, 0, 0]

	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#ffffff")
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color("#333333")
	cp.draw_bounding_box = false
	cp.title = "Progression des rétroactions annuelle"
	cp.x_label = "Mois"
	cp.y_label = "%"
	cp.interactive = true
	cp.show_legend = false
 
	# Let's add values to our functions
	var blackbird_function = Function.new(
		x,
		retroactions_values,
		"Valeur moyenne",
		{ color = Color.NAVY_BLUE, marker = Function.Marker.CIRCLE, type = Function.Type.LINE }
	)

	# Configure the y axis. We set the scale and domain in such
	# that we get ticks only on integers, not on floats. 
	# We also configure the label function to not print decimal places.
	var y_max_value := 0
	for i in range(0, x.size()):
		if retroactions_values[i] > y_max_value:
			y_max_value = retroactions_values[i]
	#	if nightingale_spots[i] > y_max_value:
	#		y_max_value = nightingale_spots[i]
	# Add one or two on top so that we have some nice spacing
	#y_max_value += 2 if (y_max_value % 2) == 0 else 1
	y_max_value = 110
	#cp.y_scale = y_max_value / 2
	cp.y_scale = 11
	chart.set_y_domain(0, y_max_value)
	chart.y_labels_function = func(value: float): return str(int(value))

	# Now let's plot our data
	#chart.plot([blackbird_function, nightingale_function], cp)
	chart.plot([blackbird_function], cp)
