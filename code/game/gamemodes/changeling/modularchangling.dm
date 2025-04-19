// READ: Don't use the apostrophe in name or desc. Causes script errors.

var/list/powers = typesof(/datum/power/changeling) - /datum/power/changeling	//needed for the badmin verb for now
var/list/datum/power/changeling/powerinstances = list()

/datum/power			//Could be used by other antags too
	var/name = "Power"
	var/desc = "Placeholder"
	var/helptext = ""
	var/isVerb = 1 	// Is it an active power, or passive?
	var/verbpath // Path to a verb that contains the effects.

/datum/power/changeling/absorb_dna
	name = "Absorb DNA"
	desc = "Permits us to syphon the DNA from a human. They become one with us, and we become stronger."
	verbpath = /mob/proc/changeling_absorb_dna

/datum/power/changeling/exposetentacles
	name = "Expose Tentacles"
	desc = "Makes you stronger and more resistant to damage."
	verbpath = /mob/proc/extend_tentacles

/datum/power/changeling/changhunt
	name = "Hunt"
	desc = "Hunt them."
	verbpath = /mob/proc/changhunt

/datum/power/changeling/infestweb
	name = "Infested the Web"
	desc = "Infest the Lifeweb."
	verbpath = /mob/proc/infestweb

/datum/power/changeling/lump
	name = "Lump"
	desc = "Shit a lump."
	verbpath = /mob/proc/lump

/datum/power/changeling/learn
	name = "Learn"
	desc = "Learn from the Associates."
	verbpath = /mob/proc/learn

/datum/power/changeling/fakedeath
	name = "Regenerative Stasis"
	desc = "We become weakened to a death-like state, where we will rise again from death."
	helptext = "Can be used before or after death. Duration varies greatly."
	verbpath = /mob/proc/changeling_fakedeath

/datum/changeling/proc/purchasePower(datum/mind/M, Pname, remake_verbs = 1)
	if(!M || !M.changeling)
		return

	var/datum/power/changeling/Thepower = Pname

	for (var/datum/power/changeling/P in powerinstances)
		//world << "[P] - [Pname] = [P.name == Pname ? "True" : "False"]"
		if(P.name == Pname)
			Thepower = P
			break

	if(Thepower == null)
		M.current << "This is awkward.  Changeling power purchase failed, please report this bug to a coder!"
		return

	if(Thepower in purchasedpowers)
		M.current << "We have already evolved this ability!"
		return

	purchasedpowers += Thepower

	if(!Thepower.isVerb && Thepower.verbpath)
		call(M.current, Thepower.verbpath)()
	else if(remake_verbs)
		M.current.make_changeling()