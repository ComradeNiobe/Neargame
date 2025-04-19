/datum/organ/external/groin
	name = "groin"
	icon_name = "groin"
	display_name = "groin"
	display_namebr = "virilha"
	max_damage = 90
	min_broken_damage = 65
	body_part = GROIN
	vital = 1
	iconsdamage = "chest"
	mask_color = "#ac151a"

//pinto penis
/datum/organ/external/groin/droplimb(var/override = 0,var/no_explode = 0, var/gibbed = 0)
	if(owner.has_penis())//Instead of bisecting them entirely just fucking drop their dick off.
		var/penis_size = owner.penis_size
		owner.visible_message("<span class='danger'><big>\The [owner]'s penis flies off in a bloody arc!</big></span>")
		playsound(owner, 'sound/effects/gore/severed.ogg', 50, 1, -1)
		if(gibbed || penis_size > 30)
			owner.mutilate_genitals()
		else
			var/obj/item/reagent_containers/food/snacks/organ/internal/penis/P = new /obj/item/reagent_containers/food/snacks/organ/internal/penis(owner.loc)
			P.set_penis_size(penis_size)
			owner.mutilate_genitals()
	..()

/datum/organ/external/groin/get_icon(var/icon/race_icon, var/icon/deform_icon,gender="", var/fat, var/lfwblocked = 0, var/lying = 0)
	if(!istype(owner.species, /datum/species/human))
		if(istype(owner.species,/datum/species/skinless))
			if(fat)
				race_icon = 'icons/mob/flesh/subhuman.dmi'
	else if(istype(owner.species,/datum/species/human/child)) //race_icon wille already be the child set.
		if(gender != "f")
			gender = "c"
	else if(fat)
		race_icon = 'icons/mob/flesh/old/human_fat_old.dmi'
	else if(gender == "f")
		if(owner.age >= 60)
			race_icon = 'icons/mob/flesh/old/human_old.dmi'

	var/ls = lying ? "_l" : "_s"
	return new /icon(race_icon, "[icon_name][gender ? "_[gender]" : ""][ls]")


/datum/organ/external/groin/do_actions(brute, burn, sharp, edge, var/used_weapon = null, list/forbidden_limbs = list(), var/delimbexplosion = 0, var/armor)
	if(brute)
		if(owner.has_penis())
			if(owner.stat) //Can't do this on dead people.
				return
			if(owner.knockdown_roll(-5))
				playsound(owner,"balls",100)
				owner.do_vomit()


/mob/living/carbon/human/proc/knockdown_roll(var/mod = 0)//major wound knockdown.
	var/list/roll = roll3d6(src, my_stats.get_stat(STAT_HT), mod = mod,hide_roll = TRUE, using_stat = TRUE)
	if(roll[GP_MARGIN] <= -5)
		AdjustParalysis(15)
		return 1
	if(roll[GP_RESULT] == GP_FAIL)
		KnockDown()
		return 1
	if(roll[GP_RESULT] == GP_CRITFAIL)
		AdjustParalysis(15)
		return 1
	return 0
