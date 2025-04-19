//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
var/global/list/all_objectives = list()

/datum/objective
	var/datum/mind/owner = null			//Who owns the objective.
	var/explanation_text = "Nothing"	//What that person is supposed to do.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = 0					//currently only used for custom objectives.

	New(var/text)
		. = ..()
		all_objectives |= src
		if(text)
			explanation_text = text

	Destroy()
		all_objectives -= src
		return ..()

	proc/check_completion()
		return completed

	proc/find_target()
		var/list/possible_targets = list()
		for(var/datum/mind/possible_target in ticker.minds)
			if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2))
				possible_targets += possible_target
		if(possible_targets.len > 0)
			target = pick(possible_targets)


	proc/find_target_by_role(role, role_type=0)//Option sets either to check assigned role or special role. Default to assigned.
		for(var/datum/mind/possible_target in ticker.minds)
			if((possible_target != owner) && ishuman(possible_target.current) && ((role_type ? possible_target.special_role : possible_target.assigned_role) == role) )
				target = possible_target
				break



datum/objective/assassinate
	find_target()
		..()
		if(target && target.current)
			explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
		else
			explanation_text = "Free Objective"
		return target


	find_target_by_role(role, role_type=0)
		..(role, role_type)
		if(target && target.current)
			explanation_text = "Assassinate [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
		else
			explanation_text = "Free Objective"
		return target


	check_completion()
		if(target && target.current)
			if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current) || target.current.z > world.maxz || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
				return TRUE
			return FALSE
		return TRUE

datum/objective/mutiny
	find_target()
		..()
		if(target && target.current)
			explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
		else
			explanation_text = "Free Objective"
		return target


	find_target_by_role(role, role_type=0)
		..(role, role_type)
		if(target && target.current)
			explanation_text = "Assassinate [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(target && target.current)
			if(target.current.stat == DEAD || !ishuman(target.current) || !target.current.ckey)
				return TRUE
			var/turf/T = get_turf(target.current)
			if(T && (!(target.current.z in vessel_z)))			//If they leave the station they count as dead for this
				return 2
			return FALSE
		return TRUE

datum/objective/debrain//I want braaaainssss
	find_target()
		..()
		if(target && target.current)
			explanation_text = "Steal the brain of [target.current.real_name]."
		else
			explanation_text = "Free Objective"
		return target


	find_target_by_role(role, role_type=0)
		..(role, role_type)
		if(target && target.current)
			explanation_text = "Steal the brain of [target.current.real_name] the [!role_type ? target.assigned_role : target.special_role]."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(!target)//If it's a free objective.
			return TRUE
		if( !owner.current || owner.current.stat==DEAD )//If you're otherwise dead.
			return FALSE
		if( !target.current || !isbrain(target.current) )
			return FALSE
		var/atom/A = target.current
		while(A.loc)			//check to see if the brainmob is on our person
			A = A.loc
			if(A == owner.current)
				return TRUE
		return FALSE


datum/objective/protect//The opposite of killing a dude.
	find_target()
		..()
		if(target && target.current)
			explanation_text = "Protect [target.current.real_name], the [target.assigned_role]."
		else
			explanation_text = "Free Objective"
		return target


	find_target_by_role(role, role_type=0)
		..(role, role_type)
		if(target && target.current)
			explanation_text = "Protect [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(!target)			//If it's a free objective.
			return TRUE
		if(target.current)
			if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current))
				return FALSE
			return TRUE
		return FALSE


datum/objective/hijack
	explanation_text = "Hijack the Escape Pod A by escaping alone."

	check_completion()
		if(!owner.current || owner.current.stat)
			return FALSE
		if(emergency_shuttle.location<2)
			return FALSE
		if(issilicon(owner.current))
			return FALSE
		var/area/shuttle = locate(/area/shuttle/escape_pod1/centcom)
		var/list/protected_mobs = list(/mob/living/silicon/ai, /mob/living/silicon/pai)
		for(var/mob/living/player in player_list)
			if(player.type in protected_mobs)	continue
			if (player.mind && (player.mind != owner))
				if(player.stat != DEAD)			//they're not dead!
					if(get_turf(player) in shuttle)
						return FALSE
		return TRUE


