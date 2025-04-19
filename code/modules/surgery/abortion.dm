/datum/surgery_step/open_uterus
	allowed_tools = list(
	/obj/item/surgery_tool/scalpel = 100,	\
	/obj/item/kitchenknife = 75		\
	)

	min_duration = 60
	max_duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		if (target.gender != FEMALE || target.pregnant != 1)
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return affected.open >= 1 && affected.stage == 0

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to cut open [target]'s uterus with \the [tool]." , \
			"You are beginning to cut open [target]'s uterus with \the [tool].")
		target.custom_pain("The pain in your [affected.display_name] is going to make you pass out!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='passive'>[user] opens an incision [target]'s uterus with \the [tool].</span>", \
			"<span class='passive'>You open an inceision in [target]'s uterus with \the [tool].</span>")
		affected.stage = 1
		..()
		
	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='combat'>[user]'s hand slips, causing massive bleeding [target]'s [affected.display_name] with \the [tool]!</span>" , \
			"<span class='combat'>Your hand slips, causing massive bleeding in [target]'s [affected.display_name] with \the [tool]!</span>")
		affected.createwound(BRUISE, 25)
		..()

/datum/surgery_step/perform_cleansing
	allowed_tools = list(
	/obj/item/surgery_tool/retractor = 100,	\
	)
	can_infect = 0
	blood_level = 1

	min_duration = 50
	max_duration = 60

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		if (target.gender != FEMALE && target.pregnant != 1)
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return affected.open >= 1 && affected.stage == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to sterilize [target]'s uterus with \the [tool].", \
		"You start to sterilize [target]'s uterus with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='passive'> [user] has sterilized [target]'s uterus with \the [tool].</span>"  , \
			"<span class='passive'> You have sterilized [target]'s uterus with \the [tool].</span>" )
		target.pregnant = 0
		affected.stage = 0
		if(target.wedlock)
			target.clear_event("pregnant", /datum/happiness_event/misc/pregnantbad)
			target.client.ChromieWinorLoose(1)
			target.wedlock = 0
		else		
			target.clear_event("pregnant", /datum/happiness_event/misc/pregnantgood)
			target.client.ChromieWinorLoose(-1)
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='combat'>[user]'s hand slips, causing the [tool] to tear [target]'s [affected.display_name]!</span>" , \
		"<span class='combat'>Your hand slips, causing the [tool] to tear [target]'s [affected.display_name]!</span>")
		affected.createwound(BRUTE, 25)
		..()