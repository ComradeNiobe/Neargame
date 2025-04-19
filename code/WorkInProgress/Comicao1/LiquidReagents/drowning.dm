/mob/living/carbon/human
	var/constantly_drowning = FALSE
	var/drown_counter = 0

/mob/living/carbon/human/proc/undrown()
	constantly_drowning = FALSE
	drown_counter = 0
	if(client)
		client.color = null

/mob/living/carbon/human/proc/sink_like_a_rock()
	if(istype(loc, /turf/simulated/floor/exoplanet/water/shallow/river/east))
		var/turf/T = get_turf_below()
		if(T && !T.density)
			visible_message("<span class='bname'>[src.name]</span> sinks to the bottom!")
			forceMove(T)//Move them down. They are in the drown zone now. No hope of recovery.

/mob/living/carbon/human/proc/check_for_drowning()//Whether we should bother doing drowning shit at all.
//	if(!loc:liquid)
//		return FALSE
//	if(!loc:liquid:depth>=165)
//		return FALSE
	if(istype(wear_mask, /obj/item/clothing/mask/breath) || istype(wear_mask, /obj/item/clothing/mask/gas))
		if(internal)
			return FALSE
	if(stat == DEAD)
		return FALSE
	if(isVampire)
		return FALSE
	if(holding_breath)
		return FALSE
	if(stamina_loss>=100) //They've floundered too much, don't bother checking the swim skill.
		handle_drowning()
	
/mob/living/carbon/human/proc/flounder()
	var/bother_doing_stats_check = TRUE //If they're wearing armor skip the swimming skill. You're going to drown in heavy armor asshole.
	if(istype(wear_suit, /obj/item/clothing/suit/armor))
		src.sink_like_a_rock()
	if(bother_doing_stats_check)
		var/DXTOTAL = src.my_stats.get_stat(STAT_DX) * 3
		if(!(prob(70-DXTOTAL) && !skillcheck(src.my_skills.get_skill(SKILL_SWIM), 40, 0, src)) || stamina_loss>=50)//They passed the drowning check.
			src.visible_message("<span class='bname'>[src.name]</span> flounders in water!")
			src.adjustStaminaLoss(rand(10,25))
			playsound(src.loc, 'sound/effects/fst_water_jump_down_01.ogg', 80, 1, -1)
		else src.visible_message("<span class='bname'>[src.name]</span> swims in water!")

/mob/living/carbon/human/proc/apply_constant_drowning()//Only do this if we are actively drowning.
	if(constantly_drowning)
		adjustOxyLoss(15)//If you are suiciding, you should die a little bit faster
		failed_last_breath = 1

/mob/living/carbon/human/proc/handle_drowning(var/cor)

	if(cor && client)
		client.color = cor
	if(src.gender == "male")
		playsound(src.loc, 'sound/effects/drown.ogg', rand(35,50), 1)
	else
		playsound(src.loc, 'sound/effects/drown_female.ogg', rand(35,50), 1)
	visible_message("[src] drowns!")
	var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
	animation.pixel_y = 16
	animation.icon_state = "blank"
	animation.icon = 'icons/life/reagents.dmi'
	animation.master = src
	flick(animation, "bubbles")
	spawn(25)
		qdel(animation)

	if(src?:loc?:liquid?:reagents?.total_volume)
		if(!(wear_mask && wear_mask.flags & MASKCOVERSMOUTH))
			src:loc:liquid:reagents?.reaction(src, INGEST)
			spawn(5)
				src:loc:liquid?:reagents?.trans_to(src, 5)
				src:loc:liquid?:depth -= 5
	var/DXTOTAL = src.my_stats.get_stat(STAT_DX) * 2
	if((istype(wear_suit, /obj/item/clothing/suit/armor)) || (!(prob(70-DXTOTAL) && !skillcheck(src.my_skills.get_skill(SKILL_SWIM), 40, 0, src))))
		src.sink_like_a_rock()
	
	return TRUE // Presumably chemical smoke can't be breathed while you're underwater.

/mob/living/carbon/human/proc/check_for_pressure()
	var/turf/S = get_area(src)
	if(istype(S, /area/seafloor))
		if(stat) // stops the loop if dead.
			return
		if((istype(wear_suit, /obj/item/clothing/suit/space)) && (istype(head, /obj/item/clothing/head/helmet/space)))
			return FALSE
		else 
			handle_pressure()

/mob/living/carbon/human/proc/handle_pressure()
	to_chat(src, "The pressure is too much!")
	apply_damage(10, BRUTE, pick("r_foot","l_foot","r_leg","l_leg","groin","r_hand","l_hand","vitals","throat","chest","r_arm","l_arm","mouth","face","right eye","left eye","head"))
	sleep(40)
	check_for_pressure()
