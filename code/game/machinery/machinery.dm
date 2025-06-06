/*
Overview:
   Used to create objects that need a per step proc call.  Default definition of 'New()'
   stores a reference to src machine in global 'machines list'.  Default definition
   of 'Del' removes reference to src machine in global 'machines list'.

Class Variables:
   use_power (num)
      current state of auto power use.
      Possible Values:
         0 -- no auto power use
         1 -- machine is using power at its idle power level
         2 -- machine is using power at its active power level

   active_power_usage (num)
      Value for the amount of power to use when in active power mode

   idle_power_usage (num)
      Value for the amount of power to use when in idle power mode

   power_channel (num)
      What channel to draw from when drawing power for power mode
      Possible Values:
         EQUIP:0 -- Equipment Channel
         LIGHT:2 -- Lighting Channel
         ENVIRON:3 -- Environment Channel

   component_parts (list)
      A list of component parts of machine used by frame based machines.

   uid (num)
      Unique id of machine across all machines.

   gl_uid (global num)
      Next uid value in sequence

   stat (bitflag)
      Machine status bit flags.
      Possible bit flags:
         BROKEN:1 -- Machine is broken
         NOPOWER:2 -- No power is being supplied to machine.
         POWEROFF:4 -- tbd
         MAINT:8 -- machine is currently under going maintenance.
         EMPED:16 -- temporary broken by EMP pulse

   manual (num)
      Currently unused.

Class Procs:
   New()                     'game/machinery/machine.dm'

   Destroy()                     'game/machinery/machine.dm'

   auto_use_power()            'game/machinery/machine.dm'
      This proc determines how power mode power is deducted by the machine.
      'auto_use_power()' is called by the 'master_controller' game_controller every
      tick.

      Return Value:
         return:1 -- if object is powered
         return:0 -- if object is not powered.

      Default definition uses 'use_power', 'power_channel', 'active_power_usage',
      'idle_power_usage', 'powered()', and 'use_power()' implement behavior.

   powered(chan = EQUIP)         'modules/power/power.dm'
      Checks to see if area that contains the object has power available for power
      channel given in 'chan'.

   use_power(amount, chan=EQUIP)   'modules/power/power.dm'
      Deducts 'amount' from the power channel 'chan' of the area that contains the object.

   power_change()               'modules/power/power.dm'
      Called by the area that contains the object when ever that area under goes a
      power state change (area runs out of power, or area channel is turned off).

   RefreshParts()               'game/machinery/machine.dm'
      Called to refresh the variables in the machine that are contributed to by parts
      contained in the component_parts list. (example: glass and material amounts for
      the autolathe)

      Default definition does nothing.

   assign_uid()               'game/machinery/machine.dm'
      Called by machine to assign a value to the uid variable.

   process()                  'game/machinery/machine.dm'
      Called by the 'master_controller' once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/

/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	var/stat = 0
	var/emagged = 0
	var/use_power = 1
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/power_channel = EQUIP
		//EQUIP,ENVIRON or LIGHT
	var/list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.
	var/uid
	var/manual = 0
	var/global/gl_uid = 1

	var/panel_open = 0
	var/state_open = 0
	var/mob/living/occupant = null
	var/unsecuring_tool = /obj/item/wrench
	var/last_notice = 0

	/// Can the machine be interacted with while de-powered.
	var/interact_offline = FALSE

/obj/machinery/New()
	. = ..()
	machines += src

/obj/machinery/Destroy()
	machines -= src
	return ..()

/obj/machinery/process()//If you dont use process or power why are you here
	return PROCESS_KILL

/obj/machinery/emp_act(severity)
	if(use_power && stat == 0)
		use_power(7500/severity)

		var/obj/effect/overlay/pulse2 = new/obj/effect/overlay ( src.loc )
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.dir = pick(cardinal)

		spawn(10)
			qdel(pulse2)
	..()

/obj/machinery/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				qdel(src)
				return
		else
	return

//sets the use_power var and then forces an area power update
/obj/machinery/proc/update_use_power(var/new_use_power, var/force_update = 0)
	if ((new_use_power == use_power) && !force_update)
		return	//don't need to do anything

	use_power = new_use_power

	//force area power update
	force_power_update()

/obj/machinery/proc/force_power_update()
	var/area/A = get_area(src)
	if(A && A.master)
		A.master.powerupdate = 1


/obj/machinery/proc/auto_use_power()
	if(!powered(power_channel))
		return 0
	if(src.use_power == 1)
		use_power(idle_power_usage,power_channel)
	else if(src.use_power >= 2)
		use_power(active_power_usage,power_channel)
	return 1

/obj/machinery/CanUseTopic(var/mob/user)
	if(stat & BROKEN)
		return STATUS_CLOSE

	if(!interact_offline && (stat & NOPOWER))
		return STATUS_CLOSE

	if(user.direct_machine_interface(src))
		return ..()

	if(stat & NOSCREEN)
		return STATUS_CLOSE

	if(stat & NOINPUT)
		return min(..(), STATUS_UPDATE)
	return ..()

/mob/proc/direct_machine_interface(obj/machinery/machine)
	return FALSE

/mob/living/silicon/direct_machine_interface(obj/machinery/machine)
	return TRUE

/mob/observer/ghost/direct_machine_interface(obj/machinery/machine)
	return TRUE

/obj/machinery/CanUseTopicPhysical(var/mob/user)
	if((stat & BROKEN)) // && (reason_broken & MACHINE_BROKEN_GENERIC))
		return STATUS_CLOSE

	return global.physical_topic_state.can_use_topic(nano_host(), user)

/obj/machinery/CouldUseTopic(var/mob/user)
	..()
	user.set_machine(src)
	//if(clicksound && isliving(user))
	//	playsound(src, clicksound, clickvol)

/obj/machinery/CouldNotUseTopic(var/mob/user)
	user.unset_machine()

/obj/machinery/Topic(href, href_list, datum/topic_state/state)
	. = ..()
	if(. == TOPIC_REFRESH)
		updateUsrDialog() // Update legacy UIs to the extent possible.
		nanomanager.update_uis(src) // And our modern NanoUI ones, too.
		update_icon() // A lot of machines like to do icon updates on refresh, so we'll handle it for them here.
	else if(. == TOPIC_CLOSE)
		usr.unset_machine()
		var/datum/nanoui/open_ui = nanomanager.get_open_ui(usr, src, "main")
		if(open_ui)
			open_ui.close()


/obj/machinery/attack_ai(mob/living/silicon/ai/user)
	if(CanUseTopic(user, DefaultTopicState()) > STATUS_CLOSE)
		return interface_interact(user)

/obj/machinery/attack_robot(mob/user)
	if((. = attack_hand(user))) // This will make a physical proximity check, and allow them to deal with components and such.
		return
	if(CanUseTopic(user, DefaultTopicState()) > STATUS_CLOSE)
		return interface_interact(user) // This may still work even if the physical checks fail.

// After a recent rework this should mostly be safe.
/obj/machinery/attack_ghost(mob/user)
	interface_interact(user)

// If you don't call parent in this proc, you must make all appropriate checks yourself.
// If you do, you must respect the return value.
/obj/machinery/attack_hand(mob/user)
	if((. = ..())) // Buckling, climbers; unlikely to return true.
		return
	if(!CanPhysicallyInteract(user))
		return FALSE // The interactions below all assume physical access to the machine. If this is not the case, we let the machine take further action.
	//if(!user.check_dexterity(required_interaction_dexterity))
	//	return TRUE
	//if((. = component_attack_hand(user)))
	//	return
	//if(wires && (. = wires.Interact(user)))
	//	return
	if((. = physical_attack_hand(user)))
		return
	if(CanUseTopic(user, DefaultTopicState()) > STATUS_CLOSE)
		return interface_interact(user)

// If you want to have interface interactions handled for you conveniently, use this.
// Return TRUE for handled.
// If you perform direct interactions in here, you are responsible for ensuring that full interactivity checks have been made (i.e CanInteract).
// The checks leading in to here only guarantee that the user should be able to view a UI.
/obj/machinery/proc/interface_interact(user)
	return FALSE

// If you want a physical interaction which happens after all relevant checks but preempts the UI interactions, do it here.
// Return TRUE for handled.
/obj/machinery/proc/physical_attack_hand(user)
	return FALSE

/obj/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/machinery/proc/ping(text=null)
  if (!text)
    text = "\The [src] pings."

  state(text, "blue")
  playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)



/obj/machinery/proc/is_operational()
	return !(stat & (NOPOWER|BROKEN|MAINT))

/obj/machinery/proc/default_pry_open(var/obj/item/crowbar/C)
	. = !(state_open || panel_open || is_operational()) && istype(C)
	if(.)
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		visible_message("<span class = 'notice'>[usr] pry open \the [src].</span>", "<span class = 'notice'>You pry open \the [src].</span>")
		open_machine()
		return 1

/obj/machinery/proc/default_deconstruction_crowbar(var/obj/item/crowbar/C, var/ignore_panel = 0)
	. = istype(C) && (panel_open || ignore_panel)
	if(.)
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
		M.state = 2
		M.icon_state = "box_1"
		for(var/obj/item/I in component_parts)
			if(I.reliability != 100 && crit_fail)
				I.crit_fail = 1
			I.loc = src.loc
		qdel(src)

/obj/machinery/proc/default_deconstruction_screwdriver(var/mob/user, var/icon_state_open, var/icon_state_closed, var/obj/item/screwdriver/S)
	if(istype(S))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(!panel_open)
			panel_open = 1
			icon_state = icon_state_open
			user << "<span class='notice'>You open the maintenance hatch of [src].</span>"
		else
			panel_open = 0
			icon_state = icon_state_closed
			user << "<span class='notice'>You close the maintenance hatch of [src].</span>"
		return 1
	return 0

/obj/machinery/proc/default_change_direction_wrench(var/mob/user, var/obj/item/wrench/W)
	if(panel_open && istype(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		dir = turn(dir,-90)
		user << "<span class='notice'>You rotate [src].</span>"
		return 1
	return 0

/obj/machinery/proc/default_unfasten_wrench(mob/user, obj/item/wrench/W, time = 20)
	if(istype(W))
		user << "<span class='notice'>Now [anchored ? "un" : ""]securing [name].</span>"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, time))
			user << "<span class='notice'>You've [anchored ? "un" : ""]secured [name].</span>"
			anchored = !anchored
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		return 1
	return 0

/obj/machinery/proc/exchange_parts(mob/user, var/obj/item/storage/part_replacer/W)
	var/shouldplaysound = 0
	if(istype(W) && component_parts)
		if(panel_open)
			var/obj/item/circuitboard/CB = locate(/obj/item/circuitboard) in component_parts
			var/P
			for(var/obj/item/stock_parts/A in component_parts)
				for(var/D in CB.req_components)
					if(ispath(A.type, D))
						P = D
						break
				for(var/obj/item/stock_parts/B in W.contents)
					if(istype(B, P) && istype(A, P))
						if(B.rating > A.rating)
							W.remove_from_storage(B, src)
							W.handle_item_insertion(A, 1)
							component_parts -= A
							component_parts += B
							B.loc = null
							user << "<span class='notice'>[A.name] replaced with [B.name].</span>"
							shouldplaysound = 1 //Only play the sound when parts are actually replaced!
							break
			RefreshParts()
			if(shouldplaysound)
				W.play_rped_sound()
		else
			user << "<span class='notice'>Following parts detected in the machine:</span>"
			for(var/obj/item/C in component_parts)
				user << "<span class='notice'>    [C.name]</span>"
		return 1
	return 0


//called on machinery construction (i.e from frame to machinery) but not on initialization
/obj/machinery/proc/construction()
	return


/obj/machinery/proc/open_machine()
	state_open = 1
	density = 0
	dropContents()
	update_icon()
	updateUsrDialog()

/obj/machinery/proc/dropContents()
	var/turf/T = get_turf(src)
	T.contents += contents
	if(occupant)
		if(occupant.client)
			occupant.client.eye = occupant
			occupant.client.perspective = MOB_PERSPECTIVE
		occupant = null

/obj/machinery/proc/close_machine(mob/living/target = null)
	state_open = 0
	density = 1
	if(!target)
		for(var/mob/living/carbon/C in loc)
			if(C.buckled)
				continue
			else
				target = C
	if(target)
		if(target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = src
		occupant = target
		target.loc = src
		target.stop_pulling()
	updateUsrDialog()
	update_icon()

/obj/machinery/proc/ai_notice(var/message, var/obj/machinery/machine, var/style)
	if(!machine || !message || !machine && !message)
		return
	if (last_notice && world.time < last_notice + 16) // stop spam or no
		return
	var/mob/living/silicon/ai/AI = usr
	if(!near_camera(machine))   // check machine on camera
		return
	var/list/style_list = list("warning", "info", "notice")
	if(style == null || !style in style_list)  // check styles
		style = "info"
	for(AI in living_mob_list)
		AI << "<span class='[style]'><b><a href='byond://?src=\ref[AI];track2=\ref[AI];jumptomachine=\ref[machine]'>[machine]</a> [pick("reports", "inform", "communicate", "data", "pings")] </b> - \"[message].\"</span>"
	last_notice = world.time
	return

/obj/machinery/CanUseTopicPhysical(var/mob/user)
	if((stat & BROKEN)) //&& (reason_broken & MACHINE_BROKEN_GENERIC))
		return STATUS_CLOSE

	return global.physical_topic_state.can_use_topic(nano_host(), user)

/obj/machinery/CouldUseTopic(var/mob/user)
	..()
	user.set_machine(src)
	//if(clicksound && isliving(user))
	//	playsound(src, clicksound, clickvol)

/obj/machinery/CouldNotUseTopic(var/mob/user)
	user.unset_machine()