/turf
	icon = 'icons/turf/floors.dmi'
	level = 1.0

	//for floors, use is_plating(), is_plasteel_floor() and is_light_floor()
	var/intact = 1
	var/movement_delay
	var/glidesize = 8
	//Properties for open tiles (/floor)
	var/oxygen = 0
	var/carbon_dioxide = 0
	var/nitrogen = 0
	var/plasma = 0

	var/smokeAmount = 0

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both

	var/blocks_air = 0
	var/icon_old = null
	var/pathweight = 1

	// Decal shit.
	var/list/decals
	var/burnAble = 1 // Able to make fire on it

	var/turf_flags

	var/tmp/changing_turf
	var/tmp/prev_type // Previous type of the turf, prior to turf translation.

	///Whether this tile is willing to copy air from a previous tile through ChangeTurf, transfer_turf_properties etc.
	var/can_inherit_air = TRUE

	var/zone/zone
	var/open_directions

var/list/turfs = list()

/turf/New()
	. = ..()
	for(var/atom/movable/AM as mob|obj in src)
		spawn( 0 )
			src.Entered(AM)
			return

	turfs |= src

/turf/Destroy()
	turfs -= src
	..()
	return QDEL_HINT_IWILLGC

/turf/ex_act(severity)
	return 0

/turf/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj ,/obj/item/projectile/beam/pulse))
		src.ex_act(2)
	..()
	return 0

/turf/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj ,/obj/item/projectile/bullet/gyro))
		explosion(src, -1, 0, 2)
	..()
	return 0

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if (!mover || !isturf(mover.loc))
		return 1

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if(!(obstacle.flags & ON_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(obstacle.flags & ~ON_BORDER)
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return 0
	return 1 //Nothing found to block so return success!

/*
/turf/Entered(atom/atom as mob|obj)
	..()
//vvvvv Infared beam stuff vvvvv

	if ((atom && atom.density && !( istype(atom, /obj/effect/beam) )))
		for(var/obj/effect/beam/i_beam/I in src)
			spawn( 0 )
				if (I)
					I.hit()
				break

//^^^^^ Infared beam stuff ^^^^^

	if(!istype(atom, /atom/movable))
		return

	var/atom/movable/M = atom

	var/loopsanity = 100
	if(ismob(M))
		var/mob/O = M
		if(!O.lastarea)
			O.lastarea = get_area(O.loc)
		var/has_gravity = O.mob_has_gravity(src)
		O.update_gravity(has_gravity)
		if(!has_gravity)
			inertial_drift(O)
		else if(!istype(src, /turf/space))
			O.inertia_dir = 0

	/*
		if(M.flags & NOGRAV)
			inertial_drift(M)
	*/



		else if(!istype(src, /turf/space))
			M:inertia_dir = 0
	..()
	var/objects = 0
	for(var/atom/A as mob|obj|turf|area in src)
		if(objects > loopsanity)	break
		objects++
		spawn( 0 )
			if ((A && M))
				A.Crossed(M, 1)
			return
	objects = 0
	for(var/atom/A as mob|obj|turf|area in range(1))
		if(objects > loopsanity)	break
		objects++
		spawn( 0 )
			if ((A && M))
				A.HasProximity(M, 1)
			return
	return
*/
/mob/var/gruemessage = FALSE
/turf/proc/get_lumcount()
	for(var/atom/movable/lighting_overlay/L in src)
		if(L)
			return L.lum_r + L.lum_g + L.lum_b

/turf/proc/grueCheck(var/mob/M)
	if(isliving(M))
		if(!luminosity)
			if(!M.gruemessage)
				to_chat(M, "It's pitch black. you're likely to be eaten by a grue.")
				M.gruemessage = TRUE
		else
			if(!luminosity)
				M.gruemessage = FALSE


/turf/Entered(atom/atom as mob|obj)
    ..()
    if(!istype(atom, /atom/movable))
        return

    var/atom/movable/A = atom

    var/loopsanity = 100
    if(ismob(A))
        var/mob/M = A
        grueCheck(M)
        if(!M.lastarea)
            M.lastarea = get_area(M.loc)
        if(M.lastarea.has_gravity == 0)
            inertial_drift(M)

        else if(!istype(src, /turf/space))
            M.inertia_dir = 0
    ..()

    var/objects = 0
    for(var/atom/O as mob|obj|turf|area in range(1))
        if(objects > loopsanity)    break
        objects++
        spawn( 0 )
            if ((O && A))
                O.HasProximity(A, 1)
            return
    return



/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return 0
/turf/proc/is_asteroid_floor()
	return 0
/turf/proc/is_plasteel_floor()
	return 0
/turf/proc/is_light_floor()
	return 0
/turf/proc/is_grass_floor()
	return 0
/turf/proc/is_wood_floor()
	return 0
/turf/proc/is_carpet_floor()
	return 0
/turf/proc/is_underplating()
	return 0
/turf/proc/return_siding_icon_state()		//used for grass floors, which have siding.
	return 0

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(!(A.last_move))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.Process_Spacemove(1))
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && !(M.pulledby) && (M.loc == src)))
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir)
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(src.intact)

