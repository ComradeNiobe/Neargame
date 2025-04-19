//Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/set_bone
	allowed_tools = list(
	/obj/item/surgery_tool/bonesetter = 100,	\
	/obj/item/wrench = 75		\
	)

	min_duration = 60
	max_duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return affected.open >= 1 && affected.stage == 0

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to set the bone in [target]'s [affected.display_name] in place with \the [tool]." , \
			"You are beginning to set the bone in [target]'s [affected.display_name] in place with \the [tool].")
		target.custom_pain("The pain in your [affected.display_name] is going to make you pass out!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected.status & ORGAN_BROKEN)
			user.visible_message("<span class='passive'>[user] sets the bone in [target]'s [affected.display_name] in place with \the [tool].</span>", \
				"<span class='passive'>You set the bone in [target]'s [affected.display_name] in place with \the [tool].</span>")
			affected.stage = 1
			..()
		else
			user.visible_message("<span class='passive'>[user] sets the bone in [target]'s [affected.display_name]\red in the WRONG place with \the [tool].</span>", \
				"<span class='passive'> You set the bone in [target]'s [affected.display_name]\red in the WRONG place with \the [tool].</span>")
			affected.fracture()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='combat'>[user]'s hand slips, damaging the bone in [target]'s [affected.display_name] with \the [tool]!</span>" , \
			"<span class='combat'>Your hand slips, damaging the bone in [target]'s [affected.display_name] with \the [tool]!</span>")
		affected.createwound(BRUISE, 5)
		..()

/datum/surgery_step/finish_bone
	allowed_tools = list(
	/obj/item/surgery_tool/bonegel = 100,	\
	/obj/item/screwdriver = 75
	)
	can_infect = 0
	blood_level = 1

	min_duration = 50
	max_duration = 60

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return affected.open >= 1 && affected.stage == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts to finish mending the damaged bones in [target]'s [affected.display_name] with \the [tool].", \
		"You start to finish mending the damaged bones in [target]'s [affected.display_name] with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='passive'> [user] has mended the damaged bones in [target]'s [affected.display_name] with \the [tool].</span>"  , \
			"<span class='passive'> You have mended the damaged bones in [target]'s [affected.display_name] with \the [tool].</span>" )
		affected.status &= ~ORGAN_BROKEN
		affected.status &= ~ORGAN_SPLINTED
		affected.stage = 0
		affected.perma_injury = 0
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='combat'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.display_name]!</span>" , \
		"<span class='combat'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.display_name]!</span>")
		..()
