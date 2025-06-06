#define APC_WIRE_IDSCAN 1
#define APC_WIRE_MAIN_POWER1 2
#define APC_WIRE_MAIN_POWER2 3
#define APC_WIRE_AI_CONTROL 4

#define APC_UPDATE_ICON_COOLDOWN 200 // 20 seconds

// the Area Power Controller (APC), formerly Power Distribution Unit (PDU)
// one per area, needs wire conection to power network

// controls power to devices in that area
// may be opened to change power cell
// three different channels (lighting/equipment/environ) - may each be set to on, off, or auto


//NOTE: STUFF STOLEN FROM AIRLOCK.DM thx


/obj/machinery/power/apc
	name = "area power controller"

	icon_state = "apc0"
	anchored = 1
	use_power = 0
	req_access = list(access_engine_equip)
	var/area/area
	var/areastring = null
	var/obj/item/cell/cell
	var/start_charge = 90				// initial cell charge %
	var/cell_type = 2500				// 0=no cell, 1=regular, 2=high-cap (x5) <- old, now it's just 0=no cell, otherwise dictate cellcapacity by changing this value. 1 used to be 1000, 2 was 2500
	var/opened = 0 //0=closed, 1=opened, 2=cover removed
	var/shorted = 0
	var/lighting = 3
	var/equipment = 3
	var/environ = 3
	var/operating = 1
	var/charging = 0
	var/chargemode = 1
	var/chargecount = 0
	var/locked = 1
	var/coverlocked = 1
	var/aidisabled = 0
	var/tdir = null
	var/obj/machinery/power/terminal/terminal = null
	var/lastused_light = 0
	var/lastused_equip = 0
	var/lastused_environ = 0
	var/lastused_total = 0
	var/main_status = 0
	var/wiresexposed = 0
	var/apcwires = 15
	powernet = 0		// set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(
	var/malfhack = 0 //New var for my changes to AI malf. --NeoFite
	var/mob/living/silicon/ai/malfai = null //See above --NeoFite
//	luminosity = 1
	var/has_electronics = 0 // 0 - none, 1 - plugged in, 2 - secured by screwdriver
	var/overload = 1 //used for the Blackout malf module
	var/beenhit = 0 // used for counting how many times it has been hit, used for Aliens at the moment
	var/list/apcwirelist = list(
		"Orange" = 1,
		"Dark red" = 2,
		"White" = 3,
		"Yellow" = 4,
	)
	var/longtermpower = 10
	var/updating_icon = 0
	//var/debug = 0

/obj/machinery/power/apc/worn_out
	start_charge = 0

/proc/RandomAPCWires()
	//to make this not randomize the wires, just set index to 1 and increment it in the flag for loop (after doing everything else).
	var/list/apcwires = list(0, 0, 0, 0)
	APCIndexToFlag = list(0, 0, 0, 0)
	APCIndexToWireColor = list(0, 0, 0, 0)
	APCWireColorToIndex = list(0, 0, 0, 0)
	var/flagIndex = 1
	for (var/flag=1, flag<16, flag+=flag)
		var/valid = 0
		while (!valid)
			var/colorIndex = rand(1, 4)
			if (apcwires[colorIndex]==0)
				valid = 1
				apcwires[colorIndex] = flag
				APCIndexToFlag[flagIndex] = flag
				APCIndexToWireColor[flagIndex] = colorIndex
				APCWireColorToIndex[colorIndex] = flagIndex
		flagIndex+=1
	return apcwires

/obj/machinery/power/apc/updateDialog()
	if (stat & (BROKEN|MAINT))
		return
	..()

/obj/machinery/power/apc/New(turf/loc, var/ndir, var/building=0)
	..()

	// offset 24 pixels in direction of dir
	// this allows the APC to be embedded in a wall, yet still inside an area
	if (building)
		dir = ndir
	src.tdir = dir		// to fix Vars bug
	dir = SOUTH

	pixel_x = (src.tdir & 3)? 0 : (src.tdir == 4 ? 24 : -24)
	pixel_y = (src.tdir & 3)? (src.tdir ==1 ? 24 : -24) : 0
	if (building==0)
		init()
	else
		area = src.loc.loc:master
		area.apc |= src
		opened = 1
		operating = 0
		name = "[area.name] APC"
		stat |= MAINT
		src.update_icon()
		spawn(5)
			src.update()



/obj/machinery/power/apc/proc/make_terminal()
	// create a terminal object at the same position as original turf loc
	// wires will attach to this
	terminal = new/obj/machinery/power/terminal(src.loc)
	terminal.dir = tdir
	terminal.master = src