// override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)

/turf/proc/ChangeTurf(var/turf/N, var/tell_universe = TRUE, var/force_lighting_update = FALSE, var/keep_air = FALSE, var/update_open_turfs_above = TRUE, var/keep_height = FALSE)

	if (!N)
		return

	//if (!(atom_flags & ATOM_FLAG_INITIALIZED))
	//	return new N(src)

	// Track a number of old values for the purposes of raising
	// state change events after changing the turf to the new type.
	var/old_fire =             fire
	var/old_opacity =          opacity
	var/old_prev_type =        prev_type
	var/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/old_dynamic_lighting = src:dynamic_lighting
	var/old_event_listeners =  event_listeners
	var/old_listening_to =     _listening_to

	if(connections)
		connections.erase_all()

	overlays.Cut()
	underlays.Cut()

	if(turf_is_simulated(src))
		//Yeah, we're just going to rebuild the whole thing.
		//Despite this being called a bunch during explosions,
		//the zone will only really do heavy lifting once.
		var/turf/simulated/S = src
		if(S?.zone)
			S.zone.rebuild()


	if(istype(src, /turf/simulated/floor/open))
		src.vis_contents.Cut()
		global.global_openspace -= src

	if(istype(src, /turf/simulated/floor/plating/catwalk) || istype(src, /obj/structure/catwalk))
		src.vis_contents.Cut()

	// Create a copy of the old air value to apply.
	var/datum/gas_mixture/old_air
	if(keep_air)
		var/turf/simulated/S = src
		// Bypass calling return_air to avoid creating a direct reference to zone air.
		if(zone)
			S.c_copy_air()
			old_air = air
		else
			old_air = S.return_air()

	changing_turf = TRUE

	qdel(src)
	. = new N(src)

	var/turf/changed_turf = .
	changed_turf.prev_type =        old_prev_type // Shuttle transition turf tracking.
	// Set our observation bookkeeping lists back.
	changed_turf.event_listeners =  old_event_listeners
	changed_turf._listening_to =    old_listening_to

	// Update ZAS, atmos and fire.
	if(keep_air && changed_turf.can_inherit_air)
		changed_turf.air = old_air

	if(turf_is_simulated(changed_turf))
		if(old_fire)
			changed_turf.fire = old_fire
			qdel(old_fire)
		if(istype(src, /turf/simulated/floor))
			changed_turf.RemoveLattice()
	if(air_master)
		air_master.mark_for_update(src) //handle the addition of the new turf.

	// Raise appropriate events.
	changed_turf.post_change()
	//if(tell_universe)
	//	global.universe.OnTurfChange(changed_turf)

	//if(changed_turf.density != old_density && changed_turf.event_listeners?[/decl/observ/density_set])
	//	changed_turf.raise_event_non_global(/decl/observ/density_set, old_density, changed_turf.density)

	// lighting stuff

	lighting_overlay = old_lighting_overlay
	if(lighting_overlay)
		lighting_overlay.update_overlay()
	affecting_lights = old_affecting_lights
	if((old_opacity != opacity) || (dynamic_lighting != old_dynamic_lighting) || force_lighting_update)
		reconsider_lights()
	if(dynamic_lighting != old_dynamic_lighting)
		if(dynamic_lighting)
			lighting_build_overlays()
		else
			lighting_clear_overlays()

	// end of lighting stuff
	changed_turf.levelupdate()

/turf/proc/AddDecal(const/image/decal)
	if(!decals)
		decals = new

	decals += decal
	overlays += decal

/turf/proc/ClearDecals()
	if(!decals)
		return

	for(var/image/decal in decals)
		overlays -= decal

	decals = 0

//Commented out by SkyMarshal 5/10/13 - If you are patching up space, it should be vacuum.
//  If you are replacing a wall, you have increased the volume of the room without increasing the amount of gas in it.
//  As such, this will no longer be used.

