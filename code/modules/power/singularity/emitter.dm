//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/machinery/power/emitter
	name = "Emitter"
	desc = "A heavy duty industrial laser"
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	anchored = 0
	density = 1
	req_access = list(access_engine_equip)

	use_power = 0
	idle_power_usage = 10
	active_power_usage = 300

	var/active = 0
	var/powered = 0
	var/fire_delay = 100
	var/last_shot = 0
	var/shot_number = 0
	var/state = 0
	var/locked = 0
	New()
		..()
		init_obj.Add(src)

/obj/machinery/power/emitter/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		usr << "It is fastened to the floor!"
		return 0
	src.dir = turn(src.dir, 90)
	return 1

/obj/machinery/power/emitter/initialize()
	..()
	if(state == 2 && anchored)
		connect_to_network()
		src.directwired = 1

/obj/machinery/power/emitter/Destroy()
	message_admins("Emitter deleted at ([x],[y],[z] - <A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("Emitter deleted at ([x],[y],[z])")
	investigate_log("<font color='red'>deleted</font> at ([x],[y],[z])","singulo")
	..()

/obj/machinery/power/emitter/update_icon()
	if (active && powernet && avail(active_power_usage))
		icon_state = "emitter_+a"
	else
		icon_state = "emitter"


/obj/machinery/power/emitter/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(state == 2)
		if(!powernet)
			user << "The emitter isn't connected to a wire."
			return 1
		if(!src.locked)
			if(src.active==1)
				src.active = 0
				user << "You turn off the [src]."
				message_admins("Emitter turned off by [key_name(user, user.client)](<A HREF='byond://?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
				log_game("Emitter turned off by [user.ckey]([user]) in ([x],[y],[z])")
				investigate_log("turned <font color='red'>off</font> by [user.key]","singulo")
			else
				src.active = 1
				user << "You turn on the [src]."
				src.shot_number = 0
				src.fire_delay = 100
				message_admins("Emitter turned on by [key_name(user, user.client)](<A HREF='byond://?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
				log_game("Emitter turned on by [user.ckey]([user]) in ([x],[y],[z])")
				investigate_log("turned <font color='green'>on</font> by [user.key]","singulo")
			update_icon()
		else
			user << "\red The controls are locked!"
	else
		user << "\red The [src] needs to be firmly secured to the floor first."
		return 1


/obj/machinery/power/emitter/emp_act(var/severity)//Emitters are hardened but still might have issues
//	add_load(1000)
/*	if((severity == 1)&&prob(1)&&prob(1))
		if(src.active)
			src.active = 0
			src.use_power = 1	*/
	return 1

/obj/machinery/containment_field/meteorhit()
	return 0

/obj/machinery/power/emitter/process()
	if(stat & (BROKEN))
		return
	if(src.state != 2 || (!powernet && active_power_usage))
		src.active = 0
		update_icon()
		return
	if(((src.last_shot + src.fire_delay) <= world.time) && (src.active == 1))

		if(!active_power_usage || avail(active_power_usage))
			add_load(active_power_usage)
			if(!powered)
				powered = 1
				update_icon()
				investigate_log("regained power and turned <font color='green'>on</font>","singulo")
		else
			if(powered)
				powered = 0
				update_icon()
				investigate_log("lost power and turned <font color='red'>off</font>","singulo")
			return

		src.last_shot = world.time
		if(src.shot_number < 3)
			src.fire_delay = 2
			src.shot_number ++
		else
			src.fire_delay = rand(20,100)
			src.shot_number = 0
		var/obj/item/projectile/A
		playsound(src.loc, 'sound/weapons/emitter.ogg', 25, 1)
		if(prob(35))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, src)
			s.start()
		A.dir = src.dir
		switch(dir)
			if(NORTH)
				A.yo = 20
				A.xo = 0
			if(EAST)
				A.yo = 0
				A.xo = 20
			if(WEST)
				A.yo = 0
				A.xo = -20
			else // Any other
				A.yo = -20
				A.xo = 0
		A.process()	//TODO: Carn: check this out


/obj/machinery/power/emitter/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/wrench))
		if(active)
			user << "Turn off the [src] first."
			return
		switch(state)
			if(0)
				state = 1
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures [src.name] to the floor.", \
					"You secure the external reinforcing bolts to the floor.", \
					"You hear a ratchet")
				src.anchored = 1
			if(1)
				state = 0
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures [src.name] reinforcing bolts from the floor.", \
					"You undo the external reinforcing bolts.", \
					"You hear a ratchet")
				src.anchored = 0
			if(2)
				user << "\red The [src.name] needs to be unwelded from the floor."
		return

	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(active)
			user << "Turn off the [src] first."
			return
		switch(state)
			if(0)
				user << "\red The [src.name] needs to be wrenched to the floor."
			if(1)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to weld the [src.name] to the floor.", \
						"You start to weld the [src] to the floor.", \
						"You hear welding")
					if (do_after(user,20))
						if(!src || !WT.isOn()) return
						state = 2
						user << "You weld the [src] to the floor."
						connect_to_network()
						src.directwired = 1
				else
					user << "\red You need more welding fuel to complete this task."
			if(2)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to cut the [src.name] free from the floor.", \
						"You start to cut the [src] free from the floor.", \
						"You hear welding")
					if (do_after(user,20))
						if(!src || !WT.isOn()) return
						state = 1
						user << "You cut the [src] free from the floor."
						disconnect_from_network()
						src.directwired = 0
				else
					user << "\red You need more welding fuel to complete this task."
		return

	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/device/pda))
		if(emagged)
			user << "\red The lock seems to be broken"
			return
		if(src.allowed(user))
			if(active)
				src.locked = !src.locked
				user << "The controls are now [src.locked ? "locked." : "unlocked."]"
			else
				src.locked = 0 //just in case it somehow gets locked
				user << "\red The controls can only be locked when the [src] is online"
		else
			user << "\red Access denied."
		return


	if(istype(W, /obj/item/card/emag) && !emagged)
		locked = 0
		emagged = 1
		user.visible_message("[user.name] emags the [src.name].","\red You short out the lock.")
		return

	..()
	return