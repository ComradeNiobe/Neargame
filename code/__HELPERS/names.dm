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
	var/name = "Nearweb†: "
	name += pick("Murder", "Love", "Kill the", "Love the","Kidnap the","Castrate the","Save","Deadly", "Paranoid", "Unidentified",
	"Skeleton", "Communist", "Dead","Sleeping","Thirsty","Hungry",
	"Dangerous","Overdosed","Depressed","Butchered","Foolish","False","Ominous",
	"Dying","Fear the","Long for the","Hidden","Lusting","Powerful","Hungering",
	"Faithless","Decayed","Rotten","Deformed","Bloody","False","Everlasting",
	"Run from the", "Sins of the","Comatic","Embrace the","Suffering","Fake","Lifeless",
	"Brooding","Tainted","Shattered","Whispers of the","Desecrated","Fuck the","Tales of the", "Attack Of The 50 Foot")
	name += " "
	name += pick("Baron","Dreamer","Child","Bum","Amuser","Randy","Terrorist","Enoch","Consyte","Mortician","Whore",
	"Witch","Lodge","Graga","Rat","Beast","Demon","Chimera","God","Inquisitor","Soup","Bees","Consyte","Bishop","Sheriff",
	"Lovers","Night","Grue","Darkness","Fortress","Corpse","Torch","Underground","Ambush","Invader","Vampire","Night","Heretic",
	"Church","Icon","Dream","Flesh","Weakness","Revelation","Order","Saint","Web","Past","Present","Future","Victim","Liar","Plotters","Nightmare",	"Cold","Caves","Ghost")

	world.name = name

	vessel_name = name


	return name