/obj/machinery/power/apc/proc/init()
	has_electronics = 2 //installed and secured
	// is starting with a power cell installed, create it and set its charge level
	if(cell_type)
		src.cell = new/obj/item/cell(src)
		cell.maxcharge = cell_type	// cell_type is maximum charge (old default was 1000 or 2500 (values one and two respectively)
		cell.charge = start_charge * cell.maxcharge / 100.0 		// (convert percentage to actual value)

	var/area/A = src.loc.loc

	//if area isn't specified use current
	if(isarea(A) && src.areastring == null)
		src.area = A
		name = "[area.name] APC"
	else
		src.area = get_area_name(areastring)
		name = "[area.name] APC"
	update_icon()

	make_terminal()

	spawn(5)
		src.update()

/obj/machinery/power/apc/examine()
	set src in oview(1)

	if(usr /*&& !usr.stat*/)
		usr << "A control terminal for the area electrical systems."
		if(stat & BROKEN)
			usr << "Looks broken."
			return
		if(opened)
			if(has_electronics && terminal)
				usr << "The cover is [opened==2?"removed":"open"] and the power cell is [ cell ? "installed" : "missing"]."
			else if (!has_electronics && terminal)
				usr << "There are some wires but no any electronics."
			else if (has_electronics && !terminal)
				usr << "Electronics installed but not wired."
			else /* if (!has_electronics && !terminal) */
				usr << "There is no electronics nor connected wires."

		else
			if (stat & MAINT)
				usr << "The cover is closed. Something wrong with it: it doesn't work."
			else if (malfhack)
				usr << "The cover is broken. It may be hard to force it open."
			else
				usr << "The cover is closed."


// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/update_icon()

	overlays.Cut()
	if(opened)
		var/basestate = "apc[ cell ? "2" : "1" ]"	// if opened, show cell if it's inserted
		if (opened==1)
			if (stat & (MAINT|BROKEN))
				icon_state = "apcmaint" //disassembled APC cannot hold cell
			else
				icon_state = basestate
		else if (opened == 2)
			icon_state = "[basestate]-nocover"
	else if (stat & BROKEN)
		icon_state = "apc-b"
	else if(emagged || malfai)
		icon_state = "apcemag"
	else if(wiresexposed)
		icon_state = "apcewires"
	else
		icon_state = "apc0"
		// if closed, update overlays for channel status
		if(!(stat & (BROKEN|MAINT)))
			overlays.Add("apcox-[locked]","apco3-[charging]")	// 0=blue 1=red // 0=red, 1=yellow/black 2=green
			if(operating)
				overlays.Add("apco0-[equipment]","apco1-[lighting]","apco2-[environ]")	// 0=red, 1=green, 2=blue

// Used in process so it doesn't update the icon too much
/obj/machinery/power/apc/proc/queue_icon_update()

	if(!updating_icon)
		updating_icon = 1
		// Start the update
		spawn(APC_UPDATE_ICON_COOLDOWN)
			update_icon()
			updating_icon = 0

//attack with an item - open/close cover, insert cell, or (un)lock interface

