/datum/shuttle
	var/called = 0
	var/timer = 10 MINUTES
	var/moving = 0
	var/location_flag = FLAG_FORTRESS
	var/launched = FALSE
	var/lordShip = null
	var/announced = FALSE

	var/obj/item/device/radio/intercom/INTERCOM = new()// BS12 EDIT Arrivals Announcement Computer, rather than the AI.

/datum/shuttle/proc/process()
	if(called && !launched)
		timer = clamp(timer-1 SECONDS, 0, 10 MINUTES)

	if(called && !launched && timer != 0) // i know its gross but i cant do anything about it!!
		switch(timer)
			if(9 MINUTES)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 9 min. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(8 MINUTES)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 8 min. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(7 MINUTES)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 7 min. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(6 MINUTES)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 6 min. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(5 MINUTES)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 5 min. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(4 MINUTES)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 4 min. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(3 MINUTES)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 3 min. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(2 MINUTES)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 2 min. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(1 MINUTES)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 1 min. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(30 SECONDS)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 30 secs. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(15 SECONDS)
				world << 'sound/machines/pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 15 secs. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")
			if(5 SECONDS)
				world << 'sound/AI/5.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 5 secs. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")

	if(timer <= 0 && !launched)
		world << 'sound/machines/pods_launched.ogg'
		world << 'sound/machines/podsfly.ogg'
		launched = TRUE
		INTERCOM.autosay("The Ulysses has been launched. The Gate has been abandoned.", "CTTU")
		move(FLAG_FORTRESS)
		addtimer(CALLBACK(src, PROC_REF(move), FLAG_INTRANSIT), 2 MINUTES, TIMER_UNIQUE | TIMER_NO_HASH_WAIT)

/datum/shuttle/proc/callshuttle()
	called = 1
	if(!lordShip)
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.job == "Baron")
				var/regex/R = regex("(^\\S+) (.*$)")
				R.Find(H.real_name)
				var/second_name = R.group[2]
				lordShip = second_name
	if(world.time >= 60 MINUTES)
		timer = 5 MINUTES
	var/timermin = round(emergency_shuttle.timeleft()/60)
	world << sound('sound/AI/shuttlecalled.ogg')
	to_chat(world, "<span class='passivebold'>Warning: \"Ulysses\" will be launched in T - [timermin] minutes.</span>")
	INTERCOM.autosay("The Fortress will be abandoned in T - [timermin] min. His Lordship baron [lordShip] and his confidants are awaited on the Ulysses.", "CTTU")

/datum/shuttle/proc/recall()
	timer = 10 MINUTES
	called = 0
	world << sound('sound/AI/shuttlerecalled.ogg')
	to_chat(world, "<span class='passivebold'>Warning: The launch was canceled.")

/datum/shuttle/proc/move(location_flag)
	if(moving)
		return
	moving = 1

	if(location_flag & FLAG_FORTRESS)
		//TRANSIT

		//main shuttle
		var/area/start_location = locate(/area/shuttle/escape/station)
		var/area/end_location = locate(/area/shuttle/escape/transit)

		start_location.move_contents_to(end_location, TRUE)

		for(var/obj/machinery/door/unpowered/shuttle/D in end_location)
			ASYNC
				D.locked = TRUE
				D.close()

		for(var/mob/M in end_location)
			if(M.client)
				ASYNC
					if(M.buckled)
						shake_camera(M, 4, 1) // buckled, not a lot of shaking
					else
						shake_camera(M, 10, 2) // unbuckled, HOLY SHIT SHAKE THE ROOM
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.buckled && istype(H.buckled, /obj/structure/stool/bed/chair/comfy/babylon))
					var/obj/structure/stool/bed/chair/comfy/babylon/B = H.buckled
					if(!B.locked)
						B.unbuckle()
				if(!H.buckled)
					H.visible_message("<span class='warning'>[M.name] is tossed around by the sudden acceleration!</span>")
					var/smashsound = pick("sound/effects/gore/smash[rand(1,3)].ogg", "sound/effects/gore/trauma1.ogg")
					playsound(M, smashsound, 80, 1, -1)
					H.emote("scream")
					H.Stun(5)
					H.Weaken(5)
					step(H,pick(cardinal))//move them
					H.apply_damage(rand(70) , BRUTE)

		moving = 0
		location_flag = FLAG_INTRANSIT
		return

	if(location_flag & FLAG_INTRANSIT)
		//main shuttle
		var/area/start_location = locate(/area/shuttle/escape/transit)
		var/area/end_location = locate(/area/shuttle/escape/centcom)

		start_location.move_contents_to(end_location, TRUE)

		for(var/obj/machinery/door/unpowered/shuttle/D in end_location)
			ASYNC
				D.locked = FALSE
				D.open()

		for(var/mob/M in end_location)
			if(M.client)
				ASYNC
					if(M.buckled)
						shake_camera(M, 4, 1) // buckled, not a lot of shaking
					else
						shake_camera(M, 10, 2) // unbuckled, HOLY SHIT SHAKE THE ROOM
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.buckled && istype(H.buckled, /obj/structure/stool/bed/chair/comfy/babylon))
					var/obj/structure/stool/bed/chair/comfy/babylon/B = H.buckled
					if(!B.locked)
						B.unbuckle()
				if(!H.buckled)
					H.visible_message("<span class='warning'>[M.name] is tossed around by the sudden acceleration!</span>")
					var/smashsound = pick("sound/effects/gore/smash[rand(1,3)].ogg", "sound/effects/gore/trauma1.ogg")
					playsound(M, smashsound, 80, 1, -1)
					H.emote("scream")
					H.Stun(5)
					H.Weaken(5)
					step(H,pick(cardinal))//move them
					H.apply_damage(rand(70) , BRUTE)

		moving = 0
		location_flag = FLAG_LEVIATHAN
		//a.autosay("The Charon have docked within the Leviathan.", "Ulysses Console")
		return

/mob/verb/changeTimer()
	var/datum/shuttle/elevador = shuttleMain
	elevador.timer = 35 SECONDS

/obj/structure/babylon
	icon = 'icons/life/floors.dmi'
	var/enumeracao = "MainElevator"
	layer = 2.1
	anchored = 1


/obj/structure/babylon/floor
	opacity = 0
	density = 0
/obj/structure/babylon/wall
	icon = 'icons/turf/walls.dmi'
	opacity = 1
	density = 1
	plane = 21
	layer = 5
