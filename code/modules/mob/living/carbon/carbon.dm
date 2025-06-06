/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != 2)
			src.nutrition -= HUNGER_FACTOR/20
			if(src.m_intent == "run")
				src.nutrition -= HUNGER_FACTOR/15
		if(src.hydration && src.stat != 2)
			src.hydration -= THIRST_FACTOR/20
			if(src.m_intent == "run")
				src.hydration -= THIRST_FACTOR/15
		if(hasalpha)
			var/turf/T = NewLoc
			if(T.get_lumcount() <= 0.2)
				alpha = 70
				hasalpha = 1
			else
				alpha = 255
				hasalpha = 0

/mob/living/carbon/relaymove(var/mob/user, direction)
	return

/mob/living/carbon/gib()
	. = ..()

/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return
	if (hasorgans(M))
		var/datum/organ/external/temp = M:organs_by_name["r_hand"]
		if (M.hand)
			temp = M:organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(M, "\red You can't use your [temp.display_name]")
			return

	for(var/datum/disease/D in viruses)

		if(D.spread_by_touch())

			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)

		if(D.spread_by_touch())

			contract_disease(D, 0, 1, CONTACT_HANDS)

	return


/mob/living/carbon/attack_paw(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return

	for(var/datum/disease/D in viruses)

		if(D.spread_by_touch())
			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)

		if(D.spread_by_touch())
			contract_disease(D, 0, 1, CONTACT_HANDS)

	return

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	if(status_flags & GODMODE)	return 0	//godmode
	if(mShock in src.mutations) //shockproof
		return 0
	shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0



	src.take_overall_damage(0,shock_damage,used_weapon="Electrocution")
	src.visible_message(
		"<span class='combatbold'>[src]</span><span class='combat'> was shocked by the</span><span class='combatbold'> [source]!</span>"
	)
	if(!istype(src?.species, /datum/species/human/alien) && !ismonster(src))
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			var/stun_time = max(0, 13 - H.my_stats.get_stat(STAT_HT))
			Stun(stun_time)//This should work for now, more is really silly and makes you lay there forever
			if(!H.my_stats.get_stat(STAT_HT)>=12)
				Weaken(1)
	return shock_damage