/obj/machinery/power/apc/attackby(obj/item/W, mob/user)

	if (istype(user, /mob/living/silicon) && get_dist(src,user)>1)
		return src.attack_hand(user)
	src.add_fingerprint(user)
	if (istype(W, /obj/item/crowbar) && opened)
		if (has_electronics==1)
			if (terminal)
				user << "\red Disconnect wires first."
				return
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
			user << "You are trying to remove the power control board..." //lpeters - fixed grammar issues
			if(do_after(user, 50))
				has_electronics = 0
				if ((stat & BROKEN) || malfhack)
					user.visible_message(\
						"\red [user.name] has broken the power control board inside [src.name]!",\
						"You broke the charred power control board and remove the remains.",
						"You hear a crack!")
					//ticker.mode:apcs-- //XSI said no and I agreed. -rastaf0
				else
					user.visible_message(\
						"\red [user.name] has removed the power control board from [src.name]!",\
						"You remove the power control board.")
					new /obj/item/module/power_control(loc)
		else if (opened!=2) //cover isn't removed
			opened = 0
			update_icon()
	else if (istype(W, /obj/item/crowbar) && !((stat & BROKEN) || malfhack) )
		if(coverlocked && !(stat & MAINT))
			user << "\red The cover is locked and cannot be opened."
			return
		else
			opened = 1
			update_icon()
	else if	(istype(W, /obj/item/cell) && opened)	// trying to put a cell inside
		if(cell)
			user << "There is a power cell already installed."
			return
		else
			if (stat & MAINT)
				user << "\red There is no connector for your power cell."
				return
			user.drop_item()
			W.loc = src
			cell = W
			user.visible_message(\
				"\red [user.name] has inserted the power cell to [src.name]!",\
				"You insert the power cell.")
			chargecount = 0
			update_icon()
	else if	(istype(W, /obj/item/screwdriver))	// haxing
		if(opened)
			if (cell)
				user << "\red Close the APC first." //Less hints more mystery!
				return
			else
				if (has_electronics==1 && terminal)
					has_electronics = 2
					stat &= ~MAINT
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					user << "You screw the circuit electronics into place."
				else if (has_electronics==2)
					has_electronics = 1
					stat |= MAINT
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					user << "You unfasten the electronics."
				else /* has_electronics==0 */
					user << "\red There is nothing to secure."
					return
				update_icon()
		else if(emagged)
			user << "The interface is broken."
		else
			wiresexposed = !wiresexposed
			user << "The wires have been [wiresexposed ? "exposed" : "unexposed"]"
			update_icon()

	else if (istype(W, /obj/item/card/id)||istype(W, /obj/item/device/pda))			// trying to unlock the interface with an ID card
		if(emagged)
			user << "The interface is broken."
		else if(opened)
			user << "You must close the cover to swipe an ID card."
		else if(wiresexposed)
			user << "You must close the panel"
		else if(stat & (BROKEN|MAINT))
			user << "Nothing happens."
		else
			if(src.allowed(usr))
				locked = !locked
				user << "You [ locked ? "lock" : "unlock"] the APC interface."
				update_icon()
			else
				user << "\red Access denied."
	else if (istype(W, /obj/item/card/emag) && !(emagged || malfhack))		// trying to unlock with an emag card
		if(opened)
			user << "You must close the cover to swipe an ID card."
		else if(wiresexposed)
			user << "You must close the panel first"
		else if(stat & (BROKEN|MAINT))
			user << "Nothing happens."
		else
			flick("apc-spark", src)
			if (do_after(user,6))
				if(prob(50))
					emagged = 1
					locked = 0
					user << "You emag the APC interface."
					update_icon()
				else
					user << "You fail to [ locked ? "unlock" : "lock"] the APC interface."
	else if (istype(W, /obj/item/stack/cable_coil) && !terminal && opened && has_electronics!=2)
		if (src.loc:intact)
			user << "\red You must remove the floor plating in front of the APC first."
			return
		var/obj/item/stack/cable_coil/C = W
		if(C.amount < 10)
			user << "\red You need more wires."
			return
		user << "You start adding cables to the APC frame..."
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20) && C.amount >= 10)
			var/turf/T = get_turf_loc(src)
			var/obj/structure/cable/N = T.get_cable_node()
			if (prob(50) && electrocute_mob(usr, N, N))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				return
			C.use(10)
			user.visible_message(\
				"\red [user.name] has added cables to the APC frame!",\
				"You add cables to the APC frame.")
			make_terminal()
			terminal.connect_to_network()
	else if (istype(W, /obj/item/wirecutters) && terminal && opened && has_electronics!=2)
		if (src.loc:intact)
			user << "\red You must remove the floor plating in front of the APC first."
			return
		user << "You begin to cut the cables..."
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 50))
			if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				return
			new /obj/item/stack/cable_coil(loc,10)
			user.visible_message(\
				"\red [user.name] cut the cables and dismantled the power terminal.",\
				"You cut the cables and dismantle the power terminal.")
			qdel(terminal)
	else if (istype(W, /obj/item/module/power_control) && opened && has_electronics==0 && !((stat & BROKEN) || malfhack))
		user << "You trying to insert the power control board into the frame..."
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 10))
			has_electronics = 1
			user << "You place the power control board inside the frame."
			qdel(W)
	else if (istype(W, /obj/item/module/power_control) && opened && has_electronics==0 && ((stat & BROKEN) || malfhack))
		user << "\red You cannot put the board inside, the frame is damaged."
		return
	else if (istype(W, /obj/item/weldingtool) && opened && has_electronics==0 && !terminal)
		var/obj/item/weldingtool/WT = W
		if (WT.get_fuel() < 3)
			user << "\blue You need more welding fuel to complete this task."
			return
		user << "You start welding the APC frame..."
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 50))
			if(!src || !WT.remove_fuel(3, user)) return
			if (emagged || malfhack || (stat & BROKEN) || opened==2)
				new /obj/item/stack/sheet/metal(loc)
				user.visible_message(\
					"\red [src] has been cut apart by [user.name] with the weldingtool.",\
					"You disassembled the broken APC frame.",\
					"\red You hear welding.")
			else
				new /obj/item/apc_frame(loc)
				user.visible_message(\
					"\red [src] has been cut from the wall by [user.name] with the weldingtool.",\
					"You cut the APC frame from the wall.",\
					"\red You hear welding.")
			qdel(src)
			return
	else if (istype(W, /obj/item/apc_frame) && opened && emagged)
		emagged = 0
		if (opened==2)
			opened = 1
		user.visible_message(\
			"\red [user.name] has replaced the damaged APC frontal panel with a new one.",\
			"You replace the damaged APC frontal panel with a new one.")
		qdel(W)
		update_icon()
	else if (istype(W, /obj/item/apc_frame) && opened && ((stat & BROKEN) || malfhack))
		if (has_electronics)
			user << "You cannot repair this APC until you remove the electronics still inside."
			return
		user << "You begin to replace the damaged APC frame..."
		if(do_after(user, 50))
			user.visible_message(\
				"\red [user.name] has replaced the damaged APC frame with new one.",\
				"You replace the damaged APC frame with new one.")
			qdel(W)
			stat &= ~BROKEN
			malfai = null
			malfhack = 0
			if (opened==2)
				opened = 1
			update_icon()
	else
		if (	((stat & BROKEN) || malfhack) \
				&& !opened \
				&& W.force >= 5 \
				&& W.w_class >= 3.0 \
				&& prob(20) )
			opened = 2
			user.visible_message("\red The APC cover was knocked down with the [W.name] by [user.name]!", \
				"\red You knock down the APC cover with your [W.name]!", \
				"You hear bang")
			update_icon()
		else
			if (istype(user, /mob/living/silicon))
				return src.attack_hand(user)
			if (!opened && wiresexposed && \
				(istype(W, /obj/item/device/multitool) || \
				istype(W, /obj/item/wirecutters)))
				return src.attack_hand(user)
			user.visible_message("\red The [src.name] has been hit with the [W.name] by [user.name]!", \
				"\red You hit the [src.name] with your [W.name]!", \
				"You hear bang")