datum/objective/block
	explanation_text = "Do not allow any organic lifeforms to escape on the shuttle alive."


	check_completion()
		if(!istype(owner.current, /mob/living/silicon))
			return FALSE
		if(emergency_shuttle.location<2)
			return FALSE
		if(!owner.current)
			return FALSE
		var/area/shuttle = locate(/area/shuttle/escape_pod1/centcom)
		var/area/shuttle2 = locate(/area/shuttle/escape_pod2/centcom)
		var/protected_mobs[] = list(/mob/living/silicon/ai, /mob/living/silicon/pai, /mob/living/silicon/robot)
		for(var/mob/living/player in player_list)
			if(player.type in protected_mobs)	continue
			if (player.mind)
				if (player.stat != 2)
					if (get_turf(player) in shuttle)
						return FALSE
					if (get_turf(player) in shuttle2)
						return FALSE
		return TRUE

datum/objective/silence
	explanation_text = "Do not allow anyone to escape the ship.  Only allow the pods to be sent when everyone is dead and your story is the only one left."

	check_completion()
		if(emergency_shuttle.location<2)
			return FALSE

		for(var/mob/living/player in player_list)
			if(player == owner.current)
				continue
			if(player.mind)
				if(player.stat != DEAD)
					var/turf/T = get_turf(player)
					if(!T)	continue
					switch(T.loc.type)
						if(/area/shuttle/escape/centcom, /area/shuttle/escape_pod1/centcom, /area/shuttle/escape_pod2/centcom, /area/shuttle/escape_pod3/centcom, /area/shuttle/escape_pod5/centcom)
							return FALSE
		return TRUE


/datum/objective/escape
	explanation_text = "Escape on the Ulysses alive and free."


	check_completion()
		if(issilicon(owner.current))
			return FALSE
		if(isbrain(owner.current))
			return FALSE
		if(emergency_shuttle.location<2)
			return FALSE
		if(!owner.current || owner.current.stat ==2)
			return FALSE
		var/turf/location = get_turf(owner.current.loc)
		if(!location)
			return FALSE

//		if(istype(location, /turf/simulated/shuttle/floor4)) // Fails tratiors if they are in the shuttle brig -- Polymorph
		if(istype(owner.current, /mob/living/carbon))
			var/mob/living/carbon/C = owner.current
			if (!C.handcuffed)
				return TRUE
//		return FALSE

		var/area/check_area = location.loc
		if(istype(check_area, /area/shuttle/escape/centcom))
			return TRUE
		else
			return FALSE

datum/objective/survive
	explanation_text = "Survive until the end."

	check_completion()
		if(!owner.current || owner.current.stat == DEAD || isbrain(owner.current))
			return FALSE		//Brains no longer win survive objectives. --NEO
		if(issilicon(owner.current) && owner.current != owner.original)
			return FALSE
		return TRUE

// Similar to the anti-rev objective, but for traitors
datum/objective/brig
	var/already_completed = 0

	find_target()
		..()
		if(target && target.current)
			explanation_text = "Have [target.current.real_name], the [target.assigned_role] brigged for 10 minutes."
		else
			explanation_text = "Free Objective"
		return target


	find_target_by_role(role, role_type=0)
		..(role, role_type)
		if(target && target.current)
			explanation_text = "Have [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] brigged for 10 minutes."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(already_completed)
			return TRUE

		if(target && target.current)
			if(target.current.stat == DEAD)
				return FALSE
			// Make the actual required time a bit shorter than the official time
			if(target.is_brigged(10 * 60 * 5))
				already_completed = 1
				return TRUE
			return FALSE
		return FALSE

// Harm a crew member, making an example of them
datum/objective/harm
	var/already_completed = 0

	find_target()
		..()
		if(target && target.current)
			explanation_text = "Make an example of [target.current.real_name], the [target.assigned_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
		else
			explanation_text = "Free Objective"
		return target


	find_target_by_role(role, role_type=0)
		..(role, role_type)
		if(target && target.current)
			explanation_text = "Make an example of [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(already_completed)
			return TRUE

		if(target && target.current && istype(target.current, /mob/living/carbon/human))
			if(target.current.stat == DEAD)
				return FALSE

			var/mob/living/carbon/human/H = target.current
			for(var/datum/organ/external/E in H.organs)
				if(E.status & ORGAN_BROKEN)
					already_completed = 1
					return TRUE
				if(E.status & ORGAN_DESTROYED && !E.amputated)
					already_completed = 1
					return TRUE

			var/datum/organ/external/face/F = H.get_organ("face")
			if(F.disfigured)
				return TRUE
		return FALSE


datum/objective/nuclear
	explanation_text = "Destroy the ship with a nuclear device."



