/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1
	return //This is broken for now.

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = H.get_active_hand()
		if(!I)
			H << "<span class='notice'>You are not holding anything to equip.</span>"
			return
		if(H.equip_to_appropriate_slot(I))
			if(hand)
				update_inv_l_hand(0)
			else
				update_inv_r_hand(0)
		else
			H << "\red You are unable to equip that."

/mob/living/carbon/human/proc/equip_in_one_of_slots(obj/item/W, list/slots, del_on_fail = 1)
	for (var/slot in slots)
		if (equip_to_slot_if_possible(W, slots[slot], del_on_fail = 0))
			return slot
	if (del_on_fail)
		qdel(W)
	return null


/mob/living/carbon/human/proc/has_organ(name)
	var/datum/organ/external/O = organs_by_name[name]

	return (O && !(O.status & ORGAN_DESTROYED) )

/mob/living/carbon/human/proc/has_organ_for_slot(slot)
	switch(slot)
		if(slot_back)
			return has_organ("chest")
		if(slot_wear_mask)
			return has_organ("head")
		if(slot_handcuffed)
			return has_organ("l_hand") && has_organ("r_hand")
		if(slot_legcuffed)
			return has_organ("l_leg") && has_organ("r_leg")
		if(slot_l_hand)
			return has_organ("l_hand")
		if(slot_r_hand)
			return has_organ("r_hand")
		if(slot_belt)
			return has_organ("chest")
		if(slot_wear_id)
			// the only relevant check for this is the uniform check
			return 1
		if(slot_l_ear)
			return has_organ("head")
		if(slot_r_ear)
			return has_organ("head")
		if(slot_glasses)
			return has_organ("head")
		if(slot_gloves)
			return has_organ("l_hand") || has_organ("r_hand")
		if(slot_head)
			return has_organ("head")
		if(slot_shoes)
			return has_organ("r_foot") || has_organ("l_foot")
		if(slot_wear_suit)
			return has_organ("chest")
		if(slot_w_uniform)
			return has_organ("chest")
		if(slot_l_store)
			return has_organ("chest")
		if(slot_r_store)
			return has_organ("chest")
		if(slot_s_store)
			return has_organ("chest")
		if(slot_wrist_r)
			return has_organ("r_hand")
		if(slot_wrist_l)
			return has_organ("l_hand")
		if(slot_amulet)
			return has_organ("head")
		if(slot_back2)
			return has_organ("chest")
		if(slot_in_backpack)
			return 1

/mob/living/carbon/human/u_equip(obj/item/W as obj)
	if(!W)	return 0

	var/success

	if (W == wear_suit)
		if(W)
			success = 1
		wear_suit = null
		update_inv_wear_suit()
	else if (W == w_uniform)
		if (r_store)
			drop_from_inventory(r_store)
		if (l_store)
			drop_from_inventory(l_store)
		if (belt)
			drop_from_inventory(belt)
		if(s_store)
			drop_from_inventory(s_store)
		w_uniform = null
		success = 1
		update_inv_w_uniform()
	else if (W == gloves)
		gloves = null
		success = 1
		update_inv_gloves()
	else if (W == glasses)
		glasses = null
		success = 1
		update_inv_glasses()
		handle_regular_hud_updates()
	else if (W == head)
		head = null
		if((W.flags & BLOCKHAIR) || (W.flags & BLOCKHEADHAIR))
			update_hair(0)	//rebuild hair
		success = 1
		update_inv_head()
		handle_regular_hud_updates()
	else if (W == l_ear)
		l_ear = null
		success = 1
		update_inv_ears()
	else if (W == r_ear)
		r_ear = null
		success = 1
		update_inv_ears()
	else if (W == shoes)
		shoes = null
		success = 1
		update_inv_shoes()
	else if (W == belt)
		belt = null
		success = 1
		update_inv_belt()
	else if (W == wear_mask)
		wear_mask = null
		success = 1
		if((W.flags & BLOCKHAIR) || (W.flags & BLOCKHEADHAIR))
			update_hair(0)	//rebuild hair
		if(internal)
			if(internals)
				internals.icon_state = "internal0"
			internal = null
		update_inv_wear_mask()
	else if (W == wear_id)
		wear_id = null
		success = 1
		update_inv_wear_id()
	else if (W == r_store)
		r_store = null
		success = 1
		update_inv_pockets()
	else if (W == l_store)
		l_store = null
		success = 1
		update_inv_pockets()
	else if (W == s_store)
		s_store = null
		success = 1
		update_inv_s_store()
	else if (W == wrist_r)
		wrist_r = null
		success = 1
		update_wrist_r()
	else if (W == amulet)
		amulet = null
		success = 1
		update_amulet()
	else if (W == wrist_l)
		wrist_l = null
		success = 1
		update_wrist_l()
	else if (W == back)
		back = null
		success = 1
		update_inv_back()
	else if (W == back2)
		back2 = null
		success = 1
		update_back2()
	else if (W == handcuffed)
		handcuffed = null
		success = 1
		update_inv_handcuffed()
	else if (W == legcuffed)
		legcuffed = null
		success = 1
		update_inv_legcuffed()
	else if (W == r_hand)
		r_hand = null
		success = 1
		update_inv_r_hand()
	else if (W == l_hand)
		l_hand = null
		success = 1
		update_inv_l_hand()
	else
		return 0

	if(success)
		if (W)
			if (client)
				client.screen -= W
			W.loc = loc
			W.dropped(src)
			if(W)
				W.layer = initial(W.layer)
				W.plane = initial(W.plane)
				W.appearance_flags = initial(W.appearance_flags)
	update_action_buttons()
	return 1