// attack with hand - remove cell (if cover open) or interact with the APC

/obj/machinery/power/apc/attack_hand(mob/user)

	if(!user)
		return

	src.add_fingerprint(user)

	//Human mob special interaction goes here.
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user

		if(H.species.flags & IS_SYNTHETIC && H.a_intent == "grab")
			if(emagged || stat & BROKEN)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(3, 1, src)
				s.start()
				H << "\red The APC power currents surge eratically, damaging your chassis!"
				H.adjustFireLoss(10,0)
			else if(src.cell && src.cell.charge > 0)
				if(H.nutrition < 450)

					if(src.cell.charge >= 500)
						H.nutrition += 50
						src.cell.charge -= 500
					else
						H.nutrition += src.cell.charge/10
						src.cell.charge = 0

					user << "\blue You slot your fingers into the APC interface and siphon off some of the stored charge for your own use."
					if(src.cell.charge < 0) src.cell.charge = 0
					if(H.nutrition > 500) H.nutrition = 500
					src.charging = 1

				else
					user << "\blue You are already fully charged."
			else
				user << "There is no charge to draw from that APC."
			return
		else if(H.species.can_shred(H))
			user.visible_message("\red [user.name] slashes at the [src.name]!", "\blue You slash at the [src.name]!")
			playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)
			var/allcut = 1
			for(var/wire in apcwirelist)
				if(!isWireCut(apcwirelist[wire]))
					allcut = 0
					break
			if(beenhit >= pick(3, 4) && wiresexposed != 1)
				wiresexposed = 1
				src.update_icon()
				src.visible_message("\red The [src.name]'s cover flies open, exposing the wires!")

			else if(wiresexposed == 1 && allcut == 0)
				for(var/wire in apcwirelist)
					cut(apcwirelist[wire])
				src.update_icon()
				src.visible_message("\red The [src.name]'s wires are shredded!")
			else
				beenhit += 1
			return


	if(usr == user && opened && (!issilicon(user)))
		if(cell)
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell.updateicon()

			src.cell = null
			user.visible_message("\red [user.name] removes the power cell from [src.name]!", "You remove the power cell.")
			//user << "You remove the power cell."
			charging = 0
			src.update_icon()
		return
	if(stat & (BROKEN|MAINT))
		return

	// do APC interaction
	//user.set_machine(src)
	src.interact(user)


/obj/machinery/power/apc/interact(mob/user)
	if(!user)
		return

	if(wiresexposed /*&& (!istype(user, /mob/living/silicon))*/) //Commented out the typecheck to allow engiborgs to repair damaged apcs.
		var/t1 = text("<html><head><title>[area.name] APC wires</title></head><body><B>Access Panel</B><br>\n")

		for(var/wiredesc in apcwirelist)
			var/is_uncut = src.apcwires & APCWireColorToFlag[apcwirelist[wiredesc]]
			t1 += "[wiredesc] wire: "
			if(!is_uncut)
				t1 += "<a href='byond://?src=\ref[src];apcwires=[apcwirelist[wiredesc]]'>Mend</a>"
			else
				t1 += "<a href='byond://?src=\ref[src];apcwires=[apcwirelist[wiredesc]]'>Cut</a> "
				t1 += "<a href='byond://?src=\ref[src];pulse=[apcwirelist[wiredesc]]'>Pulse</a> "
			t1 += "<br>"
		t1 += text("<br>\n[(src.locked ? "The APC is locked." : "The APC is unlocked.")]<br>\n[(src.shorted ? "The APCs power has been shorted." : "The APC is working properly!")]<br>\n[(src.aidisabled ? "The 'AI control allowed' light is off." : "The 'AI control allowed' light is on.")]")
		t1 += text("<p><a href='byond://?src=\ref[src];close2=1'>Close</a></p></body></html>")
		user << browse(t1, "window=apcwires")
		onclose(user, "apcwires")

	// Open the APC NanoUI
	ui_interact(user)
	return

