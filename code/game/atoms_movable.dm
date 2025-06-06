/atom/movable
	layer = 3
	var/last_move = null
	var/anchored = 0
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/throwing = 0
	var/thrower
	var/turf/throw_source = null
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/mob/pulledby = null
	var/inertia_dir = 0
	appearance_flags = TILE_BOUND | PIXEL_SCALE | LONG_GLIDE
	//glide_size = 6
	var/waterproof

	var/mob/living/buckled_mob = null

	/// (DATUM) /datum/storage instance to use for this obj. Set to a type for instantiation on init.
	var/obj/item/storage/storage_ui

	var/movable_flags

/atom/movable/Bump(var/atom/A as mob|obj|turf|area, yes)
	if(src.throwing)
		src.throw_impact(A)
		src.throwing = 0

	spawn( 0 )
		if ((A && yes))
			A.last_bumped = world.time
			A.Bumped(src)
		return
	..()
	return

/atom/Destroy()
	if(reagents)
		qdel(reagents)
		reagents = null
	. = ..()

/atom/movable/Destroy()
	. = ..()
	for(var/atom/movable/AM in src)
		qdel(AM)

	forceMove(null)
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null

/atom/movable/proc/initialize()
	SHOULD_CALL_PARENT(TRUE)

	if(QDELETED(src))
		crash_with("GC: -- [type] had initialize() called after qdel() --")

/image/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW

/atom/movable/proc/entered_with_container(var/atom/old_loc)
	return

/atom/movable/proc/forceMove(atom/destination)

	if(QDELETED(src) && !QDESTROYING(src) && !isnull(destination))
		CRASH("Attempted to forceMove a QDELETED [src] out of nullspace!!!")

	if(loc == destination)
		return FALSE

	var/is_origin_turf = isturf(loc)
	var/is_destination_turf = isturf(destination)
	// It is a new area if:
	//  Both the origin and destination are turfs with different areas.
	//  When either origin or destination is a turf and the other is not.
	var/is_new_area = (is_origin_turf ^ is_destination_turf) || (is_origin_turf && is_destination_turf && loc.loc != destination.loc)

	var/atom/origin = loc
	loc = destination

	if(origin)
		origin.Exited(src, destination)
		if(is_origin_turf)
			for(var/atom/movable/AM in origin)
				AM.Uncrossed(src)
			if(is_new_area && is_origin_turf)
				origin.loc.Exited(src, destination)

	if(destination)
		destination.Entered(src, origin)
		if(is_destination_turf) // If we're entering a turf, cross all movable atoms
			for(var/atom/movable/AM in loc)
				if(AM != src)
					AM.Crossed(src)
			if(is_new_area && is_destination_turf)
				destination.loc.Entered(src, origin)

	. = TRUE

	// observ
	if(!loc && event_listeners?[/decl/observ/moved])
		raise_event_non_global(/decl/observ/moved, origin, null)
	/*
	// lighting
	if (light_source_solo)
		light_source_solo.source_atom.update_light()
	else if (light_source_multi)
		var/datum/light_source/L
		var/thing
		for (thing in light_source_multi)
			L = thing
			L.source_atom.update_light()

	if(buckled_mob)
		if(isturf(loc))
			buckled_mob.glide_size = glide_size // Setting loc apparently does animate with glide size.
			buckled_mob.forceMove(loc)
			refresh_buckled_mob(0)
		else
			unbuckle_mob()
	*/
/atom/movable/Move(...)

	var/old_loc = loc

	. = ..()

	if(.)

		/*
		if(buckled_mob)
			if(isturf(loc))
				buckled_mob.glide_size = glide_size // Setting loc apparently does animate with glide size.
				buckled_mob.forceMove(loc)
				refresh_buckled_mob(0)
			else
				unbuckle_mob()
		*/
		if(!loc && event_listeners?[/decl/observ/moved])
			raise_event_non_global(/decl/observ/moved, old_loc, null)
		/*
		// lighting
		if (light_source_solo)
			light_source_solo.source_atom.update_light()
		else if (light_source_multi)
			var/datum/light_source/L
			var/thing
			for (thing in light_source_multi)
				L = thing
				L.source_atom.update_light()

		// Z-Mimic.
		if (bound_overlay)
			// The overlay will handle cleaning itself up on non-openspace turfs.
			bound_overlay.forceMove(get_step(src, UP))
			if (bound_overlay.dir != dir)
				bound_overlay.set_dir(dir)
		else if (isturf(loc) && (!old_loc || !TURF_IS_MIMICKING(old_loc)) && MOVABLE_SHALL_MIMIC(src))
			SSzcopy.discover_movable(src)

		if(isturf(loc))
			var/turf/T = loc
			if(T.reagents?.total_volume && submerged())
				fluid_act(T.reagents)
		*/

		for(var/mob/viewer as anything in storage_ui?.is_seeing)
			if(!(viewer.s_active == src && viewer.client))
				storage_ui.close(viewer)

/atom/movable/proc/set_glide_size(glide_size_override = 0, var/min = 0.9, var/max = 32/2)
	if(!glide_size_override || glide_size_override > max)
		glide_size = 0
	else
		glide_size = max(min, glide_size_override)

