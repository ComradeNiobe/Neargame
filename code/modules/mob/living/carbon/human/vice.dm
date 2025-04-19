/datum/vice
	var/name = "Vice"
	var/withdrawal_msg = "I need to sate my vice!"
	var/datum/happiness_event/withdraw_event
	var/no_ticker = FALSE

/datum/vice/proc/add_event(var/mob/living/carbon/human/target)
	if(!no_ticker)
		target.add_event("vice", withdraw_event)

/datum/vice/low_pain
	name = "Low Pain Tolerance"
	no_ticker = TRUE

/datum/vice/smoker
	name = "Smoker"
	withdrawal_msg = "I need a smoke."
	withdraw_event = /datum/happiness_event/vice/smoke

/datum/vice/weed
	name = "Pothead"
	withdrawal_msg = "I need a hit."
	withdraw_event = /datum/happiness_event/vice/weed

/datum/vice/pyromaniac
	name = "Pyromaniac"
	withdrawal_msg = "I need to see the world burn."
	withdraw_event = /datum/happiness_event/vice/pyromaniac

/datum/vice/klepto
	name = "Kleptomaniac"
	withdrawal_msg = "I need to steal from someone."
	withdraw_event = /datum/happiness_event/vice/klepto

/datum/vice/photo
	name = "Photographer"
	withdrawal_msg = "I need to take a picture of someone."
	withdraw_event = /datum/happiness_event/vice/photo

/datum/vice/kiss
	name = "Addict (Kisses)"
	withdrawal_msg = "I need a kiss."
	withdraw_event = /datum/happiness_event/vice/kiss

/datum/vice/necro
	name = "Necrophile"
	withdrawal_msg = "I need someone more rotten than me."
	withdraw_event = /datum/happiness_event/vice/necro

/datum/vice/sexo
	name = "Sexoholic"
	withdrawal_msg = "I need to sate my desires."
	withdraw_event = /datum/happiness_event/vice/sexo

/datum/vice/voyeur
	name = "Voyeur"
	withdrawal_msg = "I need to watch someone do it."
	withdraw_event = /datum/happiness_event/vice/voyeur

/datum/vice/maso
	name = "Masochist"
	withdrawal_msg = "I need to feel pain!"
	withdraw_event = /datum/happiness_event/vice/maso

/datum/vice/chem_addict
	name = ""//leave the name/withdrawal_msg empty and one will automatically be made.
	withdrawal_msg = ""
	var/chem_name = ""
	var/list/datum/reagent/vice_chems = list() //list of reagents that cure addiction.

/datum/vice/chem_addict/New()
	if(!name)
		name =  "Addict ([chem_name])"
	if(!withdrawal_msg)
		withdrawal_msg =  "I must take [lowertext(chem_name)]."
	var/list/total_chems = list()
	for(var/P in vice_chems)
		total_chems.Add(typesof(P))
	vice_chems = total_chems

/datum/vice/chem_addict/add_event(var/mob/living/carbon/human/target)
	if(withdraw_event)
		..()
		return
	if(!target.check_event("vice"))
		var/datum/happiness_event/vice/addict/H = new()
		H.description = SPAN_BADMOOD("• [withdrawal_msg]\n")
		target.add_precreated_event("vice", H)



/datum/vice/chem_addict/buffout
	chem_name = "Buffout"
	vice_chems  = list(/datum/reagent/buffout)

/datum/vice/chem_addict/mentats
	chem_name = "Mentats"
	vice_chems  = list(/datum/reagent/mentats)

/datum/vice/chem_addict/heroin
	chem_name = "Heroin"
	withdrawal_msg = "I need a hit."
	vice_chems  = list(/datum/reagent/heroin)
	withdraw_event = /datum/happiness_event/vice/heroin

/datum/vice/chem_addict/alcoholic
	name = "Alcoholic"
	withdrawal_msg = "I need a drink."
	vice_chems  = list(/datum/reagent/ethanol) //covers every drink
	withdraw_event = /datum/happiness_event/vice/alco

/datum/vice/chem_addict/stimulant
	chem_name = "Stimulants"
	withdrawal_msg = "I need to feel alive."
	vice_chems  = list(/datum/reagent/cocaine,/datum/reagent/mdma,/datum/reagent/changa)
	withdraw_event = /datum/happiness_event/vice/stimulants


/mob/living/carbon/human/proc/handle_vice()
	if(vice)
		if(viceneed < 1000)
			spawn(10)
				viceneed += rand(1,2)
				clear_event("vice")

	if(viceneed > 1000)
		viceneed = 1000

	if(viceneed >= 1000)
		if(src.vice)
			vice.add_event(src)
			if(sleeping) return

			if(prob(1))
				to_chat(src, "<br><span class='graytextbold'>⠀+ [vice.withdrawal_msg] +</span><br>")

/mob/living/carbon/human/proc/handle_reflect()
	if(can_reflect == FALSE)
		return
	if(reflectneed < 750)
		spawn(10)
			reflectneed += rand(1,2)
			clear_event("reflect")

	if(reflectneed > 750)
		reflectneed = 750

	if(reflectneed >= 750)
		add_event("reflect", /datum/happiness_event/reflect)
		src.add_verb(/mob/living/carbon/human/proc/reflectexperience)
		if(sleeping) return
		if(prob(1))
			to_chat(src, "<br><span class='graytextbold'>⠀+ I need to reflect my experience. +</span><br>")