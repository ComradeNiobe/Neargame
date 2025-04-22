var/church_name = null
/proc/church_name()
	if (church_name)
		return church_name

	var/name = ""

	name += pick("Holy", "United", "First", "Second", "Last")

	if (prob(20))
		name += " Space"

	name += " " + pick("Church", "Cathedral", "Body", "Worshippers", "Movement", "Witnesses")
	name += " of [religion_name()]"

	return name

var/command_name = null
/proc/command_name()
	if (command_name)
		return command_name

	var/name = "Central Command"

	command_name = name
	return name

/proc/change_command_name(var/name)

	command_name = name

	return name

var/religion_name = null
/proc/religion_name()
	if (religion_name)
		return religion_name

	var/name = ""

	name += pick("bee", "science", "edu", "captain", "assistant", "monkey", "alien", "space", "unit", "sprocket", "gadget", "bomb", "revolution", "beyond", "station", "goon", "robot", "ivor", "hobnob")
	name += pick("ism", "ia", "ology", "istism", "ites", "ick", "ian", "ity")

	return capitalize(name)

/proc/vessel_name()
	return vessel_name

/proc/world_name()
	var/name = "Neargame†: A Machine For Pigs"

	world.name = name
	vessel_name = name

	return name