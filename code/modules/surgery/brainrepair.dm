//////////////////////////////////////////////////////////////////
//				BRAIN DAMAGE FIXING								//
//////////////////////////////////////////////////////////////////
/*
/datum/surgery_step/brain/bone_chips
	allowed_tools = list(
	/obj/item/surgery_tool/hemostat = 100, 		\
	/obj/item/wirecutters = 75, 		\
	/obj/item/kitchen/utensil/fork = 20
	)

	priority = 3
	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		var/datum/organ/internal/brain/sponge = target.internal_organs_by_name["brain"]
		return (sponge && sponge.damage > 0 && sponge.damage <= 20) && affected.open == 3

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts taking bone chips out of [target]'s brain with \the [tool].", \
		"You start taking bone chips out of [target]'s brain with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\blue [user] takes out all the bone chips in [target]'s brain with \the [tool].",	\
		"\blue You take out all the bone chips in [target]'s brain with \the [tool].")
		var/datum/organ/internal/brain/sponge = target.internal_organs_by_name["brain"]
		if (sponge)
			sponge.damage = 0
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\red [user]'s hand slips, jabbing \the [tool] in [target]'s brain!", \
		"\red Your hand slips, jabbing \the [tool] in [target]'s brain!")
		target.apply_damage(30, BRUTE, "head", 1, sharp=1)
		..()

/datum/surgery_step/brain/hematoma
	allowed_tools = list(
	/obj/item/surgery_tool/FixOVein = 100, \
	/obj/item/surgery_tool/suture = 100, \
	/obj/item/stack/cable_coil = 75
	)

	priority = 3
	min_duration = 30
	max_duration = 60

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		var/datum/organ/internal/brain/sponge = target.internal_organs_by_name["brain"]
		return (sponge && sponge.damage > 20) && affected.open == 3

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts mending hematoma in [target]'s brain with \the [tool].", \
		"You start mending hematoma in [target]'s brain with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\blue [user] mends hematoma in [target]'s brain with \the [tool].",	\
		"\blue You mend hematoma in [target]'s brain with \the [tool].")
		playsound(user.loc, 'sound/effects/sewing.ogg', 50, 1, -3)
		var/datum/organ/internal/brain/sponge = target.internal_organs_by_name["brain"]
		if (sponge)
			sponge.damage = 20
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\red [user]'s hand slips, bruising [target]'s brain with \the [tool]!", \
		"\red Your hand slips, bruising [target]'s brain with \the [tool]!")
		target.apply_damage(20, BRUTE, "head", 1, sharp=1)
		..()
*/



/datum/surgery_step/open_encased/saw_head
	allowed_tools = list(
	/obj/item/surgery_tool/circular_saw = 100, \
	/obj/item/hatchet = 75
	)

	min_duration = 50
	max_duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return
		if (target_zone != "head")
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return affected.open >= 1 && affected.stage == 0

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("[user] begins to cut through [target]'s skull with \the [tool].", \
		"You begin to cut through [target]'s skull with \the [tool].")
		target.custom_pain("Something hurts horribly in your [affected.display_name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("<span class='passive'>[user] has cut [target]'s skull open with \the [tool].</span>",		\
		"<span class='passive'>You have cut [target]'s skull open with \the [tool].</span>")
		affected.fracture()
		affected.stage = 2
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("<span class='combat'>[user]'s hand slips, cracking [target]'s skull with \the [tool]!</span>" , \
		"<span class='combat'>Your hand slips, cracking [target]'s skull with \the [tool]!</span>" )

		affected.createwound(CUT, 20)
		affected.fracture()
		..()

/datum/surgery_step/open_encased/speculum_head
	allowed_tools = list(
	/obj/item/surgery_tool/speculum = 100
	)

	min_duration = 1
	max_duration = 1

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return
		if (target_zone != "head")
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return affected.open >= 1 && affected.stage == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "[user] starts to force open the skull in [target]'s [affected.display_name] with \the [tool]."
		var/self_msg = "You start to force open the skull in [target]'s [affected.display_name] with \the [tool]."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your [affected.display_name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='passive'>[user] forces open [target]'s skull with \the [tool].</span>"
		var/self_msg = "<span class='passive'>You force open [target]'s skull with \the [tool].</span>"
		user.visible_message(msg, self_msg)

		affected.open = 2
		user.drop_item()
		tool.loc = target
		affected.implants += tool
		target.embedded_flag = 1
		target.verbs += /mob/proc/yank_out_object
		target.update_surgery(1)
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='combat'>[user]'s hand slips, cracking [target]'s skull!</span>"
		var/self_msg = "<span class='combat'>Your hand slips, cracking [target]'s  skull!</span>"
		user.visible_message(msg, self_msg)

		affected.createwound(BRUISE, 5)
		..()

/datum/surgery_step/brain/hematoma
	allowed_tools = list(
	/obj/item/surgery_tool/retractor = 100,	\
	/obj/item/surgery_tool/suture = 50, \
	/obj/item/stack/cable_coil = 25
	)

	priority = 3
	min_duration = 30
	max_duration = 60

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		var/datum/organ/internal/brain/sponge = target.internal_organs_by_name["brain"]
		return (sponge && sponge.damage >= 1) && affected.open == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts reconstituting [target]'s brain with \the [tool].", \
		"You start reconstituting [target]'s brain with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\blue [user] reforms [target]'s brain with \the [tool].",	\
		"\blue You reform [target]'s brain with \the [tool].")
		playsound(user.loc, 'sound/effects/sewing.ogg', 50, 1, -3)
		var/datum/organ/external/head/affected = target.get_organ(target_zone)
		var/datum/organ/internal/brain/sponge = target.internal_organs_by_name["brain"]
		if (sponge)
			sponge.damage -= 20
		if(affected.brained)
			affected.brained = 0
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\red [user]'s hand slips, bruising [target]'s brain with \the [tool]!", \
		"\red Your hand slips, bruising [target]'s brain with \the [tool]!")
		target.apply_damage(20, BRUTE, "head", 1, sharp=1)
		..()