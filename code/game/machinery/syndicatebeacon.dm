//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

#define SCREWED 32

/obj/machinery/singularity_beacon //not the best place for it but it's a hack job anyway -- Urist
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "beacon"

	anchored = 0
	density = 1
	layer = MOB_LAYER - 0.1 //so people can't hide it and it's REALLY OBVIOUS
	stat = 0

	var/active = 0 //It doesn't use up power, so use_power wouldn't really suit it
	var/icontype = "beacon"
	var/obj/structure/cable/attached = null


	proc/Activate(mob/user = null)
		if(!checkWirePower())
			if(user) user << "\blue The connected wire doesn't have enough current."
			return
		for(var/obj/machinery/singularity/singulo in world)
			if(singulo.z == z)
				singulo.target = src
		icon_state = "[icontype]1"
		active = 1
		if(user) user << "\blue You activate the beacon."


	proc/Deactivate(mob/user = null)
		for(var/obj/machinery/singularity/singulo in world)
			if(singulo.target == src)
				singulo.target = null
		icon_state = "[icontype]0"
		active = 0
		if(user) user << "\blue You deactivate the beacon."


	attack_ai(mob/user as mob)
		return


	attack_hand(var/mob/user as mob)
		if(stat & SCREWED)
			return active ? Deactivate(user) : Activate(user)
		else
			user << "\red You need to screw the beacon to the floor first!"
			return


	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W,/obj/item/screwdriver))
			if(active)
				user << "\red You need to deactivate the beacon first!"
				return

			if(stat & SCREWED)
				stat &= ~SCREWED
				anchored = 0
				user << "\blue You unscrew the beacon from the floor."
				attached = null
				return
			else
				var/turf/T = loc
				if(isturf(T) && !T.intact)
					attached = locate() in T
				if(!attached)
					user << "This device must be placed over an exposed cable."
					return
				stat |= SCREWED
				anchored = 1
				user << "\blue You screw the beacon to the floor and attach the cable."
				return
		..()
		return


	Del()
		if(active) Deactivate()
		..()

	/*
	* Added for a simple way to check power. Verifies that the beacon
	* is connected to a wire, the wire is part of a powernet (that part's
	* sort of redundant, since all wires either join or create one when placed)
	* and that the powernet has at least 1500 power units available for use.
	* Doesn't use them, though, just makes sure they're there.
	* - QualityVan, Aug 11 2012
	*/
	proc/checkWirePower()
		if(!attached)
			return 0
		var/datum/powernet/PN = attached.get_powernet()
		if(!PN)
			return 0
		if(PN.avail < 1500)
			return 0
		return 1

	process()
		if(!active)
			return
		else
			if(!checkWirePower())
				Deactivate()
		return


/obj/machinery/singularity_beacon/syndicate
	icontype = "beaconsynd"
	icon_state = "beaconsynd0"

#undef SCREWED