//////Assimilate Air//////
/*
/turf/simulated/proc/Assimilate_Air()
	var/aoxy = 0//Holders to assimilate air from nearby turfs
	var/anitro = 0
	var/aco = 0
	var/atox = 0
	var/atemp = 0
	var/turf_count = 0

	for(var/direction in cardinal)//Only use cardinals to cut down on lag
		var/turf/T = get_step(src,direction)
		if(istype(T,/turf/space))//Counted as no air
			turf_count++//Considered a valid turf for air calcs
			continue
		else if(istype(T,/turf/simulated/floor))
			var/turf/simulated/S = T
			if(S.air)//Add the air's contents to the holders
				aoxy += S.air.oxygen
				anitro += S.air.nitrogen
				aco += S.air.carbon_dioxide
				atox += S.air.toxins
				atemp += S.air.temperature
			turf_count ++
	air.oxygen = (aoxy/max(turf_count,1))//Averages contents of the turfs, ignoring walls and the like
	air.nitrogen = (anitro/max(turf_count,1))
	air.carbon_dioxide = (aco/max(turf_count,1))
	air.toxins = (atox/max(turf_count,1))
	air.temperature = (atemp/max(turf_count,1))//Trace gases can get bant
	air.update_values()

	//cael - duplicate the averaged values across adjacent turfs to enforce a seamless atmos change
	for(var/direction in cardinal)//Only use cardinals to cut down on lag
		var/turf/T = get_step(src,direction)
		if(istype(T,/turf/space))//Counted as no air
			continue
		else if(istype(T,/turf/simulated/floor))
			var/turf/simulated/S = T
			if(S.air)//Add the air's contents to the holders
				S.air.oxygen = air.oxygen
				S.air.nitrogen = air.nitrogen
				S.air.carbon_dioxide = air.carbon_dioxide
				S.air.toxins = air.toxins
				S.air.temperature = air.temperature
				S.air.update_values()
*/


/turf/proc/ReplaceWithLattice()
	src.ChangeTurf(/turf/space)
	new /obj/structure/lattice( locate(src.x, src.y, src.z) )

/turf/proc/kill_creatures(mob/U = null)//Will kill people/creatures and damage mechs./N
//Useful to batch-add creatures to the list.
	for(var/mob/living/M in src)
		if(M==U)	continue//Will not harm U. Since null != M, can be excluded to kill everyone.
		spawn(0)
			M.gib()
	for(var/obj/mecha/M in src)//Mecha are not gibbed but are damaged.
		spawn(0)
			M.take_damage(100, "brute")

/turf/proc/Bless()
	if(flags & NOJAUNT)
		return
	flags |= NOJAUNT

/turf/proc/AdjacentTurfs()
	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/Distance(turf/t)
	if(!src || !t)
		return 1e31
	t = get_turf(t)
	if(get_dist(src, t) == 1 || src.z != t.z)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y) + (src.z - t.z) * (src.z - t.z) * 3
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/handle_fall(mob/faller, forced)
	if(istype(faller, /turf))
		return
	faller.lying = 90
	faller.update_transform()
	if(!forced)
		return
	if(has_gravity(src))
		visible_message("<span class='passivebold'>[faller]</span> <span class='passive'>falls over.</span>")
		playsound(src, "bodyfall", 50, 1)

/turf/handle_slip(mob/slipper, s_amount, w_amount, obj/O, lube)
	if(has_gravity(src))
		var/mob/living/carbon/M = slipper
		if (M.m_intent=="walk" && (lube&NO_SLIP_WHEN_WALKING))
			return 0
		if(!M.lying && !M.resting && (M.status_flags & CANWEAKEN)) // we slip those who are standing and can fall.
			var/olddir = M.dir
			M.Stun(s_amount)
			M.Weaken(w_amount)
			M.stop_pulling()
			if(lube&SLIDE)
				for(var/i=1, i<5, i++)
					spawn (i)
						step(M, olddir)
						M.spin(1,1)
				if(M.lying) //did I fall over?
					M.adjustBruteLoss(2)
			if(O)
				to_chat(M, "<span class='notice'>You slipped on the [O.name]!</span>")
			else
				to_chat(M, "<span class='notice'>You slipped!</span>")
			playsound(M.loc, 'sound/misc/slip.ogg', 50, 1, -3)
			return 1
	return 0 // no success. Used in clown pda and wet floors

/turf/proc/contains_dense_objects(list/exceptions)
	if(density)
		return TRUE
	for(var/atom/A in src)
		if(exceptions && (exceptions == A || (islist(exceptions) && (A in exceptions))))
			continue
		if(A.density && !(A.flags & ON_BORDER))
			return TRUE
	return FALSE

/turf/proc/is_solid_structure()
	return !(turf_flags & TURF_FLAG_BACKGROUND) || locate(/obj/structure/lattice, src)

// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()