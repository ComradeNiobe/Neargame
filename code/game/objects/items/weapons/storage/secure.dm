/*
 *	Absorbs /obj/item/secstorage.
 *	Reimplements it only slightly to use existing storage functionality.
 *
 *	Contains:
 *		Secure Briefcase
 *		Wall Safe
 */

// -----------------------------
//         Generic Item
// -----------------------------
/obj/item/storage/secure
	name = "secstorage"
	var/icon_locking = "secureb"
	var/icon_sparking = "securespark"
	var/icon_opened = "secure0"
	var/locked = 1
	var/code = ""
	var/l_code = null
	var/l_set = 0
	var/l_setshort = 0
	var/l_hacking = 0
	var/emagged = 0
	var/open = 0
	w_class = 3.0
	max_w_class = 2
	max_combined_w_class = 14

	examine()
		set src in oview(1)
		..()
		usr << text("The service panel is [src.open ? "open" : "closed"].")

	attack_paw(mob/user as mob)
		return attack_hand(user)

	attackby(obj/item/W as obj, mob/user as mob)
		if(locked)
			if ( (istype(W, /obj/item/card/emag)||istype(W, /obj/item/melee/energy/blade)) && (!src.emagged))
				emagged = 1
				src.overlays += image('icons/obj/storage.dmi', icon_sparking)
				sleep(6)
				src.overlays = null
				overlays += image('icons/obj/storage.dmi', icon_locking)
				locked = 0
				if(istype(W, /obj/item/melee/energy/blade))
					var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
					spark_system.set_up(5, 0, src.loc)
					spark_system.start()
					playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
					playsound(src.loc, "sparks", 50, 1)
					user << "You slice through the lock on [src]."
				else
					user << "You short out the lock on [src]."
				return

			if (istype(W, /obj/item/screwdriver))
				if (do_after(user, 20))
					src.open =! src.open
					user.show_message(text("\blue You [] the service panel.", (src.open ? "open" : "close")))
				return
			if ((istype(W, /obj/item/device/multitool)) && (src.open == 1)&& (!src.l_hacking))
				src.visible_message("\red <B>[user] picks in wires of the [src] with a multitool!</B>")
				user.show_message(text("\red Now attempting to reset internal memory, please hold."), 1)
				src.l_hacking = 1
				if (do_after(usr, 100))
					if (prob(40))
						src.l_setshort = 1
						src.l_set = 0
						user.show_message(text("\red Internal memory reset.  Please give it a few seconds to reinitialize."), 1)
						sleep(80)
						src.l_setshort = 0
						src.l_hacking = 0
					else
						user.show_message(text("\red Unable to reset internal memory."), 1)
						src.l_hacking = 0
				else	src.l_hacking = 0
				return
			//At this point you have exhausted all the special things to do when locked
			// ... but it's still locked.
			return

		// -> storage/attackby() what with handle insertion, etc
		..()


	MouseDrop(over_object, src_location, over_location)
		if (locked)
			src.add_fingerprint(usr)
			return
		..()


	attack_self(mob/user as mob)
		user.set_machine(src)
		var/list/dat = list()

		dat += text("<TT><B>[]</B><BR>\n\nLock Status: []",src, (src.locked ? "LOCKED" : "UNLOCKED"))
		var/message = "Code"
		if ((src.l_set == 0) && (!src.emagged) && (!src.l_setshort))
			dat += text("<p>\n<b>5-DIGIT PASSCODE NOT SET.<br>ENTER NEW PASSCODE.</b>")
		if (src.emagged)
			dat += text("<p>\n<font color=red><b>LOCKING SYSTEM ERROR - 1701</b></font>")
		if (src.l_setshort)
			dat += text("<p>\n<font color=red><b>ALERT: MEMORY SYSTEM ERROR - 6040 201</b></font>")
		message = text("[]", src.code)
		if (!src.locked)
			message = "*****"
		dat += text("<HR>\n>[]<BR>\n<A href='byond://?src=\ref[];type=1'>1</A>-<A href='byond://?src=\ref[];type=2'>2</A>-<A href='byond://?src=\ref[];type=3'>3</A><BR>\n<A href='byond://?src=\ref[];type=4'>4</A>-<A href='byond://?src=\ref[];type=5'>5</A>-<A href='byond://?src=\ref[];type=6'>6</A><BR>\n<A href='byond://?src=\ref[];type=7'>7</A>-<A href='byond://?src=\ref[];type=8'>8</A>-<A href='byond://?src=\ref[];type=9'>9</A><BR>\n<A href='byond://?src=\ref[];type=R'>R</A>-<A href='byond://?src=\ref[];type=0'>0</A>-<A href='byond://?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)

		var/datum/browser/popup = new(user, "caselock", "SECURE SAFE", 300, 280)
		popup.set_content(JOINTEXT(dat))
		popup.open()


	Topic(href, href_list)
		..()
		if ((usr.stat || usr.restrained()) || (get_dist(src, usr) > 1))
			return
		if (href_list["type"])
			if (href_list["type"] == "E")
				if ((src.l_set == 0) && (length(src.code) == 5) && (!src.l_setshort) && (src.code != "ERROR"))
					src.l_code = src.code
					src.l_set = 1
				else if ((src.code == src.l_code) && (src.emagged == 0) && (src.l_set == 1))
					src.locked = 0
					src.overlays = null
					overlays += image('icons/obj/storage.dmi', icon_opened)
					src.code = null
				else
					src.code = "ERROR"
			else
				if ((href_list["type"] == "R") && (src.emagged == 0) && (!src.l_setshort))
					src.locked = 1
					src.overlays = null
					src.code = null
					src.close(usr)
				else
					src.code += text("[]", href_list["type"])
					if (length(src.code) > 5)
						src.code = "ERROR"
			src.add_fingerprint(usr)
			for(var/mob/M in viewers(1, src.loc))
				if ((M.client && M.machine == src))
					src.attack_self(M)
				return
		return

// -----------------------------
//        Secure Briefcase
// -----------------------------
/obj/item/storage/secure/briefcase
	name = "secure briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secure"
	item_state = "sec-case"
	desc = "A large briefcase with a digital locking system."
	flags = FPRINT | TABLEPASS
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0

	New()
		..()
		new /obj/item/paper(src)
		new /obj/item/pen(src)

	attack_hand(mob/user as mob)
		if ((src.loc == user) && (src.locked == 1))
			usr << "\red [src] is locked and cannot be opened!"
		else if ((src.loc == user) && (!src.locked))
			playsound(src.loc, "rustle", 50, 1, -5)
			if (user.s_active)
				user.s_active.close(user) //Close and re-open
			src.show_to(user)
		else
			..()
			for(var/mob/M in range(1))
				if (M.s_active == src)
					src.close(M)
			src.orient2hud(user)
		src.add_fingerprint(user)
		return

// -----------------------------
//        Secure Safe
// -----------------------------

/obj/item/storage/secure/safe
	name = "secure safe"
	desc = "A large wall-mounted safe with a digital locking system."
	icon = 'icons/obj/storage.dmi'
	icon_state = "safe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	flags = FPRINT | TABLEPASS
	force = 8.0
	w_class = 8.0
	max_w_class = 8
	anchored = 1.0
	density = 0
	plane = 21
	cant_hold = list("/obj/item/storage/secure/briefcase")

	New()
		..()
		new /obj/item/paper(src)
		new /obj/item/pen(src)

	attack_hand(mob/user as mob)
		return attack_self(user)

/obj/item/storage/secure/safe/security/
	desc = "A large wall-mounted safe with a digital locking system. This one has an automatic radio-alert system."

/obj/item/storage/secure/safe/security/New()
	new /obj/item/reagent_containers/hypospray/medipen/combat(src)
	new /obj/item/reagent_containers/hypospray/medipen/combat(src)
	new /obj/item/reagent_containers/hypospray/medipen/combat(src)
	new /obj/item/gun/projectile/automatic/pistol(src)
	new /obj/item/gun/projectile/automatic/pistol(src)
	new /obj/item/ammo_magazine/external/mc9mm(src)
	new /obj/item/ammo_magazine/external/mc9mm(src)
	..()

/obj/item/storage/secure/safe/security/attackby(obj/item/W as obj, mob/user as mob)
	if (locked && (istype(W, /obj/item/device/multitool)) && (!src.open) && (!src.l_hacking))
		user.show_message(text("\red Now attempting to reset internal memory, please hold."), 1)
		src.visible_message("\red <B>[user] picks in wires of the [src] with a multitool!</B>")
		if(prob(70))
			var/obj/item/device/radio/headset/headset_sec/HS = new(src)
			HS.autosay("An attempt to reset the internal memory. [prob(50) ? "[user] is involved!" : ""]", "Security Safe Alarm", "Security", "beeps")
		src.l_hacking = 1
		if (do_after(usr, 100))
			if (prob(20))
				src.l_setshort = 1
				src.l_set = 0
				user.show_message(text("\red Internal memory reset.  Please give it a few seconds to reinitialize."), 1)
				sleep(80)
				src.l_setshort = 0
				src.l_hacking = 0
			else
				user.show_message(text("\red Unable to reset internal memory."), 1)
				src.l_hacking = 0

		else	src.l_hacking = 0
		return
	else
		return ..()


/obj/item/storage/secure/safe/HoS/New()
	..()
	//new /obj/item/storage/lockbox/clusterbang(src) This item is currently broken... and probably shouldnt exist to begin with (even though it's cool)

/obj/item/storage/secure/safe/sheriff/New()
	..()
	new/obj/item/gun/projectile/newRevolver/duelista/neoclassic(src)
	new/obj/item/stack/bullets/Neoclassic/seven(src)

/obj/item/storage/secure/safe/sniffer/New()
	..()
	new/obj/item/gun/projectile/newRevolver/duelista(src)