/obj/machinery/power/apc/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	if(!user)
		return

	var/list/data = list(
		"locked" = locked,
		"isOperating" = operating,
		"externalPower" = main_status,
		"powerCellStatus" = cell ? cell.percent() : null,
		"chargeMode" = chargemode,
		"chargingStatus" = charging,
		"totalLoad" = lastused_equip + lastused_light + lastused_environ,
		"coverLocked" = coverlocked,
		"siliconUser" = istype(user, /mob/living/silicon),

		"powerChannels" = list(
			list(
				"title" = "Equipment",
				"powerLoad" = lastused_equip,
				"status" = equipment,
				"topicParams" = list(
					"auto" = list("eqp" = 3),
					"on"   = list("eqp" = 2),
					"off"  = list("eqp" = 1)
				)
			),
			list(
				"title" = "Lighting",
				"powerLoad" = lastused_light,
				"status" = lighting,
				"topicParams" = list(
					"auto" = list("lgt" = 3),
					"on"   = list("lgt" = 2),
					"off"  = list("lgt" = 1)
				)
			),
			list(
				"title" = "Environment",
				"powerLoad" = lastused_environ,
				"status" = environ,
				"topicParams" = list(
					"auto" = list("env" = 3),
					"on"   = list("env" = 2),
					"off"  = list("env" = 1)
				)
			)
		)
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "apc.tmpl", "[area.name] - APC", 520, data["siliconUser"] ? 465 : 440)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/apc/proc/report()
	return "[area.name] : [equipment]/[lighting]/[environ] ([lastused_equip+lastused_light+lastused_environ]) : [cell? cell.percent() : "N/C"] ([charging])"

/obj/machinery/power/apc/proc/update()
	if(operating && !shorted)
		area.power_light = (lighting > 1)
		area.power_equip = (equipment > 1)
		area.power_environ = (environ > 1)
//		if (area.name == "AI Chamber")
//			spawn(10)
//				world << " [area.name] [area.power_equip]"
	else
		area.power_light = 0
		area.power_equip = 0
		area.power_environ = 0
//		if (area.name == "AI Chamber")
//			world << "[area.power_equip]"
	area.power_change()

/obj/machinery/power/apc/proc/isWireColorCut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	return ((src.apcwires & wireFlag) == 0)

/obj/machinery/power/apc/proc/isWireCut(var/wireIndex)
	var/wireFlag = APCIndexToFlag[wireIndex]
	return ((src.apcwires & wireFlag) == 0)

/obj/machinery/power/apc/proc/cut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor]
	apcwires &= ~wireFlag
	switch(wireIndex)
		if(APC_WIRE_MAIN_POWER1)
			src.shock(usr, 50)
			src.shorted = 1
			src.updateDialog()
		if(APC_WIRE_MAIN_POWER2)
			src.shock(usr, 50)
			src.shorted = 1
			src.updateDialog()
		if (APC_WIRE_AI_CONTROL)
			if (src.aidisabled == 0)
				src.aidisabled = 1
			src.updateDialog()
//		if(APC_WIRE_IDSCAN)		nothing happens when you cut this wire, add in something if you want whatever

/obj/machinery/power/apc/proc/mend(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor] //not used in this function
	apcwires |= wireFlag
	switch(wireIndex)
		if(APC_WIRE_MAIN_POWER1)
			if ((!src.isWireCut(APC_WIRE_MAIN_POWER1)) && (!src.isWireCut(APC_WIRE_MAIN_POWER2)))
				src.shorted = 0
				src.shock(usr, 50)
				src.updateDialog()
		if(APC_WIRE_MAIN_POWER2)
			if ((!src.isWireCut(APC_WIRE_MAIN_POWER1)) && (!src.isWireCut(APC_WIRE_MAIN_POWER2)))
				src.shorted = 0
				src.shock(usr, 50)
				src.updateDialog()
		if (APC_WIRE_AI_CONTROL)
			//one wire for AI control. Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
			//aidisabledDisabled: If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
			if (src.aidisabled == 1)
				src.aidisabled = 0
			src.updateDialog()
//		if(APC_WIRE_IDSCAN)		nothing happens when you cut this wire, add in something if you want whatever

