class_name SequenceFunctions
extends RefCounted

static func _create_new_sequence(sequence_name, planif_resource):
	var sequence_dir_access = DirAccess.open("user://sequences/") 
	if sequence_dir_access:
		var sequence_name_with_tag = "sequence_" + sequence_name
		sequence_dir_access.make_dir_recursive(sequence_name_with_tag)
		
		_add_planif_to_sequence(sequence_name, planif_resource)

static func _add_planif_to_sequence(sequence_name, planif_resource):
	var sequence_name_with_tag = "sequence_" + sequence_name
	if planif_resource != null :
			print(planif_resource.title)

			var sequence_size = 0
			var dir = DirAccess.open("user://sequences/" + sequence_name_with_tag + "/")
			if dir :
				sequence_size = dir.get_files().size()

			var planif_name = str(sequence_size + 1) + "_" + planif_resource.title + ".tres"
			var file_path = "user://sequences/" + sequence_name_with_tag + "/" + planif_name
			var error = ResourceSaver.save(planif_resource, file_path, ResourceSaver.FLAG_COMPRESS) # Optionnel: ajouter FLAG_COMPRESS
			if error == OK:
				print("Planification save in : ", file_path)
			else:
				print("Error during the save of : ", file_path, " Erreur: ", error)

static func _get_sequence_dict():
	var sequences_dir_access = DirAccess.open("user://sequences/")
	var sequence_dict = {}
	
	if sequences_dir_access:
		# Start listing directory contents
		sequences_dir_access.list_dir_begin()
		var dir_name = sequences_dir_access.get_next()

		while dir_name != "":
			# Exclude "." and ".." entries
			if dir_name != "." and dir_name != "..":
				#sequence.append(dir_name)
				var sequence: PackedStringArray = []
				var sequence_dir_access = DirAccess.open("user://sequences/" + dir_name)
				if sequence_dir_access:
					# Start listing directory contents
					sequence_dir_access.list_dir_begin()
					var file_name = sequence_dir_access.get_next()

					while file_name != "":
						# Exclude "." and ".." entries
						if file_name != "." and file_name != "..":
							sequence.append(file_name)
						file_name = sequence_dir_access.get_next()

					sequence_dir_access.list_dir_end()

				sequence_dict[dir_name] = sequence
					
			dir_name = sequences_dir_access.get_next()

		sequences_dir_access.list_dir_end()

	return sequence_dict
