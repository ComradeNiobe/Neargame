/datum/organ/external/chest
	name = "chest"
	icon_name = "chest"
	display_name = "chest"
	display_namebr = "peito"
	max_damage = 75
	min_broken_damage = 100
	body_part = UPPER_TORSO
	vital = 1
	encased = "ribcage"
	iconsdamage = "chest"
	mask_color = "#000000"

/datum/organ/external/chest/droplimb(override, no_explode, gibbed)
	return

/datum/organ/external/chest/get_icon(var/icon/race_icon, var/icon/deform_icon,gender="", var/fat, var/lfwblocked = 0, var/lying = 0)
	if(gender != "f" || fat || !(istype(owner.species, /datum/species/skinless)))
		return ..()
	var/prefix = ""
	if(istype(owner.species,/datum/species/human/child)) //race_icon wille already be the child set.
		gender = "c"
	else if(owner.age >= 60 && !istype(owner.species, /datum/species/skinless))
		race_icon = 'icons/mob/flesh/old/human_old.dmi'
		prefix = "old_"
//	else if(owner.pregnant)
	//	if(!istype(owner.species, /datum/species/skinless))
//			race_icon = 'icons/mob/flesh/old/human_old.dmi'
//		gender = "p"

	var/ls = lying ? "_l" : "_s"
	if (lfwblocked)
		return new /icon(race_icon, "[prefix][icon_name][gender ? "_[gender]" : ""][lfwblockedicon ? "_c" : ""]")

	return new /icon(race_icon, "[prefix][icon_name][gender ? "_[gender]" : ""][ls]")