//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
//set redraw_mob to 0 if you don't wish the hud to be updated - if you're doing it manually in your own proc.
/mob/living/carbon/human/equip_to_slot(obj/item/W as obj, slot, redraw_mob = 1, delay=0)
	if(!slot) return
	if(!istype(W)) return
	if(!has_organ_for_slot(slot)) return
	if(istype(W, /obj/item/clothing/suit/armor/vest) && delay && !do_after(usr, 28)) return

	if(W == src.l_hand)
		src.l_hand = null
		update_inv_l_hand() //So items actually disappear from hands.
	else if(W == src.r_hand)
		src.r_hand = null
		update_inv_r_hand()

	W.loc = src
	switch(slot)
		if(slot_back)
			src.back = W
			W.equipped(src, slot)
			update_inv_back(redraw_mob)
		if(slot_wear_mask)
			src.wear_mask = W
			if((wear_mask.flags & BLOCKHAIR) || (wear_mask.flags & BLOCKHEADHAIR))
				update_hair(redraw_mob)	//rebuild hair
			W.equipped(src, slot)
			update_inv_wear_mask(redraw_mob)
		if(slot_handcuffed)
			src.handcuffed = W
			update_inv_handcuffed(redraw_mob)
		if(slot_legcuffed)
			src.legcuffed = W
			W.equipped(src, slot)
			update_inv_legcuffed(redraw_mob)
		if(slot_l_hand)
			src.l_hand = W
			W.equipped(src, slot)
			update_inv_l_hand(redraw_mob)
		if(slot_r_hand)
			src.r_hand = W
			W.equipped(src, slot)
			update_inv_r_hand(redraw_mob)
		if(slot_belt)
			src.belt = W
			W.equipped(src, slot)
			update_inv_belt(redraw_mob)
			if(W.equip_sound)
				playsound(src, W.equip_sound, 50, 1)
		if(slot_wear_id)
			src.wear_id = W
			W.equipped(src, slot)
			update_inv_wear_id(redraw_mob)
		if(slot_l_ear)
			src.l_ear = W
			if(l_ear.slot_flags & SLOT_TWOEARS)
				var/obj/item/clothing/ears/offear/O = new(W)
				O.loc = src
				src.r_ear = O
				O.layer = 20
				W.appearance_flags |= NO_CLIENT_COLOR
				O.plane = 30
			W.equipped(src, slot)
			update_inv_ears(redraw_mob)
		if(slot_r_ear)
			src.r_ear = W
			if(r_ear.slot_flags & SLOT_TWOEARS)
				var/obj/item/clothing/ears/offear/O = new(W)
				O.loc = src
				src.l_ear = O
				O.layer = 20
			W.equipped(src, slot)
			update_inv_ears(redraw_mob)
		if(slot_glasses)
			src.glasses = W
			W.equipped(src, slot)
			update_inv_glasses(redraw_mob)
			handle_regular_hud_updates()
		if(slot_gloves)
			src.gloves = W
			W.equipped(src, slot)
			update_inv_gloves(redraw_mob)
		if(slot_head)
			src.head = W
			if((head.flags & BLOCKHAIR) || (head.flags & BLOCKHEADHAIR))
				update_hair(redraw_mob)	//rebuild hair
			W.equipped(src, slot)
			handle_regular_hud_updates()
			update_inv_head(redraw_mob)
		if(slot_shoes)
			src.shoes = W
			W.equipped(src, slot)
			update_inv_shoes(redraw_mob)
		if(slot_wear_suit)
			src.wear_suit = W
			W.equipped(src, slot)
			update_inv_wear_suit(redraw_mob)
		if(slot_w_uniform)
			src.w_uniform = W
			if(istype(W,/obj/item/clothing/under/rank/migrant))
				W.update_icon(src)
			W.equipped(src, slot)
			update_inv_w_uniform(redraw_mob)
		if(slot_l_store)
			src.l_store = W
			W.equipped(src, slot)
			update_inv_pockets(redraw_mob)
		if(slot_r_store)
			src.r_store = W
			W.equipped(src, slot)
			update_inv_pockets(redraw_mob)
		if(slot_s_store)
			src.s_store = W
			W.equipped(src, slot)
			update_inv_s_store(redraw_mob)
			if(W.equip_sound)
				playsound(src, W.equip_sound, 50, 1)
		if(slot_wrist_r)
			src.wrist_r = W
			W.equipped(src, slot)
			update_wrist_r(redraw_mob)
		if(slot_back2)
			src.back2 = W
			W.equipped(src, slot)
			update_back2(redraw_mob)
		if(slot_amulet)
			src.amulet = W
			W.equipped(src, slot)
			update_amulet(redraw_mob)
		if(slot_wrist_l)
			src.wrist_l = W
			W.equipped(src, slot)
			update_wrist_l(redraw_mob)
		if(slot_in_backpack)
			if(src.get_active_hand() == W)
				src.u_equip(W)
			W.loc = src.back
		else
			src << "\red You are trying to eqip this item to an unsupported inventory slot. How the heck did you manage that? Stop it..."
			return

	if(hud_used)
		hud_used.add_inventory_overlay()
	update_inv_back(redraw_mob)
	W.layer = 20
	W.plane = 30
	W.appearance_flags |= NO_CLIENT_COLOR

	return