/obj/machinery/power/apc/proc/pulse(var/wireColor)
	//var/wireFlag = apcWireColorToFlag[wireColor] //not used in this function
	var/wireIndex = APCWireColorToIndex[wireColor]
	switch(wireIndex)
		if(APC_WIRE_IDSCAN)			//unlocks the APC for 30 seconds, if you have a better way to hack an APC I'm all ears
			src.locked = 0
			spawn(300)
				src.locked = 1
				src.updateDialog()
		if (APC_WIRE_MAIN_POWER1)
			if(shorted == 0)
				shorted = 1
			spawn(1200)
				if(shorted == 1)
					shorted = 0
				src.updateDialog()
		if (APC_WIRE_MAIN_POWER2)
			if(shorted == 0)
				shorted = 1
			spawn(1200)
				if(shorted == 1)
					shorted = 0
				src.updateDialog()
		if (APC_WIRE_AI_CONTROL)
			if (src.aidisabled == 0)
				src.aidisabled = 1
			src.updateDialog()
			spawn(10)
				if (src.aidisabled == 1)
					src.aidisabled = 0
				src.updateDialog()

/obj/machinery/power/apc/proc/can_use(mob/user as mob, var/loud = 0) //used by attack_hand() and Topic()
	if (user.stat)
		user << "\red You must be conscious to use this [src]!"
		return 0
	if(!user.client)
		return 0
	if ( ! (istype(user, /mob/living/carbon/human) || \
			istype(user, /mob/living/silicon) || \
			istype(user, /mob/living/carbon/monkey) /*&& ticker && ticker.mode.name == "monkey"*/) )
		user << "\red You don't have the dexterity to use this [src]!"
		nanomanager.close_user_uis(user, src)

		return 0
	if(user.restrained())
		user << "\red You must have free hands to use this [src]"
		return 0
	if(user.lying)
		user << "\red You must stand to use this [src]!"
		return 0
	if (istype(user, /mob/living/silicon))
		var/mob/living/silicon/ai/AI = user
		var/mob/living/silicon/robot/robot = user
		if (                                                             \
			src.aidisabled ||                                            \
			malfhack && istype(malfai) &&                                \
			(                                                            \
				(istype(AI) && (malfai!=AI && malfai != AI.parent)) ||   \
				(istype(robot) && (robot in malfai.connected_robots))    \
			)                                                            \
		)
			if(!loud)
				user << "\red \The [src] have AI control disabled!"
				nanomanager.close_user_uis(user, src)

			return 0
	else
		if ((!in_range(src, user) || !istype(src.loc, /turf)))
			nanomanager.close_user_uis(user, src)

			return 0

	var/mob/living/carbon/human/H = user
	if (istype(H))
		if(H.getBrainLoss() >= 60)
			for(var/mob/M in viewers(src, null))
				M << "\red [H] stares cluelessly at [src] and drools."
			return 0
		else if(prob(H.getBrainLoss()))
			user << "\red You momentarily forget how to use [src]."
			return 0
	return 1

/obj/machinery/power/apc/Topic(href, href_list, var/usingUI = 1)
	if(!(isrobot(usr) && (href_list["apcwires"] || href_list["pulse"])))
		if(!can_use(usr, 1))
			return
	src.add_fingerprint(usr)

	if (href_list["apcwires"])
		var/t1 = text2num(href_list["apcwires"])
		if (!( istype(usr.get_active_hand(), /obj/item/wirecutters) ))
			usr << "You need wirecutters!"
			return
		if (src.isWireColorCut(t1))
			src.mend(t1)
		else
			src.cut(t1)
	else if (href_list["pulse"])
		var/t1 = text2num(href_list["pulse"])
		if (!istype(usr.get_active_hand(), /obj/item/device/multitool))
			usr << "You need a multitool!"
			return
		if (src.isWireColorCut(t1))
			usr << "You can't pulse a cut wire."
			return
		else
			src.pulse(t1)
	else if (href_list["lock"])
		coverlocked = !coverlocked

	else if (href_list["breaker"])
		operating = !operating

		src.update()
		update_icon()

	else if (href_list["cmode"])
		chargemode = !chargemode
		if(!chargemode)
			charging = 0
			update_icon()

	else if (href_list["eqp"])
		var/val = text2num(href_list["eqp"])

		equipment = (val==1) ? 0 : val

		update_icon()
		update()

	else if (href_list["lgt"])
		var/val = text2num(href_list["lgt"])

		lighting = (val==1) ? 0 : val

		update_icon()
		update()
	else if (href_list["env"])
		var/val = text2num(href_list["env"])

		environ = (val==1) ? 0 :val

		update_icon()
		update()
	else if( href_list["close"] )
		nanomanager.close_user_uis(usr, src)

		return
	else if (href_list["close2"])
		usr << browse(null, "window=apcwires")

		return

	else if (href_list["overload"])
		if( istype(usr, /mob/living/silicon) && !src.aidisabled )
			src.overload_lighting()

	/*else if (href_list["occupyapc"])
		malfoccupy(usr)


	else if (href_list["deoccupyapc"])
		malfvacate()*/

	if(usingUI)
		src.updateDialog()

	return

