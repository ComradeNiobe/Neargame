/obj/machinery/computer/aifixer
	name = "AI System Integrity Restorer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "ai-fixer"
	req_access = list(access_captain, access_robotics, access_heads)
	var/active = 0

/obj/machinery/computer/aifixer/New()
	src.overlays += image('icons/obj/computer.dmi', "ai-fixer-empty")


/obj/machinery/computer/aifixer/attackby(I as obj, user as mob)
/*
	if(istype(I, /obj/item/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				new /obj/item/shard( src.loc )
				var/obj/item/circuitboard/robotics/M = new /obj/item/circuitboard/robotics( A )
				for (var/obj/C in src)
					C.loc = src.loc
				M.id = src.id
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				qdel(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				var/obj/item/circuitboard/robotics/M = new /obj/item/circuitboard/robotics( A )
				for (var/obj/C in src)
					C.loc = src.loc
				M.id = src.id
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				qdel(src)
*/
	if(istype(I, /obj/item/device/aicard))
		if(stat & (NOPOWER|BROKEN))
			user << "This terminal isn't functioning right now, get it working!"
			return
		I:transfer_ai("AIFIXER","AICARD",src,user)

	//src.attack_hand(user)
	return

/obj/machinery/computer/aifixer/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/aifixer/attack_paw(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/aifixer/attack_hand(var/mob/user as mob)
	if(..())
		return
	if(level_check()==0)	return
	user.set_machine(src)
	var/dat = "<h3>AI System Integrity Restorer</h3><br><br>"

	var/mob/living/silicon/ai/AI = null

	if(istype(src.occupant, /mob/living/silicon/ai))
		AI = src.occupant


	if (AI)
		var/laws
		dat += "Stored AI: [src.occupant.name]<br>System integrity: [(AI.health+100)/2]%<br>"

		if (AI.laws.zeroth)
			laws += "0: [AI.laws.zeroth]<BR>"

		var/number = 1
		for (var/index = 1, index <= AI.laws.inherent.len, index++)
			var/law = AI.laws.inherent[index]
			if (length(law) > 0)
				laws += "[number]: [law]<BR>"
				number++

		for (var/index = 1, index <= AI.laws.supplied.len, index++)
			var/law = AI.laws.supplied[index]
			if (length(law) > 0)
				laws += "[number]: [law]<BR>"
				number++

		dat += "Laws:<br>[laws]<br>"

		if (src.occupant.stat == 2)
			dat += "<b>AI nonfunctional</b>"
		else
			dat += "<b>AI functional</b>"
		if (!src.active)
			dat += {"<br><br><A href='byond://?src=\ref[src];fix=1'>Begin Reconstruction</A>"}
		else
			dat += "<br><br>Reconstruction in process, please wait.<br>"
	dat += {" <A href='byond://?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/aifixer/process()
	if(..())
		src.updateDialog()
		return

/obj/machinery/computer/aifixer/Topic(href, href_list)
	if(..())
		return
	if (href_list["fix"])
		src.active = 1
		src.overlays += image('icons/obj/computer.dmi', "ai-fixer-on")
		while (src.occupant.health < 100)
			src.occupant.adjustOxyLoss(-1)
			src.occupant.adjustFireLoss(-1)
			src.occupant.adjustToxLoss(-1)
			src.occupant.adjustBruteLoss(-1)
			src.occupant.updatehealth()
			if (src.occupant.health >= 0 && src.occupant.stat == 2)
				src.occupant.stat = 0
				src.occupant.lying = 0
				dead_mob_list -= src.occupant
				living_mob_list += src.occupant
				src.overlays -= image('icons/obj/computer.dmi', "ai-fixer-404")
				src.overlays += image('icons/obj/computer.dmi', "ai-fixer-full")
			src.updateUsrDialog()
			sleep(10)
		src.active = 0
		src.overlays -= image('icons/obj/computer.dmi', "ai-fixer-on")


		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/obj/machinery/computer/aifixer/update_icon()
	..()
	// Broken / Unpowered
	if((stat & BROKEN) || (stat & NOPOWER))
		overlays.Cut()

	// Working / Powered
	else
		if (occupant)
			switch (occupant.stat)
				if (0)
					overlays += image('icons/obj/computer.dmi', "ai-fixer-full")
				if (2)
					overlays += image('icons/obj/computer.dmi', "ai-fixer-404")
		else
			overlays += image('icons/obj/computer.dmi', "ai-fixer-empty")