/mob/living/carbon/proc/swap_hand()
	src.hand = !( src.hand )
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "hand_active"
			hud_used.r_hand_hud_object.icon_state = "hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "hand_active"
	if(hud_used.swaphands_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.swaphands_hud_object.dir = 2
		else
			hud_used.swaphands_hud_object.dir = 1
	if(hand)
		a_intent_change(left_hand_intent)
		zone_sel.selecting = left_hand_zone
		zone_sel.update_icon()
	else
		a_intent_change(right_hand_intent)
		zone_sel.selecting = right_hand_zone
		zone_sel.update_icon()
	update_handedness()
	return

/mob/living/carbon/proc/activate_hand(var/selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if(M == src)
		return
	if (src.health >= config.health_threshold_crit)
		if (istype(src,/mob/living/carbon/human) && src:w_uniform)
			var/mob/living/carbon/human/H = src
			H.w_uniform.add_fingerprint(M)
		src.sleeping = max(0,src.sleeping-5)
		if(src.sleeping == 0)
			if(src.can_stand)
				src.SetResting(FALSE)
		AdjustParalysis(-2)
		AdjustStunned(-2)
		AdjustWeakened(-3)
		playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		M.visible_message( \
			"<span class='passive'>[M] shakes [src]!</span>", \
			)

/mob/living/carbon/proc/eyecheck()
	return 0

/mob/living/carbon/proc/getDNA()
	return dna

/mob/living/carbon/proc/setDNA(var/datum/dna/newDNA)
	dna = newDNA

/mob/living/carbon/clean_blood()
	. = ..()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.gloves)
			if(H.gloves.clean_blood())
				H.update_inv_gloves(0)
			H.gloves.germ_level = 0
		else
			if(H.bloody_hands)
				H.bloody_hands = 0
				H.update_inv_gloves(0)
			H.germ_level = 0
	update_icons()	//apply the now updated overlays to the mob


//Throwing stuff

/mob/living/carbon/proc/toggle_throw_mode()
	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/living/carbon/verb/glind()
	var/newloc = get_step(src,src.dir)
	if(src.a_intent == "hurt" && !glindcooldown)
		if(grabbed_by.len)
			for(var/x = 1; x <= grabbed_by.len; x++)
				if(grabbed_by[x])
					var/turf/back = get_step(src, reverse_dir[dir])
					var/obj/item/I = src.get_active_hand()

					for(var/mob/living/L in back.contents)
						I.attack(L, src)
						glindcooldown = TRUE
						spawn(10)
							glindcooldown = FALSE
					return
		for(var/mob/living/L in newloc)
			if(istype(src.get_active_hand(), /obj/item) && src.a_intent == "hurt")
				var/obj/item/I = src.get_active_hand()
				I.attack(L, src)
				glindcooldown = TRUE
				spawn(10)
					glindcooldown = FALSE
				return

		var/obj/item/I = src.get_active_hand()
		if(I && src.a_intent == "hurt")
			src.visible_message("<span class='hitbold'>[src]</span> <span class='hit'>swings</span> <span class='hitbold'>[I]!</span>")
			playsound(src, 'sound/weapons/2hswing.ogg', 50, 1)
			glindcooldown = TRUE
			var/turf/T = get_step(src, src.dir)
			if(T.density && T.flammable && istype(I, /obj/item/flame))
				var/obj/item/flame/F = I
				if(F.lit)
					animate(src, pixel_x=(T.x-src.x)*10, pixel_y=(T.y-src.y)*10, time = 5)
					if(prob(40))
						new/obj/structure/fire(T)
			spawn(9)
				glindcooldown = FALSE
	if(src.a_intent == "help" && !glindcooldown)
		var/turf/turfloc = get_step(src,src.dir)
		var/obj/objloc = get_step(src, src.dir)
		var/image/hide = image('icons/blind.dmi', turfloc)
		var/image/hide2 = image('icons/blind.dmi', objloc)
		hide.icon = 'icons/blind.dmi'
		hide2.icon = 'icons/blind.dmi'
		hide.appearance_flags = NO_CLIENT_COLOR|RESET_ALPHA
		hide.plane = 50
		hide.layer = HUD_ABOVE_ITEM_LAYER
		hide2.appearance_flags = NO_CLIENT_COLOR|RESET_ALPHA
		hide2.plane = 50
		hide2.layer = HUD_ABOVE_ITEM_LAYER
		glindcooldown = TRUE
		spawn(8)
			glindcooldown = FALSE
		src.visible_message("<span class='bname'>[src]</span> checks for \his surroundings.</span>")
		if(istype(turfloc, /turf/simulated/wall))
			hide.icon_state = pick("wall","wall2")
		else if(istype(turfloc, /turf/simulated/floor))
			hide.icon_state = pick("floor","floor1","floor2","floor3","floor4","floor5","floor6","floor7","floor8","floor9","floor10","floor11")
		if(objloc)
			for(var/obj/O in objloc)
				if(O in objloc)
					hide2.icon_state = "?"
					if(istype(O, /obj/structure/rack/lwtable))
						hide2.icon_state = "table"
					if(istype(O, /obj/structure/closet))
						hide2.icon_state = "closet"
					if(istype(O, /obj/structure/closet/crate))
						hide2.icon_state = "chest"
					if(istype(O, /obj/structure/lifeweb/statue))
						hide2.icon_state = "statue"
					if(istype(O, /obj/structure/lifeweb/mushroom))
						hide2.icon_state = "mushroom"
					if(istype(O, /obj/structure/stool/bed))
						hide2.icon_state = "bed"
					if(istype(O, /obj/structure/stool/bed/chair))
						hide2.icon_state = "chair"
		for(var/mob/living/M in turfloc)
			if(M.lying)
				hide2.icon_state = "corpse"
		src.client.images += hide
		src.client.images += hide2
		spawn(15)
			src.client.images -= hide
			src.client.images -= hide2
/mob/living/carbon/proc/throw_mode_off()
	src.in_throw_mode = 0
	src.throw_icon.icon_state = "act_throw_off"

/mob/living/carbon/proc/throw_mode_on()
	src.in_throw_mode = 1
	src.throw_icon.icon_state = "act_throw_on"

/mob/proc/throw_item(atom/target)
	return

proc/strToSpeedModifier(var/strength, var/w_class)//Looks messy. Is messy. Is also only used once. But I don't give a fuuuuuuuuck.
	switch(strength)
		if(1 to 5)
			if(w_class > 3)
				return 20

		if(6 to 11)
			if(w_class > 3)
				return 15

		if(12 to 15)
			if(w_class > 3)
				return 10

		if(16 to INFINITY)
			if(w_class > 3)
				return 5

/mob/living/carbon/throw_item(atom/target)
	src.throw_mode_off()
	if(usr.stat || !target)
		return
	if(target.type == /obj/screen) return

	var/atom/movable/item = src.get_active_hand()
	var/weight_class = 3

	if(!item) return

	if(istype(item,/obj/item))//If it's an item set the weight_class to the item's w_class
		var/obj/item/I = item
		weight_class = I.w_class

	var/throw_delay = strToSpeedModifier(src?.my_stats?.get_stat(STAT_ST), weight_class)

	src.visible_message("<span class='hitbold'>[src]</span> <span class='hit'>is trying to throw [item].</span>")

	if(do_after(src, throw_delay))
		if (istype(item, /obj/item/grab))
			var/obj/item/grab/G = item
			item = G.throw_mob() //throw the person instead of the grab
			if(ismob(item))
				var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
				var/turf/end_T = get_turf(target)
				src.adjustStaminaLoss(rand(15,20))
				if(start_T && end_T)
					var/mob/M = item
					var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
					var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

					M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been thrown by [usr.name] ([usr.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>")
					usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>")
					msg_admin_attack("[usr.name] ([usr.ckey]) has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor] (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
					if(ishuman(usr))
						var/mob/living/carbon/human/H = usr
						H.adjustStaminaLoss(rand(10,30))

					qdel(G)//No more spaming throw over and over and over again thank you.

		if (istype(item, /obj/item/mob_holder))
			var/obj/item/mob_holder/G = item
			item = G?.held_mob
			if(ismob(item))
				G.held_mob = null
				qdel(G)//No more spaming throw over and over and over again thank you.

		if(!item) return //Grab processing has a chance of returning null

		item.layer = initial(item.layer)
		item.plane = initial(item.plane)
		u_equip(item)
		update_icons()

		if(istype(item, /obj/item/flame/candle/tnt))
			var/obj/item/flame/candle/tnt/T = item
			if(T.lit)
				playsound(src, 'sound/effects/tnt_throw_lit.ogg', 50, 1)
		else
			playsound(src, 'sound/effects/throw.ogg', 50, 1)

		if (istype(usr, /mob/living/carbon)) //Check if a carbon mob is throwing. Modify/remove this line as required.
			item.loc = src.loc
			if(src.client)
				src.client.screen -= item
			if(istype(item, /obj/item))
				item:dropped(src) // let it know it's been dropped

		//actually throw it!
		//actually throw it!
		if(item)
			item.layer = initial(item.layer)
			item.plane = initial(item.plane)
			src.visible_message("<span class='hitbold'>[src]</span> <span class='hit'>has thrown [item].</span>")
			if(src.looking_up)
				item.z = src.z+1
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T)
				var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
				var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

				usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Has thrown [item] from [start_T_descriptor] with the target [end_T_descriptor]</font>")
				log_attack("<font color='red'>[usr]([usr.key]) has thrown [item] from [start_T_descriptor] with the target [end_T_descriptor]</font>")

			if(!src.lastarea)
				src.lastarea = get_area(src.loc)

			newtonian_move(get_dir(target, src))

			item.throw_at(target, item.throw_range, item.throw_speed, src)

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	bodytemperature = max(bodytemperature, BODYTEMP_HEAT_DAMAGE_LIMIT+10)

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/stool/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if (handcuffed)
		return 1
	return

/mob/living/carbon/u_equip(obj/item/W as obj)
	if(!W)	return 0

	else if (W == handcuffed)
		handcuffed = null
		update_inv_handcuffed()

	else if (W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	else
	 ..()

	return

/mob/living/carbon/show_inv(mob/living/carbon/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='byond://?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='byond://?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='byond://?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='byond://?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !( internal )) ? text(" <A href='byond://?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(handcuffed ? text("<A href='byond://?src=\ref[src];item=handcuff'>Handcuffed</A>") : text("<A href='byond://?src=\ref[src];item=handcuff'>Not Handcuffed</A>"))]
	<BR>[(internal ? text("<A href='byond://?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='byond://?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='byond://?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='byond://?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[name]")
	return

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for machines, more accurate
	var/temp = 0								//see setup.dm:694
	switch(src.pulse)
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_NORM)
			temp = rand(60, 90)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_FAST)
			temp = rand(90, 120)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_2FAST)
			temp = rand(120, 160)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
//			output for machines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/getTrail()
	if(getBruteLoss() < 100)
		return "ltrails"
	else
		return "trails"

var/const/NO_SLIP_WHEN_WALKING = 1
var/const/STEP = 2
var/const/SLIDE = 4
var/const/GALOSHES_DONT_HELP = 8

/mob/living/carbon/slip(slipped_on, stun_duration = 8)
	if(buckled)
		return FALSE
	stop_pulling()
	playsound(loc, 'sound/misc/slip.ogg', 50, 1, -3)
	//Weaken(Floor(stun_duration/2))
	return TRUE

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"
	var/mob/living/carbon/human/H = src

	if(H.sleeping || H.tryingtosleep)
		H.tryingtosleep = FALSE
		H.handle_regular_hud_updates()
	else
		if(ishuman(H))
			if(H.feel_pain_check() && (get_pain() > (70 + H.my_stats.get_stat(STAT_HT)*3)) )
				to_chat(H, "<span class='combatbold'>[pick(fnord)]</span><span class='combat'> I can't sleep while... IN PAIN!</span>")
				return
			var/cansleep = TRUE
			if(istype(H.wear_suit, /obj/item/clothing/suit/armor))
				cansleep = FALSE
			if(istype(H.head, /obj/item/clothing/head/helmet))
				cansleep = FALSE
			if(istype(H.amulet, /obj/item/clothing/head/amulet/gorget))
				cansleep = FALSE
			if(istype(H.gloves, /obj/item/clothing/gloves/combat))
				cansleep = FALSE
			if(!cansleep)
				to_chat(H, "<span class='combatbold'>[pick(fnord)]</span><span class='combat'> I can't sleep while wearing armor!</span>")
				return
		H.tryingtosleep = TRUE
		H.sleeping = 6
		H.eye_closed = 1

/mob/living/carbon/human/verb/toggle_eye()
	var/obj/item/clothing/head/blackbag/B = head //Head location
	if(B) return //This is a dirty hack but it stops exploits. I'll fix it proper later. Or I won't. Fuck you. I do what I want.
	var/obj/item/clothing/glasses/sunglasses/blindfold/blind = glasses
	if(blind) return //Same thing for blindfolds. Fuck this gay earth.
	if(eye_closed == FALSE)
		if(gender == FEMALE)
			emote("closes her eyes.")
		else
			emote("closes his eyes.")
		eye_closed = TRUE
	else
		if(gender == FEMALE)
			emote("opens her eyes.")
		else
			emote("opens his eyes.")
		eye_closed = FALSE
	handle_regular_hud_updates()
	update_body() //regenerate_icons() is expensive.


/mob/living/carbon/fall(var/forced)
    loc.handle_fall(src, forced)//it's loc so it doesn't call the mob's handle_fall which does nothing

/mob/living/carbon/get_item_by_slot(slot_id)
	. = ..()

/mob/living/carbon/proc/update_handedness()
	if(dom_hand == AMBIDEXTROUS)//Don't bother checking the rest of this shit if we're ambidextrous.
		wrong_hand_used = FALSE
		return
	if(hand)	//This being 1 means the left hand is in use
		if(dom_hand == RIGHT_HAND)
			wrong_hand_used = TRUE
		else
			wrong_hand_used = FALSE
	else
		if(dom_hand == LEFT_HAND)
			wrong_hand_used = TRUE
		else
			wrong_hand_used = FALSE