/*/obj/machinery/power/apc/proc/malfoccupy(var/mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(istype(malf.loc, /obj/machinery/power/apc)) // Already in an APC
		malf << "<span class='warning'>You must evacuate your current apc first.</span>"
		return
	if(src.z != 1)
		return
	src.occupant = new /mob/living/silicon/ai(src,malf.laws,null,1)
	src.occupant.adjustOxyLoss(malf.getOxyLoss())
	if(!findtext(src.occupant.name,"APC Copy"))
		src.occupant.name = "[malf.name] APC Copy"
	if(malf.parent)
		src.occupant.parent = malf.parent
	else
		src.occupant.parent = malf
	malf.mind.transfer_to(src.occupant)
	src.occupant.eyeobj.name = "[src.occupant.name] (AI Eye)"
	if(malf.parent)
		qdel(malf)
	src.occupant.verbs += /mob/living/silicon/ai/proc/corereturn
	src.occupant.verbs += /datum/game_mode/malfunction/proc/takeover
	src.occupant.cancel_camera()

/obj/machinery/power/apc/proc/malfvacate(var/forced)
	if(!src.occupant)
		return
	if(src.occupant.parent && src.occupant.parent.stat != 2)
		src.occupant.mind.transfer_to(src.occupant.parent)
		src.occupant.parent.adjustOxyLoss(src.occupant.getOxyLoss())
		src.occupant.parent.cancel_camera()
		qdel(src.occupant)

	else
		src.occupant << "\red Primary core damaged, unable to return core processes."
		if(forced)
			src.occupant.loc = src.loc
			src.occupant.death()
			src.occupant.gib()*/


/obj/machinery/power/apc/proc/ion_act()
	//intended to be exactly the same as an AI malf attack
	if(!src.malfhack && src.z in vessel_z)
		if(prob(3))
			src.locked = 1
			if (src.cell.charge > 0)
//				world << "\red blew APC in [src.loc.loc]"
				src.cell.charge = 0
				cell.corrupt()
				src.malfhack = 1
				update_icon()
				var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
				smoke.set_up(3, 0, src.loc)
				smoke.attach(src)
				smoke.start()
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(3, 1, src)
				s.start()
				for(var/mob/M in viewers(src))
					M.show_message("\red The [src.name] suddenly lets out a blast of smoke and some sparks!", 3, "\red You hear sizzling electronics.", 2)


/obj/machinery/power/apc/surplus()
	if(terminal)
		return terminal.surplus()
	else
		return 0

/obj/machinery/power/apc/add_load(var/amount)
	if(terminal && terminal.powernet)
		terminal.powernet.newload += amount

/obj/machinery/power/apc/avail()
	if(terminal)
		return terminal.avail()
	else
		return 0

/obj/machinery/power/apc/process()

	if(stat & (BROKEN|MAINT))
		return
	if(!area.requires_power)
		return


	/*
	if (equipment > 1) // off=0, off auto=1, on=2, on auto=3
		use_power(src.equip_consumption, EQUIP)
	if (lighting > 1) // off=0, off auto=1, on=2, on auto=3
		use_power(src.light_consumption, LIGHT)
	if (environ > 1) // off=0, off auto=1, on=2, on auto=3
		use_power(src.environ_consumption, ENVIRON)

	area.calc_lighting() */

	lastused_light = area.usage(LIGHT)
	lastused_equip = area.usage(EQUIP)
	lastused_environ = area.usage(ENVIRON)
	area.clear_usage()

	lastused_total = lastused_light + lastused_equip + lastused_environ

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()

	if(!src.avail())
		main_status = 0
	else if(excess < 0)
		main_status = 1
	else
		main_status = 2

	var/perapc = 0
	if(terminal && terminal.powernet)
		perapc = terminal.powernet.perapc

/*	if(debug)
		log_debug( "Status: [main_status] - Excess: [excess] - Last Equip: [lastused_equip] - Last Light: [lastused_light]")

		if(area.powerupdate)
			log_debug("power update in [area.name] / [name]")
*/

	if(cell && !shorted)

		// draw power from cell as before

		var/cellused = min(cell.charge, CELLRATE * lastused_total)	// clamp deduction to a max, amount left in cell
		cell.use(cellused)

		if(excess > 0 || perapc > lastused_total)		// if power excess, or enough anyway, recharge the cell
														// by the same amount just used
			cell.give(cellused)
			add_load(cellused/CELLRATE)		// add the load used to recharge the cell


		else		// no excess, and not enough per-apc

			if( (cell.charge/CELLRATE+perapc) >= lastused_total)		// can we draw enough from cell+grid to cover last usage?

				cell.charge = min(cell.maxcharge, cell.charge + CELLRATE * perapc)	//recharge with what we can
				add_load(perapc)		// so draw what we can from the grid
				charging = 0

			else	// not enough power available to run the last tick!
				charging = 0
				chargecount = 0
				// This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)


		// set channels depending on how much charge we have left

		// Allow the APC to operate as normal if the cell can charge
		if(charging && longtermpower < 10)
			longtermpower += 1
		else if(longtermpower > -10)
			longtermpower -= 2

		if(cell.charge <= 0)					// zero charge, turn all off
			equipment = autoset(equipment, 0)
			lighting = autoset(lighting, 0)
			environ = autoset(environ, 0)
			area.poweralert(0, src)
		else if(cell.percent() < 15 && longtermpower < 0)	// <15%, turn off lighting & equipment
			equipment = autoset(equipment, 2)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			area.poweralert(0, src)
		else if(cell.percent() < 30 && longtermpower < 0)			// <30%, turn off equipment
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			area.poweralert(0, src)
		else									// otherwise all can be on
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 1)
			environ = autoset(environ, 1)
			area.poweralert(1, src)
			if(cell.percent() > 75)
				area.poweralert(1, src)

		// now trickle-charge the cell

		if(chargemode && charging == 1 && operating)
			if(excess > 0)		// check to make sure we have enough to charge
				// Max charge is perapc share, capped to cell capacity, or % per second constant (Whichever is smallest)
