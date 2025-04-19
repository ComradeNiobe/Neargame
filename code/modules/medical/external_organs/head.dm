/datum/organ/external/head
	name = "head"
	icon_name = "head"
	display_name = "head"
	display_namebr = "cabeça"
	max_damage = 160
	min_broken_damage = 110
	body_part = HEAD
	canBeRemoved = 1
	delimb_min_damage = 130
	vital = 1
	encased = "skull"
	iconsdamage = "head"
	head_icon_needed = 1
	mask_color = "#ffffff"
	var/headwrenched = 0
	var/brained = 0
	var/list/ears = list()
	var/nose = null

/datum/organ/external/head/get_icon(var/icon/race_icon, var/icon/deform_icon,gender= null, var/fat, var/lfwblocked = 0, var/lying = 0)
	if (!owner || istype(owner.species, /datum/species/skinless))
	 return ..()
	var/g = gender ? gender : "m"
	if(owner.gender == FEMALE)	g = "f"
	var/ls = lying ? "_l" : "_s"
	if(fat)
		race_icon = 'icons/mob/flesh/old/human_fat_old.dmi'
	var/icon_draw = icon_name
	var/datum/organ/external/M = owner.get_organ("mouth")
	if(M.status & ORGAN_DESTROYED)
		if(!fat)
			race_icon = 'icons/mob/flesh/old/human_old.dmi'
		icon_draw = "x"+icon_draw
	if(gender == "f")
		if(owner.age >= 60)
			race_icon = 'icons/mob/flesh/old/human_old.dmi'
			icon_draw = "0"+icon_draw
	//	else if(owner.pregnant)
	//		race_icon = 'icons/mob/flesh/old/human_old.dmi'
	//		icon_draw = "0"+icon_draw

	var/icon/head_icon = null
	if (status & ORGAN_MUTATED)
		head_icon = new /icon(deform_icon, "[icon_draw]_[g][ls]")
	else
		head_icon = new /icon(race_icon, "[icon_draw]_[g][ls]")
	if(headwrenched)
		if(!lying)
			var/list/dirs = list(NORTH,SOUTH,EAST,WEST)
			var/times = 1
			for(var/i in 1 to dirs.len)
				var/get_dir = times ? dirs[i] * 2 : dirs[i] / 2
				head_icon.Insert((new/icon(head_icon,dir=get_dir)),dirs[i])
			times = !times
			return head_icon
		else
			head_icon.Insert((new/icon(head_icon,dir=NORTH,icon_state="[icon_draw]_[g]_s")),SOUTH)
	return head_icon

/datum/organ/external/head/proc/sag()
	owner?.emote("agonydeath")
	owner.visible_message("<span class='hitbold'>[owner.name]</span> <span class='hit'>sags on ground! \he won't regain consciousness soon.</span>")
	owner.Weaken(1)
	owner.ear_deaf = max(owner.ear_deaf,6)
	owner.CU()
	spawn(30)
		if(owner?.client)
			owner << output(null,"browseroutput:Purge")
			to_chat(owner, "WHO AM I?")
			sleep(5)
			to_chat(owner, "WHERE AM I?")
		owner.sleeping += rand(8,18)
		if(brute_dam >= 80)
			owner.Jitter(10)
			owner.sleeping += rand(8,18)



/datum/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list(), armor, specialAttack)
	..(brute, burn, sharp, edge, used_weapon, forbidden_limbs)
	var/datum/organ/external/face/F = locate() in owner.organs
	if(brute > 20 && !sharp && !edge)
		if(prob(30) && owner.head)
			var/obj/item/HAT = owner.head
			if(!istype(HAT, /obj/item/clothing/head/helmet))
				owner.drop_from_inventory(HAT)
	if(brute > 60 && !sharp && !edge)
		if(!ismonster(owner) && (!istype(owner.head, /obj/item/clothing/head/helmet) || brute / owner.my_stats.get_stat(STAT_HT) >= 5))
			if(prob(70-(owner.my_stats.get_stat(STAT_HT)*1.5)) && prob(80) || istype(used_weapon, /obj/item/melee/classic_baton) && prob(60-(owner.my_stats.get_stat(STAT_HT)*2)))
				sag()

	if (!F.disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")
	if(!brained)
		if(brute_dam > 90)
			if(prob(15-owner.my_stats.get_stat(STAT_HT)))
				breakskull()
	else
		var/datum/organ/internal/I = owner.internal_organs_by_name["brain"]
		if(I)
			I.take_damage(brute)
	owner.UpdateDamageIcon(1)

/datum/organ/external/head/rejuvenate()
	..()
	owner.unexpose_brain()

/datum/organ/external/head/proc/disfigure(var/type = "brute")
	var/datum/organ/external/face/F = locate() in owner.organs
	if (F.disfigured)
		return
	F.disfigured = 1

/datum/organ/external/head/proc/breakskull()
	if(brained)
		return
	owner.expose_brain()
	if(prob(90))
		owner.death(1)
	playsound(owner, pick('sound/effects/gore/blast.ogg','sound/effects/gore/blast2.ogg','sound/effects/gore/blast3.ogg','sound/effects/gore/blast4.ogg'), 130, 0, -1)

/datum/organ/external/head/proc/wrenchedhead()
	headwrenched = 1
	owner.QUEMLIGA = TRUE
	owner.update_body()
	owner.update_inv_glasses()
	owner.update_hair()
	owner.update_vision_cone()
	owner.UpdateDamageIcon()

/datum/organ/external/head/proc/unwrenchedhead()
	headwrenched = 0
	owner.QUEMLIGA = FALSE
	owner.update_body()
	owner.update_inv_glasses()
	owner.update_hair()
	owner.update_inv_head()
	owner.update_vision_cone()
	owner.UpdateDamageIcon()