/obj/effect/equip_e
	name = "equip e"
	var/mob/source = null
	var/s_loc = null	//source location
	var/t_loc = null	//target location
	var/obj/item/item = null
	var/place = null

/obj/effect/equip_e/human/Destroy()
	. = ..()
	target.requests -= src
	source = null
	target = null
	item = null
	s_loc = null
	t_loc = null
	place = null

/obj/effect/equip_e/human
	name = "human"
	var/mob/living/carbon/human/target = null

/obj/effect/equip_e/monkey
	name = "monkey"
	var/mob/living/carbon/monkey/target = null

/obj/effect/equip_e/process()
	return

/obj/effect/equip_e/proc/done()
	return

/obj/effect/equip_e/New()
	. = ..()
	if (!ticker)
		qdel(src)
	spawn(100)
		qdel(src)

/obj/effect/equip_e/human/process()
	if (item)
		item.add_fingerprint(source)
	else
		switch(place)
			if("mask")
				if (!( target.wear_mask ))
					qdel(src)
			if("l_hand")
				if (!( target.l_hand ))
					qdel(src)
			if("r_hand")
				if (!( target.r_hand ))
					qdel(src)
			if("suit")
				if (!( target.wear_suit ))
					qdel(src)
			if("uniform")
				if (!( target.w_uniform ))
					qdel(src)
			if("back")
				if (!( target.back ))
					qdel(src)
			if("syringe")
				return
			if("pill")
				return
			if("fuel")
				return
			if("drink")
				return
			if("dnainjector")
				return
			if("handcuff")
				if (!( target.handcuffed ))
					qdel(src)
			if("id")
				if (!target.wear_id)
					qdel(src)
			if("splints")
				var/count = 0
				for(var/organ in list("l_leg","r_leg","l_arm","r_arm"))
					var/datum/organ/external/o = target.organs_by_name[organ]
					if(o.status & ORGAN_SPLINTED)
						count = 1
						break
				if(count == 0)
					qdel(src)
					return
			if("internal")
				if ((!( (istype(target.wear_mask, /obj/item/clothing/mask) && istype(target.back, /obj/item/tank) && !( target.internal )) ) && !( target.internal )))
					qdel(src)

	var/list/L = list( "syringe", "pill", "drink", "dnainjector", "fuel")
	if ((item && !( L.Find(place) )))
		if(isrobot(source) && place != "handcuff")
			qdel(src)
		for(var/mob/O in viewers(target, null))
			O.show_message("<span class='passivebold'>[source]</span> <span class='passive'>is trying to put \a </span><span class='passive'>[item]</span> <span class='passive'>on</span> <span class='passivebold'>[target]</span>", 1)
	else
		var/message=null
		switch(place)
			if("syringe")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to inject</span> <span class='combatbold'>[target]!</span>"
			if("pill")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to force</span> <span class='combatbold'>[target]</span> <span class='combat'>to swallow</span> <span class='combat'>[item]!</span>"
			if("drink")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to force</span> <span class='combatbold'>[target]</span> <span class='combat'>to swallow a gulp of</span> <span class='combat'>[item]!</span>"
			if("dnainjector")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to inject</span> <span class='combatbold'>[target]</span> <span class='combat'>with the</span> <span class='combat'>[item]!</span>"
			if("mask")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Had their mask removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) mask</font>")
				if(target.wear_mask && !target.wear_mask.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.wear_mask] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>head!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off \a [target.wear_mask] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>head!</span>"
			if("l_hand")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their left hand item ([target.l_hand]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) left hand item ([target.l_hand])</font>")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off \a [target.l_hand] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>left hand!</span>"
			if("r_hand")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their right hand item ([target.r_hand]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) right hand item ([target.r_hand])</font>")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off \a [target.r_hand] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>right hand!</span>"
			if("gloves")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their gloves ([target.gloves]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) gloves ([target.gloves])</font>")
				if(target.gloves && !target.gloves.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.gloves] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>hands!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.gloves] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>hands!</span>"
			if("eyes")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their eyewear ([target.glasses]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) eyewear ([target.glasses])</font>")
				if(target.glasses && !target.glasses.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.glasses] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>eyes!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.glasses] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>eyes!</span>"
			if("l_ear")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their left ear item ([target.l_ear]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) left ear item ([target.l_ear])</font>")
				if(target.l_ear && !target.l_ear.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.l_ear] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>left ear!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.l_ear] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>left ear!</span>"
			if("wrist_l")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their left wrist item ([target.wrist_l]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) left wrist item ([target.wrist_l])</font>")
				if(target.l_ear && !target.l_ear.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.wrist_l] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>left wrist!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.wrist_l] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>left wrist!</span>"
			if("wrist_r")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their right wrist item ([target.wrist_r]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) right wrist item ([target.wrist_r])</font>")
				if(target.l_ear && !target.l_ear.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.wrist_r] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>right wrist!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.wrist_r] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>right wrist!</span>"
			if("back2")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their right wrist item ([target.back2]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) right wrist item ([target.back2])</font>")
				if(target.back2 && !target.back2.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.back2] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>right wrist!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.back2] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>right wrist!</span>"
			if("amulet")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their amulet item ([target.amulet]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) amulet item ([target.amulet])</font>")
				if(target.l_ear && !target.l_ear.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.amulet] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>neck!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.wrist_r] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>right wrist!</span>"
			if("r_ear")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their right ear item ([target.r_ear]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) right ear item ([target.r_ear])</font>")
				if(target.r_ear && !target.r_ear.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.r_ear] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>right ear!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.r_ear] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>right ear!</span>"
			if("head")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their hat ([target.head]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) hat ([target.head])</font>")
				if(target.head && !target.head.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.head] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>d!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.head] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>head!</span>"
			if("shoes")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their shoes ([target.shoes]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) shoes ([target.shoes])</font>")
				if(target.shoes && !target.shoes.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.shoes] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>feet!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.shoes] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>feet!</span>"
			if("belt")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their belt item ([target.belt]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) belt item ([target.belt])</font>")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off the [target.belt] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>belt!</span>"
			if("suit")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their suit ([target.wear_suit]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) suit ([target.wear_suit])</font>")
				if(target.wear_suit && !target.wear_suit.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.wear_suit] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>body!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off \a [target.wear_suit] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>body!</span>"
			if("back")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their back item ([target.back]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) back item ([target.back])</font>")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off \a [target.back] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>back!</span>"
			if("handcuff")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Was unhandcuffed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to unhandcuff [target.name]'s ([target.ckey])</font>")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to unhandcuff</span> <span class='combatbold'>[target]</span><span class='combat'>!</span>"
			if("legcuff")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Was unlegcuffed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to unlegcuff [target.name]'s ([target.ckey])</font>")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to unlegcuff</span> <span class='combatbold'>[target]</span><span class='combat'>!</span>"
			if("uniform")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their uniform ([target.w_uniform]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) uniform ([target.w_uniform])</font>")
				for(var/obj/item/I in list(target.l_store, target.r_store))
					if(I.on_found(source))
						return
				if(target.w_uniform && !target.w_uniform.canremove)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>fails to take off \a [target.w_uniform] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>body!</span>"
					return
				else
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off \a [target.w_uniform] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>body!</span>"
			if("s_store")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their suit storage item ([target.s_store]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) suit storage item ([target.s_store])</font>")
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to take off \a [target.s_store] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>suit!</span>"
			if("pockets")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their pockets emptied by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to empty [target.name]'s ([target.ckey]) pockets</font>")
				for(var/obj/item/I in list(target.l_store, target.r_store))
					if(I.on_found(source))
						return
				message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to empty</span> <span class='combatbold'>[target]'s</span> <span class='combat'>pockets.</span>"
			if("CPR")
				if (!target.cpr_time)
					qdel(src)
				target.cpr_time = 0
				message = "<span class='passivebold'>[source]</span> <span class='passive'>is trying perform CPR on</span> <span class='passivebold'>[target]</span><span class='passive'>!</span>"
			if("id")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their ID ([target.wear_id]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) ID ([target.wear_id])</font>")
				message = "<span class='passivebold'>[source]</span> <span class='passive'>is trying to take off [target.wear_id] from</span> <span class='combatbold'>[target]'s</span> <span class='combat'>uniform!</span>"
			if("internal")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their internals toggled by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to toggle [target.name]'s ([target.ckey]) internals</font>")
				if (target.internal)
					message = "<span class='combatbold'>[source]</span> <span class='combat'>is trying to remove</span> <span class='combatbold'>[target]'s</span> <span class='combat'>internals</span>"
				else
					message = "<span class='passivebold'[source]</span> <span class='passive'>is trying to set on</span> <span class='passivebold'>[target]'s</span> <span class='passive'>internals.</span>"
			if("splints")
				message = text("<span class='combatbold'>[]</span> <span class='combat'>is trying to remove</span> <span class='combatbold'>[]'s</span> <span class='combat'>splints!</span>", source, target)

		for(var/mob/M in viewers(target, null))
			M.show_message(message, 1)
	spawn( HUMAN_STRIP_DELAY )
		done()
		return
	return