/*				var/ch = min(perapc, (cell.maxcharge - cell.charge), (cell.maxcharge*CHARGELEVEL))
				add_load(ch) // Removes the power we're taking from the grid
				cell.give(ch) // actually recharge the cell
*/
				var/ch = min(perapc*CELLRATE, (cell.maxcharge - cell.charge), (cell.maxcharge*CHARGELEVEL))
				add_load(ch/CELLRATE) // Removes the power we're taking from the grid
				cell.give(ch) // actually recharge the cell

			else
				charging = 0		// stop charging
				chargecount = 0

		// show cell as fully charged if so

		if(cell.charge >= cell.maxcharge)
			charging = 2

		if(chargemode)
			if(!charging)
				if(excess > cell.maxcharge*CHARGELEVEL)
					chargecount++
				else
					chargecount = 0

				if(chargecount == 10)

					chargecount = 0
					charging = 1

		else // chargemode off
			charging = 0
			chargecount = 0

	else // no cell, switch everything off

		charging = 0
		chargecount = 0
		equipment = autoset(equipment, 0)
		lighting = autoset(lighting, 0)
		environ = autoset(environ, 0)
		area.poweralert(0, src)

	// update icon & area power if anything changed

	if(last_lt != lighting || last_eq != equipment || last_en != environ)
		queue_icon_update()
		update()
	else if (last_ch != charging)
		queue_icon_update()

	//src.updateDialog()
	src.updateDialog()

// val 0=off, 1=off(auto) 2=on 3=on(auto)
// on 0=off, 1=on, 2=autooff

/proc/autoset(var/val, var/on)

	if(on==0)
		if(val==2)			// if on, return off
			return 0
		else if(val==3)		// if auto-on, return auto-off
			return 1

	else if(on==1)
		if(val==1)			// if auto-off, return auto-on
			return 3

	else if(on==2)
		if(val==3)			// if auto-on, return auto-off
			return 1

	return val

// damage and destruction acts

/obj/machinery/power/apc/meteorhit(var/obj/O as obj)

	set_broken()
	return

/obj/machinery/power/apc/emp_act(severity)
	if(cell)
		cell.emp_act(severity)
	if(occupant)
		occupant.emp_act(severity)
	lighting = 0
	equipment = 0
	environ = 0
	spawn(600)
		equipment = 3
		environ = 3
	..()

/obj/machinery/power/apc/ex_act(severity)

	switch(severity)
		if(1.0)
			//set_broken() //now Destroy() do what we need
			if (cell)
				cell.ex_act(1.0) // more lags woohoo
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				set_broken()
				if (cell && prob(50))
					cell.ex_act(2.0)
		if(3.0)
			if (prob(25))
				set_broken()
				if (cell && prob(25))
					cell.ex_act(3.0)
	return

/obj/machinery/power/apc/proc/set_broken()
	stat |= BROKEN
	operating = 0
	/*if(occupant)
		malfvacate(1)*/
	update_icon()
	update()

// overload all the lights in this APC area

/obj/machinery/power/apc/proc/overload_lighting()
	if(/* !get_connection() || */ !operating || shorted)
		return
	if( cell && cell.charge>=20)
		cell.use(20);
		spawn(0)
			for(var/area/A in area.related)
				for(var/obj/machinery/light/L in A)
					L.on = 1
					L.broken()
					sleep(1)

/obj/machinery/power/apc/Destroy()
	area.power_light = 0
	area.power_equip = 0
	area.power_environ = 0
	area.power_change()
	/*if(occupant)
		malfvacate(1)*/
	..()

/obj/machinery/power/apc/proc/shock(mob/user, prb)
	if(!prob(prb))
		return 0
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(isalien(user))
		return 0
	if (electrocute_mob(user, src, src))
		return 1
	else
		return 0

#undef APC_UPDATE_ICON_COOLDOWN