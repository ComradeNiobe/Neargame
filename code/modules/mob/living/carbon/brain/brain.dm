//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/carbon/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	use_me = 0 //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"

	New()
		. = ..()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		updateStatPanel()

	Destroy()
		container = null
		QDEL_NULL(reagents)
		. = ..()

	say_understands(var/other)//Goddamn is this hackish, but this say code is so odd
		if (istype(other, /mob/living/silicon/ai))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/silicon/decoy))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/silicon/pai))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/silicon/robot))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/carbon/human))
			return 1
		return ..()


/mob/living/carbon/brain/update_canmove()
	if(in_contents_of(/obj/mecha))
		canmove = 1
		use_me = 1 //If it can move, let it emote
	else							canmove = 0
	return canmove