/*
This proc equips stuff (or does something else) when removing stuff manually from the character window when you click and drag.
It works in conjuction with the process() above.
This proc works for humans only. Aliens stripping humans and the like will all use this proc. Stripping monkeys or somesuch will use their version of this proc.
The first if statement for "mask" and such refers to items that are already equipped and un-equipping them.
The else statement is for equipping stuff to empty slots.
!canremove refers to variable of /obj/item/clothing which either allows or disallows that item to be removed.
It can still be worn/put on as normal.
*/
/obj/effect/equip_e/human/done()	//TODO: And rewrite this :< ~Carn
	target.cpr_time = 1
	if(isanimal(source)) return //animals cannot strip people
	if(!source || !target) return		//Target or source no longer exist
	if(source.loc != s_loc) return		//source has moved
	if(target.loc != t_loc) return		//target has moved
	if(LinkBlocked(s_loc,t_loc)) return	//Use a proxi!
	if(item && source.get_active_hand() != item) return	//Swapped hands / removed item from the active one
	if ((source.restrained() || source.stat)) return //Source restrained or unconscious / dead

	var/slot_to_process
	var/strip_item //this will tell us which item we will be stripping - if any.

	switch(place)	//here we go again...
		if("mask")
			slot_to_process = slot_wear_mask
			if (target.wear_mask && target.wear_mask.canremove)
				strip_item = target.wear_mask
		if("gloves")
			slot_to_process = slot_gloves
			if (target.gloves && target.gloves.canremove)
				strip_item = target.gloves
		if("eyes")
			slot_to_process = slot_glasses
			if (target.glasses)
				strip_item = target.glasses
		if("belt")
			slot_to_process = slot_belt
			if (target.belt)
				strip_item = target.belt
		if("s_store")
			slot_to_process = slot_s_store
			if (target.s_store)
				strip_item = target.s_store
		if("wrist_r")
			slot_to_process = slot_wrist_r
			if (target.wrist_r)
				strip_item = target.wrist_r
		if("amulet")
			slot_to_process = slot_amulet
			if (target.amulet)
				strip_item = target.amulet
		if("back2")
			slot_to_process = slot_back2
			if (target.back2)
				strip_item = target.back2
		if("wrist_l")
			slot_to_process = slot_wrist_l
			if (target.wrist_l)
				strip_item = target.wrist_l
		if("head")
			slot_to_process = slot_head
			if (target.head && target.head.canremove)
				strip_item = target.head
		if("l_ear")
			slot_to_process = slot_l_ear
			if (target.l_ear)
				strip_item = target.l_ear
		if("r_ear")
			slot_to_process = slot_r_ear
			if (target.r_ear)
				strip_item = target.r_ear
		if("shoes")
			slot_to_process = slot_shoes
			if (target.shoes && target.shoes.canremove)
				strip_item = target.shoes
		if("l_hand")
			if (istype(target, /obj/item/clothing/suit/straight_jacket))
				qdel(src)
			slot_to_process = slot_l_hand
			if (target.l_hand)
				strip_item = target.l_hand
		if("r_hand")
			if (istype(target, /obj/item/clothing/suit/straight_jacket))
				qdel(src)
			slot_to_process = slot_r_hand
			if (target.r_hand)
				strip_item = target.r_hand
		if("uniform")
			slot_to_process = slot_w_uniform
			if(target.w_uniform && target.w_uniform.canremove)
				strip_item = target.w_uniform
		if("suit")
			slot_to_process = slot_wear_suit
			if (target.wear_suit && target.wear_suit.canremove)
				strip_item = target.wear_suit
		if("id")
			slot_to_process = slot_wear_id
			if (target.wear_id)
				strip_item = target.wear_id
		if("back")
			slot_to_process = slot_back
			if (target.back)
				strip_item = target.back
		if("handcuff")
			slot_to_process = slot_handcuffed
			if (target.handcuffed)
				strip_item = target.handcuffed
		if("legcuff")
			slot_to_process = slot_legcuffed
			if (target.legcuffed)
				strip_item = target.legcuffed
		if("splints")
			for(var/organ in list("l_leg","r_leg","l_arm","r_arm"))
				var/datum/organ/external/o = target.get_organ(organ)
				if (o && o.status & ORGAN_SPLINTED)
					var/obj/item/W = new /obj/item/stack/medical/splint(amount=1)
					o.status &= ~ORGAN_SPLINTED
					if (W)
						W.loc = target.loc
						W.layer = initial(W.layer)
						W.plane = initial(W.plane)
						W.appearance_flags = initial(W.appearance_flags)
						W.add_fingerprint(source)
		if("CPR")
			if (target.death_door)
				if(ishuman(source))
					var/mob/living/carbon/human/H = source
					var/list/roll_result = roll3d6(H, SKILL_MEDIC, 0)
					switch(roll_result[GP_RESULT])
						if(GP_CRITSUCCESS)
							target.adjustOxyLoss(target.getOxyLoss())
							target.updatehealth()
							target.undrown()
							var/datum/organ/internal/heart/HE = locate() in target.internal_organs
							source.visible_message("<span class='passivebold'>[source]</span> <span class='passive'>performs CPR on [target]!</span>", 1)
							if(HE)
								HE.stopped_working = FALSE
								target.death_door = 0
								target.sleeping = 5
								target.visible_message("<color green><b>[target]</b> spasms briefly for air!</color>")
								target.emote("gasp",1,null,0)
								if(HE.damage < HE.min_bruised_damage)
									HE.damage -= 1
							if(HE && target.stat == 2)
								if(target.pulse == PULSE_NONE && !HE.stopped_working && HE.damage < HE.min_bruised_damage)
									target.pulse = PULSE_SLOW
									target.stat = 1
						if(GP_SUCCESS)
							var/suff = min(target.getOxyLoss(), rand(12,20)) //Pre-merge level, less healing, more prevention of dieing.
							target.adjustOxyLoss(-suff)
							target.updatehealth()
							target.undrown()
							var/datum/organ/internal/heart/HE = locate() in target.internal_organs
							if(prob(35))
								if(HE)
									HE.stopped_working = FALSE
									target.death_door = 0
									target.sleeping = 5
									source.visible_message("<span class='passivebold'>[source]</span> <span class='passive'>performs CPR on [target]!</span>", 1)
									target.visible_message("<color green><b>[target]</b> spasms briefly for air!</color>")
									target.emote("gasp",1,null,0)
									if(HE.damage < HE.min_bruised_damage)
										HE.damage -= 1
							if(prob(25))
								if(HE && target.stat == 2)
									if(target.pulse == PULSE_NONE && !HE.stopped_working && HE.damage < HE.min_bruised_damage)
										target.pulse = PULSE_SLOW
										target.stat = 1
							source.visible_message("<span class='passivebold'>[source]</span> <span class='passive'>performs CPR on [target]!</span>", 1)
							to_chat(target, "<span class='passive'>You feel a breath of fresh air enter your lungs.</span>")
						if(GP_FAIL)
							source.visible_message("<span class='combatbold'>[source]</span> <span class='combat'>performs CPR poorly on [target]!</span>", 1)
						if(GP_CRITFAIL)
							source.visible_message("<span class='combatbold'>[source]</span> <span class='combat'>performs CPR poorly on [target]!</span>", 1)
				else
					var/suff = min(target.getOxyLoss(), rand(12,20)) //Pre-merge level, less healing, more prevention of dieing.
					target.adjustOxyLoss(-suff)
					target.updatehealth()
					var/datum/organ/internal/heart/HE = locate() in target.internal_organs
					if(prob(35))
						if(HE)
							HE.stopped_working = FALSE
							target.death_door = 0
							target.sleeping = 5
							target.visible_message("<color green><b>[target]</b> spasms briefly for air!</color>")
							target.emote("gasp",1,null,0)
							if(HE.damage < HE.min_bruised_damage)
								HE.damage -= 1
					if(prob(25))
						if(HE && target.stat == 2)
							if(target.pulse == PULSE_NONE && !HE.stopped_working && HE.damage < HE.min_bruised_damage)
								target.pulse = PULSE_SLOW
								target.stat = 1
					for(var/mob/O in viewers(source, null))
						O.visible_message("<span class='passivebold'>[source]</span> <span class='passive'>performs CPR on [target]!</span>", 1)
					to_chat(target, "<span class='passive'>You feel a breath of fresh air enter your lungs.</span>")

				// source << "\red Repeat at least every 7 seconds."
		if("dnainjector")
			var/obj/item/dnainjector/S = item
			if(S)
				S.add_fingerprint(source)
				if (!( istype(S, /obj/item/dnainjector) ))
					S.inuse = 0
					qdel(src)
				S.inject(target, source)
				if (S.s_time >= world.time + 30)
					S.inuse = 0
					qdel(src)
				S.s_time = world.time
				for(var/mob/O in viewers(source, null))
					O.show_message("\red [source] injects [target] with the DNA Injector!", 1)
				S.inuse = 0
		if("pockets")
			slot_to_process = slot_l_store
			strip_item = target.l_store		//We'll do both
		if("internal")
			if (target.internal)
				target.internal.add_fingerprint(source)
				target.internal = null
				if (target.internals)
					target.internals.icon_state = "internal0"
			else
				if (!( istype(target.wear_mask, /obj/item/clothing/mask) ))
					return
				else
					if (istype(target.back, /obj/item/tank))
						target.internal = target.back
					else if (istype(target.s_store, /obj/item/tank))
						target.internal = target.s_store
					else if (istype(target.belt, /obj/item/tank))
						target.internal = target.belt
					if (target.internal)
						for(var/mob/M in viewers(target, 1))
							M.show_message("[target] is now running on internals.", 1)
						target.internal.add_fingerprint(source)
						if (target.internals)
							target.internals.icon_state = "internal1"
	if(slot_to_process)
		if(strip_item) //Stripping an item from the mob
			var/obj/item/W = strip_item
			target.u_equip(W)
			if (target.client)
				target.client.screen -= W
			if (W)
				W.loc = target.loc
				W.layer = initial(W.layer)
				W.plane = initial(W.plane)
				W.appearance_flags = initial(W.appearance_flags)
				W.dropped(target)
			W.add_fingerprint(source)
			if(slot_to_process == slot_l_store) //pockets! Needs to process the other one too. Snowflake code, wooo! It's not like anyone will rewrite this anytime soon. If I'm wrong then... CONGRATULATIONS! ;)
				if(target.r_store)
					target.u_equip(target.r_store) //At this stage l_store is already processed by the code above, we only need to process r_store.
		else
			if(item && target.has_organ_for_slot(slot_to_process)) //Placing an item on the mob
				if(item.mob_can_equip(target, slot_to_process, 0))
					source.u_equip(item)
					target.equip_to_slot_if_possible(item, slot_to_process, 0, 1, 1)
					item.dropped(source)
					source.update_icons()
					target.update_icons()

	if(source && target)
		if(source.machine == target)
			target.show_inv(source)
	qdel(src)

// Return the item currently in the slot ID
/mob/living/carbon/human/get_item_by_slot(slot_id)
	switch(slot_id)
		if(slot_back)
			return back
		if(slot_wear_mask)
			return wear_mask
		if(slot_handcuffed)
			return handcuffed
		if(slot_legcuffed)
			return legcuffed
		if(slot_l_hand)
			return l_hand
		if(slot_r_hand)
			return r_hand
		if(slot_belt)
			return belt
		if(slot_wear_id)
			return wear_id
		if(slot_r_ear)
			return r_ear
		if(slot_l_ear)
			return l_ear
		if(slot_glasses)
			return glasses
		if(slot_gloves)
			return gloves
		if(slot_head)
			return head
		if(slot_shoes)
			return shoes
		if(slot_wear_suit)
			return wear_suit
		if(slot_w_uniform)
			return w_uniform
		if(slot_l_store)
			return l_store
		if(slot_r_store)
			return r_store
		if(slot_s_store)
			return s_store
		if(slot_wrist_r)
			return wrist_r
		if(slot_amulet)
			return amulet
		if(slot_wrist_l)
			return wrist_l
		if(slot_back2)
			return back2
	return null
