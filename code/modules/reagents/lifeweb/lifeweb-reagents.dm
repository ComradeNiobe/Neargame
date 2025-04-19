
/datum/reagent/dylovene
	name = "Dylovene"
	id = "dylovene"
	description = "Cures toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC"

/datum/reagent/dylovene/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustToxLoss(-3 * REAGENTS_EFFECT_MULTIPLIER)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.id,1)
	..()
	return

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Stabilizes patient."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.2

/datum/reagent/inaprovaline/on_mob_life(var/mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(M.health < -10 && M.health > -65)
		M.adjustToxLoss(-1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustBruteLoss(-1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-1  * REAGENTS_EFFECT_MULTIPLIER)
	if(M.oxyloss > 35)
		M.setOxyLoss(35)
	if(M.losebreath > 3)
		M.losebreath = 3
	M.adjustHalLoss(-1  * REAGENTS_EFFECT_MULTIPLIER)
	if(prob(30))
		M.AdjustParalysis(-1)
		M.AdjustStunned(-1)
		M.AdjustWeakened(-1)
	..()
	return

/datum/reagent/raque
	name = "RAQUE"
	id = "raque"
	description = "Heals internal organs."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.2

/datum/reagent/raque/on_mob_life(var/mob/living/carbon/human/M as mob)
	if(!M) M = holder.my_atom
	M.setBrainLoss(0)
	for(var/datum/organ/internal/org in M.internal_organs)
		org.damage = max(0, org.damage-2)
	if(prob(55))
		M.adjustBruteLoss(-1 * REAGENTS_EFFECT_MULTIPLIER)
	..()
	return

/datum/reagent/raque/on_mob_life(var/mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(M.health < -10 && M.health > -65)
		M.adjustToxLoss(-1 * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustBruteLoss(-1 * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-1 * REAGENTS_EFFECT_MULTIPLIER)
	if(M.oxyloss > 35)
		M.setOxyLoss(35)
	if(M.losebreath > 3)
		M.losebreath = 3
	M.adjustHalLoss(-1 * REAGENTS_EFFECT_MULTIPLIER)
	if(prob(30))
		M.AdjustParalysis(-1)
		M.AdjustStunned(-1)
		M.AdjustWeakened(-1)
	..()
	return

/datum/reagent/dentrine
	name = "Dentrine"
	id = "dentrine"
	description = "Temporarily stops pain, Decrease DX"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30
	reaction_mob(var/mob/living/carbon/human/M as mob)
		if(!M.reagents.has_reagent("gelabine"))
			..()
		M.my_stats.add_mod("dentrine", stat_list(DX = -3), time = 10 MINUTES)
		M.so_high()
	on_mob_life(var/mob/living/carbon/human/M as mob)
		M.reagents.add_reagent("tramadol", 1)
		if(prob(55))
			M.adjustBruteLoss(-1 * REAGENTS_EFFECT_MULTIPLIER)
		if(prob(40))
			M.setHalLoss(0)
		..()
		return

/datum/reagent/heroin
	name = "Heroin"
	id = "heroin"
	description = "Strong opioid."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 11
	reaction_mob(var/mob/living/carbon/human/M as mob)
		if(!M.reagents.has_reagent("gelabine"))
			..()
		M.my_stats.add_mod("heroin", stat_list(DX = -4), time = 900)
		M.so_high()
		M << 'sound/webbers/hhh.ogg'
		M.add_event("heroin", /datum/happiness_event/misc/argh)
		if(prob(5))
			var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
			H.heart_attack()
	overdose_process(var/mob/living/carbon/human/M as mob)
		var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
		H.heart_attack()
	on_mob_life(var/mob/living/carbon/human/M as mob)
		M.reagents.add_reagent("dentrine", 2)
		if(prob(40))
			M.setHalLoss(0)
		..()
		if(M.vice == "Addict (Heroin)")
			M.viceneed = 0
		return

/datum/reagent/cocaine
	name = "Cocaine"
	id = "cocaine"
	description = "Кокаинум!"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30
	reaction_mob(var/mob/living/carbon/human/M as mob)
		M.COCAINA()
		M.add_event("cocaine", /datum/happiness_event/misc/woo)
	overdose_process(var/mob/living/carbon/human/M as mob)
		var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
		H.heart_attack()
	on_mob_life(var/mob/living/carbon/human/M as mob)
		M.stamina_loss = max(0, M.stamina_loss-2)
		..()
		if(M.vice == "Addict (Cocaine)")
			M.viceneed = 0
		return

/datum/reagent/heroin/on_remove(data)
	..()
	var/mob/living/carbon/human/M = holder?.my_atom
	if(!istype(M))
		return
	for(var/obj/screen_controller/S in M?.client?.screen)
		S.remove_filter("cor")
		S.transform = null

/datum/reagent/dentrine/on_remove(data)
	..()
	var/mob/living/carbon/human/M = holder?.my_atom
	if(!istype(M))
		return
	for(var/obj/screen_controller/S in M?.client?.screen)
		S.remove_filter("cor")
		S.transform = null

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "Temporarily stops pain, Decrease HT"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30

/datum/reagent/oxycodone/on_mob_life(var/mob/living/carbon/human/M as mob)
	if(!M) M = holder.my_atom
	M.setHalLoss(0)
	for(var/datum/organ/external/org in M.organs)
		org.painLW = 0
	if(prob(55))
		M.adjustBruteLoss(-1 * REAGENTS_EFFECT_MULTIPLIER)
	if(!M.reagents.has_reagent("gelabine"))
		M.my_stats.add_mod("oxycodone", stat_list(HT = -8), time = 5 MINUTES)
	..()
	return

/datum/reagent/gelabine
	name = "Gelabine"
	id = "gelabine"
	description = "Fixes negative effects of drugs"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Heals burn damage."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	metabolization_rate = 2

/datum/reagent/kelotane/reaction_mob(var/mob/living/M as mob, var/method=TOUCH, var/volume)
	M.adjustFireLoss((volume-(volume*2)) * REAGENTS_EFFECT_MULTIPLIER)
	..()
	return

/datum/reagent/kelotane/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(prob(55))
		M.adjustFireLoss(-2 * REAGENTS_EFFECT_MULTIPLIER)
	..()
	return

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Heals blunt damage."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	metabolization_rate = 2

/datum/reagent/bicaridine/reaction_mob(var/mob/living/M as mob, var/volume)
	if(!istype(M))
		..()
		return
	M.heal_organ_damage(volume * REAGENTS_EFFECT_MULTIPLIER,0)
	M.emote("scream")
	return

/datum/reagent/bicaridine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(prob(55))
		M.adjustBruteLoss(-2 * REAGENTS_EFFECT_MULTIPLIER)
	..()
	return

/datum/reagent/tricordazine
	name = "Tricordazine"
	id = "tricordazine"
	description = "Heals blunt and burn damage."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/tricordazine/reaction_mob(var/mob/living/M, var/volume)
	if(!M) M = holder.my_atom
	M.adjustBruteLoss(-(2*volume) * REAGENTS_EFFECT_MULTIPLIER)
	M.adjustFireLoss(-(2*volume) * REAGENTS_EFFECT_MULTIPLIER)
	..()
	return

/datum/reagent/tricordazine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(prob(55))
		M.adjustBruteLoss(-2 * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-2 * REAGENTS_EFFECT_MULTIPLIER)
	..()
	return

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Heals brain damage."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/alkysine/on_mob_life(mob/living/M as mob)
	M.adjustBrainLoss(-3)
	..()
	return

/datum/reagent/alkysine/on_mob_life(mob/living/M as mob)
	M.adjustBrainLoss(-3)
	..()
	return

/datum/reagent/widowtear
	name = "Widow's Tear"
	id = "widowtear"
	description = "Silent and slow poison."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	metabolization_rate = 2

/datum/reagent/widowtear/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustToxLoss((0.1*volume) * REAGENTS_EFFECT_MULTIPLIER)
	M.adjustBruteLoss((0.1*volume) * REAGENTS_EFFECT_MULTIPLIER)
	if(prob(25))
		M.adjustOxyLoss(pick(1,3) * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustToxLoss(pick(2,4) * REAGENTS_EFFECT_MULTIPLIER)
	..()
	return

/datum/reagent/buffout
	name = "Buffout"
	id = "buffout"
	description = "Gains ST and lose IN."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose_threshold = 100
	overdose_process(var/mob/living/carbon/human/M as mob)
		//sei la nao lembro o que buffout faz quando exagera acho que da ataque cardiaco masn ao tenho certeza
		var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
		H.heart_attack()
		return
	reaction_mob(var/mob/living/carbon/human/M, var/method=INGEST, var/volume, var/target_zone)
		M.my_stats.add_mod("buffout", stat_list(ST = 4), time = 10 MINUTES)
		if(!M.reagents.has_reagent("gelabine"))
			M.my_stats.add_mod("buffout_IN", stat_list(IN = -4), time = 10 MINUTES)
		..()

/datum/reagent/buffout/on_remove(data)
	..()
	var/mob/living/carbon/human/M = holder?.my_atom
	if(!istype(M))
		return

/datum/reagent/mice
	name = "Mice"
	id = "mice"
	description = "Releases dopamine on bloodstream."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose_threshold = 100
	reaction_mob(var/mob/living/carbon/human/M as mob)
		M.add_event("mice", /datum/happiness_event/misc/better)

/datum/reagent/vinici_us
	name = "Vinici-us"
	id = "vinici-us"
	description = "Halucinogen."
	reagent_state = LIQUID
	color = "#558833" // rgb: 96, 165, 132
	reaction_mob(var/mob/living/carbon/human/M as mob)
		M.AcidTrip()
		M.add_event("mice", /datum/happiness_event/misc/better)
		spawn(3 MINUTES)
			M.removeAcid()
			spawn(30 SECONDS)
				M.removeAcid()
				spawn(30 SECONDS)
					M.removeAcid()
					spawn(30 SECONDS)
						M.removeAcid()

/datum/reagent/vinici_us/on_remove(data)
	..()
	var/mob/living/carbon/human/M = holder?.my_atom
	if(!istype(M))
		return
	M.removeAcid()
	spawn(10)
		M.removeAcid()

/datum/reagent/mentats
	name = "Mentats"
	id = "mentats"
	description = "Gains IN and lose DX."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose_threshold = 100

/datum/reagent/mentats/reaction_mob(var/mob/living/carbon/human/M as mob, var/method=TOUCH, var/volume, var/target_zone)
	if(M.mind)
		M.mind.learning_modif += 5
		M.mind.teaching_modif += 5
	M.my_stats.add_mod("mentats", stat_list(IN = 10), time = 10 MINUTES)
	if(!M.reagents.has_reagent("gelabine"))
		M.my_stats.add_mod("mentats_DX", stat_list(DX = -5), time = 10 MINUTES)
	..()

/datum/reagent/mentats/overdose_process(var/mob/living/carbon/human/M as mob)
	var/datum/organ/internal/brain/H = M.internal_organs_by_name["heart"]
	H.take_damage(5)
	return

/datum/reagent/mentats/on_mob_life(var/mob/living/carbon/human/M as mob)
	if(!M) M = holder.my_atom
	M.setBrainLoss(0)
	for(var/datum/organ/internal/org in M.internal_organs)
		if(org.name == "brain")
			org.damage = max(0, org.damage-5)
	..()
	return

/datum/reagent/mentats/on_remove(data)
	..()
	var/mob/living/carbon/human/M = holder?.my_atom
	if(!istype(M))
		return
	if(M.mind)
		M.mind.learning_modif -= 5
		M.mind.teaching_modif -= 5

/datum/reagent/dob
	name = "DOB"
	id = "dob"
	description = "Causes hallucinations Causes speech impediment Causes random verb usage Causes hearing impediment Replaces the brain with strange organ if injected in head, kill man and butcher head Also works on corpses."
	reagent_state = LIQUID
	color = "#60bf63" // rgb: 200, 165, 220
	on_mob_life(var/mob/living/carbon/human/M as mob)
		if(M.vice == "Addict (Halucinogens)")
			M.viceneed = 0
		M << sound('sound/music/gabbro.ogg', repeat = 1, wait = 1, volume = 80, channel = 30)
		M.overlay_fullscreen("dob", /obj/screen/fullscreen/DOB, 1)
		M.canmove = FALSE
		M.resting = TRUE
		M.lying = TRUE

		..()
		return

/datum/reagent/dob/on_remove(data)
	..()
	var/mob/living/carbon/human/M = holder?.my_atom
	if(!istype(M))
		return
	M.clear_fullscreen("dob")
	M << sound(null, repeat = 0, wait = 0, volume = 0, channel = 30)
	M.canmove = TRUE

/datum/reagent/ethlod
	name = "ETH-LOD"
	id = "ethlod"
	description = "Causes hallucinations."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	on_mob_life(var/mob/living/carbon/human/M as mob)
		M << sound('sound/music/white_waking_1.ogg', repeat = 1, wait = 1, volume = 75, channel = 30)
		M.water(3,1,300,1)
		..()
		return

/datum/reagent/antibiotic
	name = "Antibiotic"
	id = "antibiotic"
	description = "Cure infections."
	reagent_state = LIQUID
	color = "#E5860A"

/datum/reagent/antibiotic/reaction_mob(var/mob/M, var/method=TOUCH, var/volume, var/target_zone)
	..()
	if(method == INJECT && ishuman(M) && target_zone)
		var/mob/living/carbon/human/H = M
		if (!hasorgans(H))
			return FALSE
		var/datum/organ/external/affected = H.get_organ(target_zone)
		if(!affected || affected.status & ORGAN_DESTROYED || affected.status & ORGAN_DEAD)
			return
		if(volume < 5)
			return FALSE

		affected.germ_level = 0
		affected.disinfect()

	return TRUE

//mensagem para comicao:
//PELO AMOR DE DEUS CRIE DEFINES PARA OS PLANES USADOS PELO FARWEBBFDMBMDFBSRGKVSDEKF
/datum/reagent/mdma
	name = "MDMA"
	id = "mdma"
	description = "A synthetic drug that improves the user's strength and endurance, but causes great reduction in intellect and visual distortions."
	reagent_state = LIQUID
	color = "#ff00ff" // rgb: 255, 0, 255
	overdose_threshold = 30
	var/obj/hud_plane_master
	var/list/obj/wave_plane_masters
	var/list/wave_filters
	var/list/saturation_filters
	var/sound/music

/datum/reagent/mdma/proc/wave_filter()
	wave_filters = list()
	for(var/obj/our_plane_master in wave_plane_masters)
		our_plane_master.filters += filter(type = "wave", size = 1, x = 32, y = 32, offset = 0)
		var/wave_filter = our_plane_master.filters[length(our_plane_master.filters)]
		wave_filters[our_plane_master] = wave_filter
		animate(wave_filter, offset = 32, size = 2, time = 64 SECONDS, loop = -1, easing = LINEAR_EASING, flags = ANIMATION_PARALLEL)

/datum/reagent/mdma/proc/saturation_filter()
	//this is HSL, *not* RGB
	var/static/list/col_filter_identity = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	var/static/list/col_filter_saturated = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.000,0.8,0,0)
	saturation_filters = list()
	for(var/obj/our_plane_master in wave_plane_masters)
		our_plane_master.filters += filter(type = "color", color = col_filter_identity, space = FILTER_COLOR_HSL)
		var/color_filter = our_plane_master.filters[length(our_plane_master.filters)]
		saturation_filters[our_plane_master] = color_filter
		//this animation doesn't loop, only happens once
		animate(color_filter, color = col_filter_saturated, flags = ANIMATION_PARALLEL)

/datum/reagent/mdma/proc/hud_color_filter()
	//this is RGB, not anything else
	var/static/list/col_filter_identity = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	var/static/list/col_filter_purple = list(1,0,0,0, 0.6,0.3,0.6,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	var/static/list/col_filter_blue = list(1,0,0,0, 0.1,0.2,0.9,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	hud_plane_master.filters += filter(type = "color", color = col_filter_identity)
	var/color_filter = hud_plane_master.filters[length(hud_plane_master.filters)]
	animate(color_filter, color = col_filter_identity, time = 0 SECONDS, loop = -1, flags = ANIMATION_PARALLEL)
	animate(color = col_filter_purple, time = 6 SECONDS)
	animate(color = col_filter_blue, time = 4 SECONDS)
	animate(color = col_filter_identity, time = 2 SECONDS)

/datum/reagent/mdma/on_mob_life(var/mob/living/carbon/human/M as mob)
	if(!M)
		M = holder.my_atom
	if(!istype(M))
		holder.remove_reagent(src.id, metabolization_rate)
		return
	if(first_life)
		first_life = FALSE
		//gotta get a grip
		if(M.client)
			music = sound('sound/music/slowslippy.ogg', TRUE, 0, volume = 80)
			M.client << music
			to_chat(M, "<span class='horriblestate' style='font-size: 135%;'><b><i>Gotta get a grip!</i></b></span>")
			wave_plane_masters = list()
			for(var/obj/our_plane_master in M.client.usingPlanes)
				var/obj/ripple_controller/R = new
				M?.client.screen.Add(R)
				R.plane = our_plane_master.plane+11
				R.render_source = our_plane_master.render_target
				wave_plane_masters += R
			//special case since no plane master handles the hud
			hud_plane_master = new /obj/screen_controller()
			hud_plane_master.plane = 30
			M.client.screen += hud_plane_master
			wave_filter()
			saturation_filter()
			hud_color_filter()
	if(prob(8))
		M.emote(pick("drool", "twitch"))
	if(prob(3))
		M.emote(pick("agonyscream","scream"))
	M.adjustStaminaLoss(-6)
	M.hydration -= THIRST_FACTOR //mdma doubles thirst
	holder.remove_reagent(src.id, 2 * REAGENTS_METABOLISM)

/datum/reagent/mdma/on_remove(data)
	. = ..()
	var/mob/living/carbon/human/M = holder?.my_atom
	if(!istype(M))
		return
	if(M.client && music)
		music.file = null
		M.client << music
	if(music)
		qdel(music)
		music = null
	if(length(wave_plane_masters))
		for(var/obj/our_plane_master in wave_plane_masters)
			//this is fucking stupid
			if(length(wave_filters))
				our_plane_master.filters -= wave_filters[our_plane_master]
			if(length(saturation_filters))
				our_plane_master.filters -= saturation_filters[our_plane_master]
		wave_plane_masters = null
	saturation_filters = null
	wave_filters = null
	if(hud_plane_master)
		M.client?.screen -= hud_plane_master
		M.client?.screen -= wave_plane_masters
		for(var/obj/P in wave_plane_masters)
			qdel(P)
		qdel(hud_plane_master)
		hud_plane_master = null

/datum/reagent/changa
	name = "STIMM"
	id = "changa"
	description = "A volatile mix created originally for suicidal tribunal forces. It'll make you fight a Graga and win."
	reagent_state = LIQUID
	color = "#ff0000" // rgb: 255, 0, 0
	addiction_threshold = 15
	var/obj/hud_plane_master
	var/list/red_plane_masters
	var/list/red_filters
	var/sound/music

/datum/reagent/changa/proc/red_filter()
	//this is RGB, not anything else
	var/static/list/col_filter_identity = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	//this literally replaces all of the green with red, and makes what is already red twice as bright
	var/static/list/col_filter_red = list(2,0,0,0, 1,0.15,0,0, 0.35,0,1,0, 0,0,0,1, 0.000,0,0,0)
	red_filters = list()
	for(var/obj/our_plane_master in red_plane_masters)
		our_plane_master.filters += filter(type = "color", color = col_filter_identity)
		var/color_filter = our_plane_master.filters[length(our_plane_master.filters)]
		red_filters[our_plane_master] = color_filter
		animate(color_filter, color = col_filter_identity, time = 0 SECONDS, loop = -1, flags = ANIMATION_PARALLEL)
		animate(color = col_filter_red, time = 0.25 SECONDS)
		animate(color = col_filter_red, time = 0.25 SECONDS)
		animate(color = col_filter_identity, time = 0.25 SECONDS)

/datum/reagent/changa/proc/hud_red_filter()
	//this is RGB, not anything else
	var/static/list/col_filter_identity = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	//Reddens all of the colors
	var/static/list/col_filter_red = list(2,0,0,0, 0.5,1,0,0, 0.5,0,1,0, 0,0,0,1, 0.000,0,0,0)
	hud_plane_master.filters += filter(type = "color", color = col_filter_identity)
	var/color_filter = hud_plane_master.filters[length(hud_plane_master.filters)]
	animate(color_filter, color = col_filter_identity, time = 0 SECONDS, loop = -1, flags = ANIMATION_PARALLEL)
	animate(color = col_filter_red, time = 0.25 SECONDS)
	animate(color = col_filter_identity, time = 0.25 SECONDS)

/datum/reagent/changa/on_mob_life(var/mob/living/carbon/human/M as mob)
	if(!M)
		M = holder.my_atom
	if(!istype(M))
		holder.remove_reagent(src.id, metabolization_rate)
		return
	if(first_life)
		first_life = FALSE
		//gotta get a grip
		M.my_stats.add_mod("changa", stat_list(ST = 8, HT = -2, DX = -5, IN = 1), time = 15 MINUTES) //holy shit this drug fucks your stats. Why would you ever take it?
		if(M.client)
			music = sound('sound/music/fahkeet.ogg', TRUE, 0, volume = 80)
			M.client << music
			to_chat(M, "<span class='hugepain' style='font-size: 150%;'><b><i>RIP AND TEAR!</i></b></span>")
			red_plane_masters = list()
			for(var/obj/our_plane_master in M.client.usingPlanes)
				red_plane_masters += our_plane_master
			//special case since no plane master handles the hud
			hud_plane_master = new /obj/screen_controller()
			hud_plane_master.plane = 30
			M.client.screen += hud_plane_master
			red_filter()
			hud_red_filter()
	if(prob(12))
		if(M.gender == MALE)
			playsound(M.loc, pick('sound/voice/maletired1.ogg','sound/voice/maletired2.ogg','sound/voice/maletired3.ogg'), 90, 0, -1)
		else
			playsound(M.loc, pick('sound/voice/femtired1.ogg','sound/voice/femtired2.ogg','sound/voice/femtired3.ogg','sound/voice/femtired4.ogg'), 90, 0, -1)
	else if(prob(8))
		M.emote(pick("agonyscream","scream"))
	if(M.client)
		spawn(0)
			var/shakeit = 0
			while(shakeit < 20)
				shakeit++
				animate(M.client, M.client.pixel_y = M.client.pixel_y + 1, time = 0.5)
				sleep(0.5)
				animate(M.client, M.client.pixel_y = M.client.pixel_y - 1, time = 0.5)
				sleep(0.5)
	holder.remove_reagent(src.id, 3 * REAGENTS_METABOLISM)

/datum/reagent/changa/on_remove(data)
	. = ..()
	var/mob/living/carbon/human/M = holder?.my_atom
	if(!istype(M))
		return
	if(M.client && music)
		music.file = null
		M.client << music
	if(music)
		qdel(music)
		music = null
	if(length(red_plane_masters))
		for(var/obj/our_plane_master in red_plane_masters)
			//this is fucking stupid
			if(length(red_filters))
				our_plane_master.filters -= red_filters[our_plane_master]
		red_plane_masters = null
	red_filters = null
	if(hud_plane_master)
		M.client?.screen -= hud_plane_master
		qdel(hud_plane_master)
		hud_plane_master = null

/datum/reagent/kalocin
	name = "Kalocin"
	id = "kalocin"
	description = "Cures AIDS and Cough."
	reagent_state = LIQUID
	color = "#9100f1"


// ALCOHOLISM REWORK

// Heroin! Everyones favorite
/datum/reagent/heroinlq
	name = "Desomorphine"
	id = "heroinlq"
	description = "Cheap synthetic opioid. It's extremely dangerous to use."
	reagent_state = LIQUID
	color = "#29170e"
	overdose_threshold = 6 // It's extremely easy to OD on this shit.
	reaction_mob(var/mob/living/carbon/human/M as mob)
		if(!M.reagents.has_reagent("gelabine"))
			..()
		M.my_stats.add_mod("heroin", stat_list(DX = -4,ST = -2), time = 600)
		M.so_high()
		M << 'sound/webbers/hhh.ogg'
		M.add_event("heroin", /datum/happiness_event/misc/argh)
		if(prob(15))
			var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
			H.heart_attack()
	overdose_process(var/mob/living/carbon/human/M as mob)
		var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
		H.heart_attack()
	on_mob_life(var/mob/living/carbon/human/M as mob)
		M.reagents.add_reagent("dentrine", 2)
		if(prob(40))
			M.setHalLoss(0)
		..()
		if(M.vice == "Addict (Heroin)")
			M.viceneed = 0

/datum/reagent/heroinhq
	name = "Morphine"
	id = "heroinhq"
	description = "An extremely expensive and pure form of opioid. Known for it's high functioning high"
	reagent_state = LIQUID
	color = "#29170e"
	overdose_threshold = 10 // Morphine is harder to OD on than heroin, but still dangerous
	reaction_mob(var/mob/living/carbon/human/M as mob)
		if(!M.reagents.has_reagent("gelabine"))
			..()
		M.my_stats.add_mod("heroin", stat_list(DX = -1), time = 800)
		M.so_high()
		M.add_event("heroin", /datum/happiness_event/misc/argh)
		if(prob(2))
			var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
			H.heart_attack()
	overdose_process(var/mob/living/carbon/human/M as mob)
		var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
		H.heart_attack()
	on_mob_life(var/mob/living/carbon/human/M as mob)
		M.reagents.add_reagent("dentrine", 2)
		if(prob(40))
			M.setHalLoss(0)
		..()
		if(M.vice == "Addict (Heroin)")
			M.viceneed = 0

// STIMULANTS! Eat someones face off and jerk off into the kitchen sink!

/datum/reagent/apvp
	name = "A-PVP"
	id = "apvp"
	description = "An extremely cheap and potent stimulant noted for causing insanity"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 15
	reaction_mob(var/mob/living/carbon/human/M as mob)
		M.COCAINA()
		M.add_event("cocaine", /datum/happiness_event/misc/woo)
		M.my_stats.add_mod("cocaine", stat_list(DX = 2,ST = 2,IN = -5), time = 400) // Makes you clinically retarded in more ways than one
		if(prob(30))
			var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
			H.take_damage(5)
	overdose_process(var/mob/living/carbon/human/M as mob)
		var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
		H.heart_attack()
	on_mob_life(var/mob/living/carbon/human/M as mob)
		M.stamina_loss = max(0, M.stamina_loss-2)
		..()
		if(M.vice == "Addict (Cocaine)")
			M.viceneed = 0
		return

/datum/reagent/amphetamine
	name = "Amphetamine"
	id = "amphetamine"
	description = "An relatively cheap and cut form of stimulant."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 15
	reaction_mob(var/mob/living/carbon/human/M as mob)
		M.COCAINA()
		M.add_event("cocaine", /datum/happiness_event/misc/woo)
		M.my_stats.add_mod("cocaine", stat_list(DX = 2,ST = 2,IN = -3), time = 600)
		if(prob(20))
			var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
			H.take_damage(5)
	overdose_process(var/mob/living/carbon/human/M as mob)
		var/datum/organ/internal/heart/H = M.internal_organs_by_name["heart"]
		H.heart_attack()
	on_mob_life(var/mob/living/carbon/human/M as mob)
		M.stamina_loss = max(0, M.stamina_loss-2)
		..()
		if(M.vice == "Addict (Cocaine)")
			M.viceneed = 0
		return

		// TESTING