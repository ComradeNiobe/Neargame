//This is an uguu head restoration surgery TOTALLY not yoinked from chinsky's limb reattacher


/datum/surgery_step/head/
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (!affected)
			return 0
		if (!(affected.status & ORGAN_DESTROYED))
			return 0
		if (affected.parent)
			if (affected.parent.status & ORGAN_DESTROYED)
				return 0
		return affected.name == "head"


/datum/surgery_step/head/peel
	allowed_tools = list(
	/obj/item/retractor = 100,		\
	/obj/item/crowbar = 75,	\
	/obj/item/kitchen/utensil/fork = 50, 		\
	)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/datum/organ/external/affected = target.get_organ(target_zone)
			return !(affected.status & ORGAN_CUT_AWAY)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts peeling back tattered flesh where [target]'s head used to be with \the [tool].", \
		"You start peeling back tattered flesh where [target]'s head used to be with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] peels back tattered flesh where [target]'s head used to be with \the [tool].",	\
		"\blue You peel back tattered flesh where [target]'s head used to be with \the [tool].")
		affected.status |= ORGAN_CUT_AWAY

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected.parent)
			affected = affected.parent
			user.visible_message("\red [user]'s hand slips, ripping [target]'s [affected.display_name] open!", \
			"\red Your hand slips,  ripping [target]'s [affected.display_name] open!")
			affected.createwound(CUT, 10)


/datum/surgery_step/head/shape
	allowed_tools = list(
	/obj/item/FixOVein = 100, 	\
	/obj/item/stack/cable_coil = 75,	\
	/obj/item/device/assembly/mousetrap = 10) //ok chinsky

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/datum/organ/external/affected = target.get_organ(target_zone)
			return affected.status & ORGAN_CUT_AWAY && target.op_stage.head_reattach == 0 && !(affected.status & ORGAN_ATTACHABLE)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to reshape [target]'s esophagal and vocal region with \the [tool].", \
		"You start to reshape [target]'s [affected.display_name] esophagal and vocal region with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\blue [user] has finished repositioning flesh and tissue to something anatomically recognizable where [target]'s head used to be with \the [tool].",	\
		"\blue You have finished repositioning flesh and tissue to something anatomically recognizable where [target]'s head used to be with \the [tool].")
		target.op_stage.head_reattach = 1

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected.parent)
			affected = affected.parent
			user.visible_message("\red [user]'s hand slips, further rending flesh on [target]'s neck!", \
			"\red Your hand slips, further rending flesh on [target]'s neck!")
			target.apply_damage(10, BRUTE, affected)

/datum/surgery_step/head/suture
	allowed_tools = list(
	/obj/item/hemostat = 100, 	\
	/obj/item/stack/cable_coil = 60,	\
	/obj/item/FixOVein = 80)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			return target.op_stage.head_reattach == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] is stapling and suturing flesh into place in [target]'s esophagal and vocal region with \the [tool].", \
		"You start to staple and suture flesh into place in [target]'s esophagal and vocal region with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\blue [user] has finished stapling [target]'s neck into place with \the [tool].",	\
		"\blue You have finished stapling [target]'s neck into place with \the [tool].")
		target.op_stage.head_reattach = 2

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected.parent)
			affected = affected.parent
			user.visible_message("\red [user]'s hand slips, ripping apart flesh on [target]'s neck!", \
			"\red Your hand slips, ripping apart flesh on [target]'s neck!")
			target.apply_damage(10, BRUTE, affected)

/datum/surgery_step/head/prepare
	allowed_tools = list(
	/obj/item/cautery = 100,			\
	/obj/item/clothing/mask/cigarette = 75,	\
	/obj/item/flame/lighter = 50,			\
	/obj/item/weldingtool = 25
	)

	min_duration = 60
	max_duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			return target.op_stage.head_reattach == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts adjusting area around [target]'s neck with \the [tool].", \
		"You start adjusting area around [target]'s neck with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] has finished adjusting the area around [target]'s neck with \the [tool].",	\
		"\blue You have finished adjusting the area around [target]'s neck with \the [tool].")
		target.op_stage.head_reattach = 0
		affected.status |= ORGAN_ATTACHABLE
		affected.amputated = 1
		affected.setAmputatedTree()
		affected.open = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected.parent)
			affected = affected.parent
			user.visible_message("\red [user]'s hand slips, searing [target]'s neck!", \
			"\red Your hand slips, searing [target]'s [affected.display_name]!")
			target.apply_damage(10, BURN, affected)


/datum/surgery_step/head/attach
	allowed_tools = list(/obj/item/organ/head = 100)
	can_infect = 0

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/datum/organ/external/head = target.get_organ(target_zone)
			return head.status & ORGAN_ATTACHABLE

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts attaching [tool] to [target]'s reshaped neck.", \
		"You start attaching [tool] to [target]'s reshaped neck.")

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] has attached [target]'s head to the body.",	\
		"\blue You have attached [target]'s head to the body.")
		affected.status = 0
		affected.amputated = 0
		affected.destspawn = 0
		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()
		var/obj/item/organ/head/B = tool
		if (B.brainmob.mind)
			B.brainmob.mind.transfer_to(target)
		del(B)


	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, damaging connectors on [target]'s neck!", \
		"\red Your hand slips, damaging connectors on [target]'s neck!")
		target.apply_damage(10, BRUTE, affected, sharp=1)
