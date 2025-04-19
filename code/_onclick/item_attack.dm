
// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	return

// No comment
/atom/proc/attackby(obj/item/W, mob/user)
	return
/atom/movable/attackby(obj/item/W, mob/user)
	if(!(W.flags&NOBLUDGEON))
		visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")

/mob/living/attackby(obj/item/I, mob/user)
	if(istype(I) && ismob(user))
		I.attack(src, user)

/obj/structure/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	..()

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return


/obj/item/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag)//This is only for far reaching weapons.
		return
	if(item_reach > 1)
		if(get_dist(user, target) <= item_reach)//See if they're reachable
			if(is_physically_reachable(user, target))//Try to reach them.
				target.attackby(src, user)//We can reach them, now we attack them.

/proc/is_physically_reachable(atom/A, atom/B)
	var/turf/T = get_turf(A)
	var/turf/bT = get_turf(B)
	var/tdir = get_dir(T, B)
	while ((T = get_step(T, tdir)) && T != bT)
		if (T.density)
			return FALSE

		if ((tdir & (NORTH|SOUTH)) && (tdir & (EAST|WEST)))
			// diagonal
			var/turf/tempT = get_step(T, turn(tdir, 45))
			if (tempT?.density)
				return FALSE
			tempT = get_step(T, turn(tdir, -45))
			if (tempT?.density)
				return FALSE

		tdir = get_dir(T, B)

	return TRUE

/obj/item/proc/attack(mob/living/M, mob/living/user, def_zone, var/special = FALSE)
	var/wait = 3
	var/offhand_attack = FALSE
	if(!istype(M)) // not sure if this is the right thing...
		return
	if(dedick(M, user))
		return

	if(can_operate(M))        //Checks if mob is lying down on table for surgery
		if (do_surgery(M,user,src))
			return

	if(world.time <= next_attack_time)
		if(world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>The [src] is not ready to attack again!</span>")
		return 0

	if(!user.combat_mode)
		special = FALSE

	if(!special)
		apply_speed_delay(0, user)

	if(special)//We did a special attack, let's apply it's special properties.
		if(user.combat_intent == I_FURY)//Faster attack but takes much more stamina.
			//user.visible_message("<span class='combat'>[user] performs a furious attack!</span>")
			user.adjustStaminaLoss(w_class + 6)
			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			apply_speed_delay(-5, user)

		else if(user.combat_intent == I_AIMED)//More accurate attack
			//user.visible_message("<span class='combat'>[user] performs an aimed attack!</span>")
			user.adjustStaminaLoss(w_class + 5)
			user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
			apply_speed_delay(5, user)

		else if(user.combat_intent == I_FEINT)//Feint attack that leaves them unable to attack for a few seconds
			var/list/roll = roll3d6(user, SKILL_MELEE, specialty_check(user, src))//Roll a skill check here, only the most skilled can use feinting, obviously.
			var/result = roll[GP_RESULT]
			var/success = TRUE
			switch(result)
				if(GP_FAIL)
					success = FALSE
				if(GP_CRITFAIL)
					success = FALSE
				else
					success = TRUE
			if(!success)//Failed your melee roll, no success for you.
				user.visible_message("<span class='combat'>[user] botches a feint attack!</span>")
				return 0

			user.adjustStaminaLoss(w_class + 5)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			M.setClickCooldown(20)//Longer than a slow attack cooldown. You got feinted on you gon die.
			M.Stun(1)
			apply_speed_delay(0, user)
			user.visible_message("<span class='combat'>[user] performs a successful feint attack!</span>")
			if(M.combat_intent == I_DEFEND)
				if(M.combat_mode)
					M.item_disarm()
			return 0 //We fiented them don't actaully hit them now, we can follow up with another attack.

		else if(user.combat_intent == I_STRONG)//Attack with stronger damage at the cost slightly longer cooldown
			//user.visible_message("<span class='combat'>[user] performs a heavy attack!</span>")
			user.adjustStaminaLoss(w_class + 5)
			user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
			apply_speed_delay(6, user)

		else if(user.combat_intent == I_WEAK)
			//user.visible_message("<span class='combat'>[user] performs a weak attack.</span>")
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			apply_speed_delay(0, user)

		else if(user.combat_intent == I_DUAL)
			//user.visible_message("<span class='combat'>[user] attacks with their offhand!</span>")
			offhand_attack = TRUE
			apply_speed_delay(3, user)
		else
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			apply_speed_delay(0, user)

	if(!special)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
	log_attack("<font color='red'>[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>" )

	//spawn(1800)            // this wont work right
	//	M.lastattacker = null
	/////////////////////////

	var/power = force
	if(HULK in user.mutations)
		power *= 2

	wait += w_class
	if(force)
		user.adjustStaminaLoss(wait)

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(offhand_attack)//We're attacking with our offhand then.
			if(istype(user.get_inactive_hand(), /obj/item))
				var/obj/item/I = user.get_inactive_hand()
				I.attack(src, user)//No special flag here, you can only do standard attacks with your offhand.
				return
		else
			return H.attacked_by(src, user, def_zone, special)
	else
		switch(damtype)
			if("brute")

				M.take_organ_damage(power)
				if (prob(33)) // Added blood for whacking non-humans too
					var/turf/location = M.loc
					if (istype(location, /turf/simulated))
						location:add_blood_floor(M)
			if("fire")
				if (!(COLD_RESISTANCE in M.mutations))
					M.take_organ_damage(0, power)
					M << "Aargh it burns!"
		M.updatehealth()

	if (force && hitsound)//We want to make sure the hit actually goes through before we play any sounds.
		playsound(M, hitsound, 50, 1, -1)

	add_fingerprint(user)
	return 1

//by default, that's 25 - 10. Which is 15. Which should be what the average attack is. People who are weaker will swing heavy objects slower.
//The "delay" arg is for adding a greater or lesser delay from special attacks.
/obj/item/proc/apply_speed_delay(delay, mob/user)
	if(user.wrong_hand_used)
		delay += 2
	next_attack_time = world.time + (weapon_speed_delay + delay)


/atom/proc/storage_depth(atom/container) // Hi
	var/depth = 0
	var/atom/cur_atom = src

	while (cur_atom && !(cur_atom in container.contents))
		if (isarea(cur_atom))
			return -1
		if (istype(cur_atom.loc, /obj/item/storage))
			if(!istype(cur_atom.loc, /obj/item/storage/touchable))
				depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return -1	//inside something with a null loc.
	return depth

//Like storage depth, but returns the depth to the nearest turf
//Returns -1 if no top level turf (a loc was null somewhere, or a non-turf atom's loc was an area somehow).
/atom/proc/storage_depth_turf()
	var/depth = 0
	var/atom/cur_atom = src

	while (cur_atom && !isturf(cur_atom))
		if (isarea(cur_atom))
			return -1
		if (istype(cur_atom.loc, /obj/item/storage))
			if(!istype(cur_atom.loc, /obj/item/storage/touchable))
				depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return -1	//inside something with a null loc.
	return depth