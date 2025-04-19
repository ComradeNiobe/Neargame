var/datum/padla/Padla = null
var/global/knifeprayer = FALSE

/datum/controller/process/padla/setup()
	name = "padla"
	schedule_interval = 10 // every 1 second
	start_delay = 18

/datum/controller/process/padla/started()
	..()
	if(!Padla)
		var/datum/padla/E = new
		Padla = E

/datum/controller/process/padla/doWork()
	var/datum/padla/PadlaVar = Padla
	PadlaVar.process()

/datum/padla
	var/name = "PadlaDatum"
	var/timeForNextPadla = 50 MINUTES
	var/amountsPrayed = 0
	var/amountHeretics = 0

/datum/padla/New()
	..()
	timeForNextPadla = rand(20 MINUTES, 35 MINUTES)

/datum/padla/proc/process()
	timeForNextPadla = max(0, timeForNextPadla-1 SECONDS)
	if(timeForNextPadla == 0 && knifeprayer == FALSE)
		if(!knifeprayer)
			doPadla()
			to_chat(world, "<br>")
			to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
			to_chat(world, "<span class='excomm'>The warlock has made another padla!</span>")
			world << sound(pick('sound/effects/padla.ogg','sound/effects/padla2.ogg','sound/effects/padla3.ogg','sound/effects/padla4.ogg'))
			to_chat(world, "<br>")

/datum/padla/proc/doPadla()
	var/padlas = pick(subtypesof(/datum/curses/padla))
	if (padlas)
		var/datum/curses/padla/chosenPadla = new padlas
		chosenPadla.Curse()
		timeForNextPadla = rand(20 MINUTES, 35 MINUTES)

// PADLAS TYPE

/datum/curses/padla
	var/name = "Kk eae men"

/datum/curses/padla/proc/Curse()
	return

// PADLAS TYPE START

/datum/curses/padla/lust
	name = "lust padla"

/datum/curses/padla/lust/Curse()
	for(var/mob/living/carbon/human/H in player_list)
		if(!H.check_perk(/datum/perk/ref/warlock) && H.age > 17 && !H.stat && !H.sleeping)
			H.add_event("lustpadla", /datum/happiness_event/misc/needsex)
			spawn(5 SECONDS)
				to_chat(H, "<span class='horriblestate' style='font-size: 150%;'><b><i>Your Lust Intensifies!</i></b></span>")


/datum/curses/padla/teeth
	name = "teeth padla"

/datum/curses/padla/teeth/Curse()
	for(var/mob/living/carbon/human/H in player_list)
		if(!H.check_perk(/datum/perk/ref/warlock) && !H.stat && !H.sleeping) //Sleeping makes you immune to the warlock's padlas.
			spawn(5 SECONDS)
				if(prob(35))
					var/datum/organ/external/mouth/MH = H.get_organ("mouth")
					MH.knock_out_teeth(get_dir(pick(cardinal), src), round(rand(28, 38) * ((rand(0, 9)*2)/100)))
					to_chat(H, "<span class='horriblestate' style='font-size: 150%;'><b><i>MY TEETH FALL OUT!</i></b></span>")

/datum/curses/padla/poo
	name = "poo padla"

/datum/curses/padla/poo/Curse()
	for(var/mob/living/carbon/human/H in player_list)
		if(!H.check_perk(/datum/perk/ref/warlock)&& !H.stat && !H.sleeping)
			H.bowels = rand(450, 500)

/datum/curses/padla/piss
	name = "piss padla"

/datum/curses/padla/piss/Curse()
	for(var/mob/living/carbon/human/H in player_list)
		if(!H.check_perk(/datum/perk/ref/warlock) && !H.stat && !H.sleeping)
			H.bladder = rand(450, 500)

/datum/curses/padla/famine
	name = "famine padla"

/datum/curses/padla/famine/Curse()
	for(var/mob/living/carbon/human/H in player_list)
		if(!H.check_perk(/datum/perk/ref/warlock) && !H.stat && !H.sleeping)
			H.nutrition = rand(50, 100)

/datum/curses/padla/regurgitator
	name = "regurgitator padla"

/datum/curses/padla/regurgitator/Curse()
	for(var/i = 0; i <= 4; i++)
		var/turf/T = pick(regurgilist)
		new/obj/effect/regurgitator(T)
		regurgilist -= T

/datum/curses/padla/horde
	name = "horde padla"

/datum/curses/padla/horde/Curse()
	for(var/i = 0; i <= 4; i++)
		var/turf/T = pick(regurgilist)
		new/obj/effect/horde(T)
		regurgilist -= T
