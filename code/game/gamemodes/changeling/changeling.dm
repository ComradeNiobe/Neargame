/datum/game_mode
	var/list/datum/mind/changelings = list()
	var/absorbedcount = 0
	var/hunter = ""
	var/changeling_chem = "heroin"

/datum/game_mode/changeling
	name = "THEY"
	config_tag = "changeling"
	restricted_jobs = list("Praetor")
	protected_jobs = list()
	required_players = 2
	required_players_secret = 4
	required_enemies = 1
	recommended_enemies = 4

	var/changeling_amount = 4

/datum/game_mode/changeling/announce()
	world << "<B>Our quiet night is interrupted by aliens.</B>"

/datum/game_mode/changeling/can_start()
	. = ..()
	for(var/mob/new_player/player in player_list)
		if(player.ready && player.client.work_chosen == "Baron")
			return TRUE
	return FALSE

/datum/game_mode/changeling/pre_setup()

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	var/list/datum/mind/possible_changelings = get_players_for_antag()

	for(var/datum/mind/player in possible_changelings)
		for(var/job in restricted_jobs)//Removing robots from the list
			if(player.assigned_role == job)
				possible_changelings -= player

	changeling_amount = 1 + round(num_players() / 10)

	unmask_drug()

	if(length(possible_changelings) > 0)
		for(var/i = 0, i < changeling_amount, i++)
			if(!length(possible_changelings)) break
			var/datum/mind/changeling = pick(possible_changelings)
			possible_changelings -= changeling
			changelings += changeling
			modePlayer += changelings
		return TRUE
	else
		return FALSE

/datum/game_mode/changeling/post_setup()
	for(var/datum/mind/changeling in changelings)
		grant_changeling_powers(changeling.current)
		changeling.special_role = "Changeling"
		forge_changeling_objectives(changeling)
		log_game("[changeling]([changeling?.key]) is now a THEY.")
		greet_changeling(changeling)

	..()
	return

/mob/living/carbon/human/proc/update_all_society_icons()
	if(src?.mind?.changeling)
		for(var/mob/living/carbon/human/HH in player_list)
			if(HH?.mind?.changeling)
				var/I = image('icons/mob/mob.dmi', loc = HH, icon_state = "changeling")
				if(src.client)
					src.client.images += I

/datum/game_mode/proc/unmask_drug()
	changeling_chem = pick("heroin", "whiskey", "mdma", "dob", "wine")
	return

/datum/game_mode/proc/forge_changeling_objectives(datum/mind/changeling)
	var/datum/objective/society/escape_objective = new
	escape_objective.owner = changeling
	changeling.objectives += escape_objective

	var/datum/objective/societyAssimilate/assimilate_objective = new
	assimilate_objective.owner = changeling
	changeling.objectives += assimilate_objective

	return

/datum/game_mode/proc/greet_changeling(datum/mind/changeling, you_are=1)
	if(you_are)
		to_chat(changeling.current, SPAN_LEGEND("I am spreading across the planet in many bodies. I am ancient. Death and fear are unknown to me. I think with the meat of this creature, and it grants me a mind. The mind will help me spread."))
		sound_to(changeling.current, sound('sound/music/changeling_intro.ogg', repeat = 0, wait = 0, volume = 100, channel = 10))
		sound_to(changeling.current, sound('sound/music/the_collective.ogg', repeat = 0, wait = 0, volume = 80, channel = 3))

	to_chat(changeling.current, SPAN_ITALIC("I will use WHISPER (+) to talk to the other parts of myself."))
	to_chat(changeling.current, SPAN_NOTICE("We must be wary, as we know [changeling_chem] will cause us to reveal ourselves!"))
	to_chat(changeling.current, "Our dreams:")
	var/mob/living/carbon/human/H = changeling.current
	H.update_all_society_icons()

	var/obj_count = 1
	for(var/datum/objective/objective in changeling.objectives)
		to_chat(changeling.current, "<B>Desire #[obj_count]</B>: [objective.explanation_text]")
		obj_count++
	return

/datum/game_mode/proc/grant_changeling_powers(mob/living/carbon/changeling_mob)
	if(!istype(changeling_mob))	return
	changeling_mob.make_changeling()

/datum/game_mode/changeling/declare_completion(datum/mind/changeling)
	. = ..()
	if(length(changelings))
		var/text = "<FONT size = 2><B>THEY</B></FONT>"
		var/society_win = TRUE

		text += "<br>Forms of the one: [changelings]"
		text += "<br>The hunter was: [hunter]"
		text += "<br><b>Tonight's events resulted in transforming [absorbedcount] of the local human herd into something better.</b>"

		if(length(changeling.objectives))
			var/count = 1
			for(var/datum/objective/objective in changeling.objectives)
				if(objective.check_completion())
					text += "<br><B>Desire #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
				else
					text += "<br><B>Desire #[count]</B>: [objective.explanation_text] <font color='red'>Failure.</font>"
					society_win = FALSE
				count++

		if(society_win)
			text += "<br><font color='green'><B>The Society was successful!</B></font>"
		else
			text += "<br><font color='red'><B>The Society has failed!</B></font>"

		to_world(text)
	return

/datum/changeling //stores changeling powers, changeling recharge thingie, changeling absorbed DNA and changeling ID (for changeling hivemind)
	var/list/absorbed_dna = list()
	var/list/purchasedpowers = list()
	var/chem_charges = 20
	var/chem_recharge_rate = 0.5
	var/chem_storage = 50
	var/geneticdamage = 0
	var/isabsorbing = 0
	var/last_lump = 0
	var/lump_delay = 60 SECONDS

/datum/changeling/proc/regenerate()
	chem_charges = min(max(0, chem_charges+chem_recharge_rate), chem_storage)
	geneticdamage = max(0, geneticdamage-1)

/datum/changeling/proc/GetDNA(var/dna_owner)
	var/datum/dna/chosen_dna
	for(var/datum/dna/DNA in absorbed_dna)
		if(dna_owner == DNA.real_name)
			chosen_dna = DNA
			break
	return chosen_dna