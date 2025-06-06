//TODO: Flash range does nothing currently

//A very crude linear approximatiaon of pythagoras theorem.
/proc/cheap_pythag(var/dx, var/dy)
	dx = abs(dx); dy = abs(dy);
	if(dx>=dy)	return dx + (0.5*dy)	//The longest side add half the shortest side approximates the hypotenuse
	else		return dy + (0.5*dx)

///// Z-Level Stuff
/proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = 1)
///// Z-Level Stuff
	src = null	//so we don't abort once src is deleted
	spawn(0)
		var/power = devastation_range * 2 + heavy_impact_range + light_impact_range //The ranges add up, ie light 14 includes both heavy 7 and devestation 3. So this calculation means devestation counts for 4, heavy for 2 and light for 1 power, giving us a cap of 27 power.
		explosion_rec(epicenter, power)
		return

///// Z-Level Stuff
		if(z_transfer && (devastation_range > 0 || heavy_impact_range > 0))
			//transfer the explosion in both directions
			explosion_z_transfer(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
///// Z-Level Stuff

		var/start = world.timeofday
		epicenter = get_turf(epicenter)
		if(!epicenter) return


		playsound(epicenter, pick('sound/effects/explosionfar.ogg','sound/effects/explosionfar2.ogg','sound/effects/explosionfar3.ogg'), 125, 1, round(devastation_range*2,1) )
		playsound(epicenter, "explosion", 100, 1, round(devastation_range,1) )
		var/datum/effect/effect/system/smoke_spread/explosion/smoke = new
		smoke.set_up(3,0, epicenter.loc, 0)
		smoke.start()
		var/close = range(world.view+round(devastation_range,1), epicenter)
		// to all distanced mobs play a different sound
		for(var/mob/M in world) if(M.z == epicenter.z) if(!(M in close))
			// check if the mob can hear
			if(M.ear_deaf <= 0 || !M.ear_deaf) if(!istype(M.loc,/turf/space))
				M << pick('sound/effects/explosionfar.ogg','sound/effects/explosionfar2.ogg','sound/effects/explosionfar3.ogg')
		if(adminlog)
			message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
			log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

//		var/lighting_controller_was_processing = lighting_controller.processing	//Pause the lighting updates for a bit
//		lighting_controller.processing = 0
		var/powernet_rebuild_was_deferred_already = defer_powernet_rebuild
		if(defer_powernet_rebuild != 2)
			defer_powernet_rebuild = 1

		if(heavy_impact_range > 1)
			var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
			E.set_up(epicenter)
			E.start()

		var/x0 = epicenter.x
		var/y0 = epicenter.y
		var/z0 = epicenter.z

		for(var/turf/T in range(epicenter, max(devastation_range, heavy_impact_range, light_impact_range)))
			var/dist = cheap_pythag(T.x - x0,T.y - y0)

			if(dist < devastation_range)		dist = 1
			else if(dist < heavy_impact_range)	dist = 2
			else if(dist < light_impact_range)	dist = 3
			else								continue

			T.ex_act(dist)
			if(T)
				for(var/atom_movable in T.contents)	//bypass type checking since only atom/movable can be contained by turfs anyway
					var/atom/movable/AM = atom_movable
					if(AM)	AM.ex_act(dist)

		var/took = (world.timeofday-start)/10
		//You need to press the DebugGame verb to see these now....they were getting annoying and we've collected a fair bit of data. Just -test- changes  to explosion code using this please so we can compare
		if(Debug2)	world.log << "## DEBUG: Explosion([x0],[y0],[z0])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [took] seconds."

		//Machines which report explosions.
		for(var/i,i<=doppler_arrays.len,i++)
			var/obj/machinery/doppler_array/Array = doppler_arrays[i]
			if(Array)
				Array.sense_explosion(x0,y0,z0,devastation_range,heavy_impact_range,light_impact_range,took)

		sleep(8)

//		if(!lighting_controller.processing)	lighting_controller.processing = lighting_controller_was_processing
		if(!powernet_rebuild_was_deferred_already)
			if(defer_powernet_rebuild != 2)
				defer_powernet_rebuild = 0

	return 1



proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		tile.ex_act(2)

///// Z-Level Stuff
proc/explosion_z_transfer(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, up = 1, down = 1)
	var/turf/controllerlocation = locate(1, 1, epicenter.z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.down)
			//start the child explosion, no admin log and no additional transfers
			explosion(locate(epicenter.x, epicenter.y, controller.down_target), max(devastation_range - 2, 0), max(heavy_impact_range - 2, 0), max(light_impact_range - 2, 0), max(flash_range - 2, 0), 0, 0)
			if(devastation_range - 2 > 0 || heavy_impact_range - 2 > 0) //only transfer further if the explosion is still big enough
				explosion(locate(epicenter.x, epicenter.y, controller.down_target), max(devastation_range - 2, 0), max(heavy_impact_range - 2, 0), max(light_impact_range - 2, 0), max(flash_range - 2, 0), 0, 1)

		if(controller.up)
			//start the child explosion, no admin log and no additional transfers
			explosion(locate(epicenter.x, epicenter.y, controller.up_target), max(devastation_range - 2, 0), max(heavy_impact_range - 2, 0), max(light_impact_range - 2, 0), max(flash_range - 2, 0), 0, 0)
			if(devastation_range - 2 > 0 || heavy_impact_range - 2 > 0) //only transfer further if the explosion is still big enough
				explosion(locate(epicenter.x, epicenter.y, controller.up_target), max(devastation_range - 2, 0), max(heavy_impact_range - 2, 0), max(light_impact_range - 2, 0), max(flash_range - 2, 0), 1, 0)
///// Z-Level Stuff
