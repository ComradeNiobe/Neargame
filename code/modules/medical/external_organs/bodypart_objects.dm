//a gente usa datum de orgao por enquanto
//entao por enquanto fica essa merda escrota de item aqui
/obj/item/organ
	icon = 'icons/neargame/zion362/mob/human.dmi'
	var/body_part

/obj/item/organ/New(loc, mob/living/carbon/human/H)
	..(loc)
	if(!istype(H))
		return
	if(H.dna)
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA[H.dna.unique_enzymes] = H.dna.b_type

	//Forming icon for the limb

	//Setting base icon for this mob's race
	var/icon/base = icon(src.icon)
	if(base)
		//Changing limb's skin tone to match owner
		if(!H.species || H.species.flags & HAS_SKIN_TONE)
			if (H.s_tone >= 0)
				base.Blend(rgb(H.s_tone, H.s_tone, H.s_tone), ICON_ADD)
			else
				base.Blend(rgb(-H.s_tone,  -H.s_tone,  -H.s_tone), ICON_SUBTRACT)

//	if(base)
		//Changing limb's skin color to match owner
//		if(!H.species || H.species.flags & HAS_SKIN_COLOR)
//			base.Blend(rgb(H.r_skin, H.g_skin, H.b_skin), ICON_ADD)

	icon = base
	dir = 2
	if(istype(src, /obj/item/organ/head))
		return
	else
		src.transform = turn(src.transform, pick(90, 180, 360, 0))

/obj/item/bone
	name = "bone"
	desc = "To pick with you."
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "bone"
	drop_sound = 'sound/items/bone_drop.ogg'
	force = 21
	layer = 3.1

/obj/item/skull
	name = "skull"
	desc = "How poetic."
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "skull"
	drop_sound = 'sound/items/bone_drop.ogg'
	layer = 3.1

/obj/item/skull/attackby(obj/item/W as obj, mob/living/carbon/human/user as mob)
	if(W.sharp)
		if(do_after(user, 20))
			new/obj/item/reagent_containers/glass/skull(src.loc)
			qdel(src)


/obj/item/organ/attackby(obj/item/W as obj, mob/living/carbon/human/user as mob)
	if(W.sharp)
		if(do_after(user, 20))
			new/obj/item/bone(src.loc)
			new/obj/item/reagent_containers/food/snacks/meat(src.loc)
			qdel(src)

/obj/item/organ/head/attackby(obj/item/W as obj, mob/living/carbon/human/user as mob)
	if(W.sharp)
		if(do_after(user, 20))
			new/obj/item/skull(user.loc)
			new/obj/item/reagent_containers/food/snacks/meat(user.loc)
			new/obj/item/organ/eye(user.loc)
			new/obj/item/organ/eye(user.loc)
			new/obj/item/reagent_containers/food/snacks/organ/brain(user.loc)
			new/obj/item/organ/jaw(user.loc)
			qdel(src)

/obj/item/organ/eye
	name = "eye"
	desc = "an eye"
	icon_state = "eye"
	force = 10
	layer = 3.1
	item_worth = 1
	body_part = EYES
	icon = 'icons/obj/surgery.dmi'

/obj/item/organ/l_arm
	name = "severed left arm"
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "left_arm_nohand"
	item_state = "limb"
	force = 20
	body_part = ARM_LEFT

/obj/item/organ/l_foot
	name = "severed left foot"
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "left_foot"
	item_state = "limb"
	body_part = FOOT_LEFT

/obj/item/organ/l_hand
	name = "severed left hand"
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "left_hand"
	item_state = "limb"
	body_part =	HAND_LEFT

/obj/item/organ/l_leg
	name = "severed left leg"
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "left_leg_nofoot"
	item_state = "limb"
	force = 20
	body_part =	LEG_LEFT

/obj/item/organ/r_arm
	name = "severed right arm"
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "right_arm_nohand"
	item_state = "limb"
	force = 20
	body_part = ARM_RIGHT

/obj/item/organ/r_foot
	name = "severed right foot"
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "right_foot"
	item_state = "limb"
	body_part = FOOT_RIGHT

/obj/item/organ/r_hand
	name = "severed right hand"
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "right_hand"
	item_state = "limb"
	body_part = HAND_RIGHT

/obj/item/organ/r_leg
	name = "severed right leg"
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "right_leg_nofoot"
	item_state = "limb"
	force = 20
	body_part = LEG_RIGHT

/obj/item/organ/head
	name = "severed head"
	icon_state = "head_m_s"
	item_state = "head"
	var/mob/living/carbon/brain/brainmob
	var/marked = FALSE // Whether or not this head belonged to someone who was marked for death.
	var/brain_op_stage = 0
	body_part = HEAD
	dir = SOUTH

/obj/item/organ/head/posi
	name = "robotic head"

/obj/item/organ/head/New(loc, mob/living/carbon/human/H)
	if(istype(H))
		src.icon_state = H.gender == MALE? "head_m_s" : "head_f_s"
		overlays += H.generate_head_icon()
	..()
	spawn(5)
	if(brainmob && brainmob.client)
		brainmob.client.screen.len = null //clear the hud
		brainmob.stat = 2
		brainmob.death()
	if(H.excomunicated)
		marked = TRUE

	name = "[H.real_name]'s head"

	H.regenerate_icons()

/obj/item/organ/head/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->head
	H.ghostize(1)
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna.Clone()
	if(H.mind)
		H.mind.transfer_to(brainmob)
	brainmob.container = src

/obj/item/organ/head/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/surgery_tool/scalpel))
		switch(brain_op_stage)
			if(0)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] is beginning to have \his head cut open with [W] by [user].", 1)
				brainmob << "\red [user] begins to cut open your head with [W]!"
				user << "\red You cut [brainmob]'s head open with [W]!"

				brain_op_stage = 1

			if(2)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] is having \his connections to the brain delicately severed with [W] by [user].", 1)
				brainmob << "\red [user] begins to cut open your head with [W]!"
				user << "\red You cut [brainmob]'s head open with [W]!"

				brain_op_stage = 3.0
			else
				..()
	else if(istype(W,/obj/item/surgery_tool/circular_saw))
		switch(brain_op_stage)
			if(1)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] has \his head sawed open with [W] by [user].", 1)
				brainmob << "\red [user] begins to saw open your head with [W]!"
				user << "\red You saw [brainmob]'s head open with [W]!"

				brain_op_stage = 2
			if(3)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] has \his spine's connection to the brain severed with [W] by [user].", 1)
				brainmob << "\red [user] severs your brain's connection to the spine with [W]!"
				user << "\red You sever [brainmob]'s brain's connection to the spine with [W]!"

				user.attack_log += "\[[time_stamp()]\]<font color='red'> Debrained [brainmob.name] ([brainmob.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)])</font>"
				brainmob.attack_log += "\[[time_stamp()]\]<font color='orange'> Debrained by [user.name] ([user.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)])</font>"
				msg_admin_attack("[user] ([user.ckey]) debrained [brainmob] ([brainmob.ckey]) (INTENT: [uppertext(user.a_intent)]) (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

				//TODO: ORGAN REMOVAL UPDATE.
				if(istype(src,/obj/item/organ/head/posi))
					var/obj/item/device/mmi/posibrain/B = new(loc)
					B.transfer_identity(brainmob)
				else
					var/obj/item/reagent_containers/food/snacks/organ/brain/B = new(loc)
					B.transfer_identity(brainmob)

				brain_op_stage = 4.0
			else
				..()
	else
		..()