/atom/movable/proc/update_client_hook(atom/destination)
	if(locate(/mob) in src)
		for(var/client/C in clients)
			if((get_turf(C.eye) == destination) && (C.mob.hud_used))
				C.update_special_views()
				C.mob.set_glide_size(glide_size)

/client/proc/update_special_views()
	return

/mob/update_client_hook(atom/destination)
	if(locate(/mob) in src)
		for(var/client/C in clients)
			if((get_turf(C.eye) == destination) && (C.mob.hud_used))
				C.update_special_views()
				C.mob.set_glide_size(glide_size)
	else if(client && hud_used)
		var/client/C = client
		C.update_special_views()

//Called whenever an object moves and by mobs when they attempt to move themselves through space
//And when an object or action applies a force on src, see newtonian_move() below
//Return 0 to have src start/keep drifting in a no-grav area and 1 to stop/not start drifting
//Mobs should return 1 if they should be able to move of their own volition, see client/Move() in mob_movement.dm
//movement_dir == 0 when stopping or any dir when trying to move
/atom/movable/proc/Process_Spacemove(var/movement_dir = 0)
	if(has_gravity(src))
		return 1

	if(pulledby)
		return 1


	if(locate(/obj/structure/catwalk) in orange(1, get_turf(src))) //Not realistic but makes pushing things in space easier
		return 1
	if(locate(/obj/structure/lattice) in orange(1, get_turf(src))) //Not realistic but makes pushing things in space easier
		return 1

	return 0

/atom/movable/proc/newtonian_move(direction) //Only moves the object if it's under no gravity

	if(!loc || Process_Spacemove(0))
		inertia_dir = 0
		return 0

	inertia_dir = direction
	if(!direction)
		return 1


	var/old_dir = dir
	. = step(src, direction)
	dir = old_dir

/atom/movable/proc/hit_check(var/speed)
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if(A == src) continue
			if(istype(A,/mob/living))
				if(A:lying) continue
				src.throw_impact(A,speed)
				if(src.throwing == 1)
					src.throwing = 0
			if(isobj(A))
				if(A.density && !A.throwpass)	// **TODO: Better behaviour for windows which are dense, but shouldn't always stop movement
					src.throw_impact(A,speed)
					src.throwing = 0


/atom/movable/proc/throw_at(atom/target, range, speed, thrower)
	if(!target || !src)
		return 0
	if(target.z != src.z)
		return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target
	src.throwing = 1
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf
	src.pixel_z = 0
	if(usr)
		if(HULK in usr.mutations)
			src.throwing = 2 // really strong throw!

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)

	var/dx
	if (target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH
	var/dist_travelled = 0
	var/dist_since_sleep = 0
	var/area/a = get_area(src.loc)
	if(dist_x > dist_y)
		var/error = dist_x/2 - dist_y



		while(src && target &&((((src.x < target.x && dx == EAST) || (src.x > target.x && dx == WEST)) && dist_travelled < range) || (a && a.has_gravity == 0)  || istype(src.loc, /turf/space)) && src.throwing && istype(src.loc, /turf))
			// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dy)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check(speed)
				error += dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dx)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check(speed)
				error -= dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			a = get_area(src.loc)
	else
		var/error = dist_y/2 - dist_x
		while(src && target &&((((src.y < target.y && dy == NORTH) || (src.y > target.y && dy == SOUTH)) && dist_travelled < range) || (a && a.has_gravity == 0)  || istype(src.loc, /turf/space)) && src.throwing && istype(src.loc, /turf))
			// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dx)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check(speed)
				error += dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dy)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check(speed)
				error -= dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)

			a = get_area(src.loc)

	//done throwing, either because it hit something or it finished moving
	if(isobj(src)) src.throw_impact(get_turf(src),speed)
	src.throwing = 0
	src.thrower = null
	src.throw_source = null
	src.loc:Entered(src)
	if(istype(src, /mob))
		playsound(src, pick('sound/webbers/fst_stone_solid_land_01.ogg', 'sound/webbers/fst_stone_solid_land_02.ogg'), 80, 1)
	if(istype(src, /obj/item))
		var/obj/item/I = src
		playsound(I, I.drop_sound, 40, 1)
	if(istype(src, /obj/item/spacecash))
		var/obj/item/spacecash/C = src

		var/path =  /obj/item/spacecash/c1
		var/divide = C.singularvalue

		switch(divide)
			if(4)
				path = /obj/item/spacecash/silver/c1

			if(16)
				path = /obj/item/spacecash/gold/c1


		for(var/x = 1; x <= (C.worth / divide); x++)
			var/obj/item/spacecash/S = new path(loc)
			S.pixel_x = rand(-12, 12)
			S.pixel_y = rand(-12, 12)

		qdel(src)

//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/movable/overlay/Destroy()
	loc = null
	master = null
	transform = null
	. = ..()

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_paw(a, b, c)
	if (src.master)
		return src.master.attack_paw(a, b, c)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

// Buckling

