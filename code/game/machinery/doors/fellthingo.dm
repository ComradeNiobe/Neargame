var/global/list/keep_trap_doors = list()
var/global/list/gate_trap_doors = list()

/obj/machinery/door/airlock/orbital/gates/magma/trap_door
	name = "trap door"
	desc = "WATCHA WATCHA WATCHA OOOOOOOOOO!!"
	icon = 'icons/life/autodoor.dmi'
	plane = 0

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/keep
	name = "trap door"
	desc = "WATCHA WATCHA WATCHA OOOOOOOOOO!!"
	icon = 'icons/life/autodoor.dmi'
	plane = 0

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/gate
	name = "trap door"
	desc = "WATCHA WATCHA WATCHA OOOOOOOOOO!!"
	icon = 'icons/life/escotilha.dmi'
	plane = 0

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/RightClick()
	return 0

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/proc/toggle()
	if(fechado == FALSE)
		close()
	else
		open()

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/open(mob/living/carbon/human/H as mob)
	fechado = 0
	blocksOpenFalling = 0
	playsound(src.loc, 'sound/lfwbsounds/lava_open.ogg', 30, 1)
	flick("door_opening", src)
	spawn(10)
		icon_state = "door_open"
	for(H in src.loc)
		if(istype(H.loc, /turf/simulated/floor/open))
			if(H.bridged) return
			var/turf/simulated/floor/open/O = H.loc
			var/floorbeloww = O.floorbelow
			H.visible_message("<span class='bname'>[H.name]</span> falls!")
			H.Move(floorbeloww)
			var/is_client_moving = (ismob(H) && H.client && H.client.moving)
			spawn(0)
				if(is_client_moving) H.client.moving = 1
				handle_fall(floorbeloww)
				if(is_client_moving) H.client.moving = 0
			var/damage = 10
			H.apply_damage(rand(0,damage), BRUTE, "groin")
			if(H.special == "notafraid")
				to_chat(H, "You land soflty.")
			else
				H.apply_damage(damage/2 + rand(-5,12), BRUTE, "l_leg")
				H.apply_damage(damage/2 + rand(-5,12), BRUTE, "r_leg")
				H.apply_damage(damage + rand(-5,12), BRUTE, "l_foot")
				H.apply_damage(damage + rand(-5,12), BRUTE, "r_foot")
				H:weakened = max(H:weakened,4)
				if(prob(70))
					H.emote("fallscream",1)
				if(prob(40))
					var/time = rand(2, 6)
					H.Stun(time)
					playsound(H.loc, 'sound/effects/fallsmash.ogg', 50, 0)//Splat
					H:updatehealth()




		return

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/close()
	fechado = 1
	blocksOpenFalling = 1
	playsound(src.loc, 'sound/lfwbsounds/lava_close.ogg', 30, 1)
	flick("door_closing", src)
	spawn(10)
		icon_state = "door_closed"

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/Crossed(mob/living/carbon/human/M as mob|obj)
	if(!fechado && icon_state == "door_open")
		for(M in src.loc)
			if(istype(M.loc, /turf/simulated/floor/open))
				var/turf/simulated/floor/open/O = M.loc
				O.Enter(M)
			return

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/New()
	opacity = 0
	processing_objects.Add(src)
	density = 0
	fechado = 1
	layer = 2
	icon_state = "door_closed"
	close()

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/keep/New()
	. = ..()
	global.keep_trap_doors |= src

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/gate/New()
	. = ..()
	global.gate_trap_doors |= src