datum/objective/steal
	var/obj/item/steal_target
	var/target_name

	var/global/possible_items[] = list(
		"the baron's suit" = /obj/item/clothing/suit/baron,
		"the baron's crown" = /obj/item/clothing/head/caphat,
		"a triton helmet" = /obj/item/clothing/head/helmet/sechelm,
	)

	var/global/possible_items_special[] = list(
		/*"nuclear authentication disk" = /obj/item/disk/nuclear,*///Broken with the change to nuke disk making it respawn on z level change.
		"the baron's suit" = /obj/item/clothing/suit/baron,
		"the baron's crown" = /obj/item/clothing/head/caphat,
		"a triton helmet" = /obj/item/clothing/head/helmet/sechelm,
	)


	proc/set_target(item_name)
		target_name = item_name
		steal_target = possible_items[target_name]
		if (!steal_target )
			steal_target = possible_items_special[target_name]
		explanation_text = "Steal [target_name]."
		return steal_target


	find_target()
		return set_target(pick(possible_items))


	proc/select_target()
		var/list/possible_items_all = possible_items+possible_items_special+"custom"
		var/new_target = input("Select target:", "Objective target", steal_target) as null|anything in possible_items_all
		if (!new_target) return
		if (new_target == "custom")
			var/obj/item/custom_target = input("Select type:","Type") as null|anything in typesof(/obj/item)
			if (!custom_target) return
			var/tmp_obj = new custom_target
			var/custom_name = tmp_obj:name
			qdel(tmp_obj)
			custom_name = sanitize(input("Enter target name:", "Objective target", custom_name) as text|null)
			if (!custom_name) return
			target_name = custom_name
			steal_target = custom_target
			explanation_text = "Steal [target_name]."
		else
			set_target(new_target)
		return steal_target

	check_completion()
		if(!steal_target || !owner.current)	return FALSE
		if(!isliving(owner.current))	return FALSE
		var/list/all_items = owner.current.get_contents()
		switch (target_name)
			if("28 moles of plasma (full tank)","10 diamonds","50 gold bars","25 refined uranium bars")
				var/target_amount = text2num(target_name)//Non-numbers are ignored.
				var/found_amount = 0.0//Always starts as zero.

				for(var/obj/item/I in all_items) //Check for plasma tanks
					if(istype(I, steal_target))
						found_amount += (target_name=="28 moles of plasma (full tank)" ? (I:air_contents:gas["plasma"]) : (I:amount))
				return found_amount>=target_amount

			if("50 coins (in bag)")
				var/obj/item/moneybag/B = locate() in all_items

				if(B)
					var/target = text2num(target_name)
					var/found_amount = 0.0
					for(var/obj/item/coin/C in B)
						found_amount++
					return found_amount>=target

			else

				for(var/obj/I in all_items) //Check for items
					if(istype(I, steal_target))
						return TRUE
		return FALSE


/*---------SUCCUBUS----------*/
datum/objective/succubus
	explanation_text = "Corrupt 5 men and consume their souls through a coitus!"

	check_completion()
		if(owner && owner.succubus && LAZYLEN(owner.succubus.succubusSlaves) >= 5)
			return TRUE
		else
			return FALSE

datum/objective/succubusTwo
	explanation_text = "Ensure that you are the only Succubus in the fortress!"

	check_completion()
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.gender == "female" && !H.isChild() && !H.outsider && is_succubus(H))
				if(H.stat != DEAD)
					return FALSE
				else
					return TRUE

// SOCIETY
/datum/objective/society
	explanation_text = "We should reach the outside world using the Ulysses with no one else aboard."

/datum/objective/society/check_completion()
	if(emergency_shuttle.location<2)
		return FALSE

	var/area/shuttle = locate(/area/shuttle/escape/centcom)
	for(var/mob/living/carbon/human/player in player_list)
		if(player.mind)
			if(player.stat != DEAD)
				if(get_turf(player) in shuttle)
					if(!is_they(player))
						return FALSE
	return TRUE

/datum/objective/societyAssimilate
	explanation_text = "One of those who reached the outside world should wear the face of someone from the baron's kin."

/datum/objective/societyAssimilate/check_completion()
	if(emergency_shuttle.location<2)
		return FALSE

	var/area/shuttle = locate(/area/shuttle/escape/centcom)
	for(var/mob/living/carbon/human/player in player_list)
		if(is_they(player))
			if(player.stat != DEAD)
				if(get_turf(player) in shuttle)
					switch(player.job)
						if("Baron", "Baroness", "Heir", "Successor")
							return TRUE
	return FALSE
