///////////////////////////////////////
//Contents: Ladders, Hatches, Stairs.//
///////////////////////////////////////

/obj/multiz
	icon = 'icons/obj/structures.dmi'
	density = 0
	opacity = 0
	anchored = 1

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density


/obj/multiz/ladder
	icon_state = "ladderdown"
	name = "ladder"
	desc = "A ladder.  You climb up and down it."

	var/d_state = 1
	var/obj/multiz/target

	New()
		ladder_list |= src
		. = ..()

	proc/connect()
		if(icon_state == "ladderdown") // the upper will connect to the lower
			d_state = 1
			var/turf/controllerlocation = locate(1, 1, z)
			for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
				if(controller.down)
					var/turf/below = locate(src.x, src.y, controller.down_target)
					for(var/obj/multiz/ladder/L in below)
						if(L.icon_state == "ladderup")
							target = L
							L.target = src
							d_state = 0
							break
		return

	Destroy()
		if(target && icon_state == "ladderdown")
			qdel(target)
		return ..()

	attack_paw(var/mob/M)
		return attack_hand(M)

	attack_hand(var/mob/M)
		var/turf/T = get_turf(target)
		if(M.a_intent == "grab")		// && get_dist(M, src) <= 1
			var/atom/movable/chosen
			var/list/avaluable_contents
			avaluable_contents = list()
			for(var/obj/C in T.contents)
				if(!C.anchored)
					avaluable_contents |= C
			for(var/mob/living/carbon/X in T.contents)
				if(!X.buckled)
					avaluable_contents |= X
			chosen = input("What would you like to pull [src.icon_state == "ladderup" ? "down" : "up"]?", "Cross-ladder Pull", null) as obj|mob in avaluable_contents
			if(chosen)
				M.visible_message("\blue \The [M] starts pulling [chosen] [src.icon_state == "ladderup" ? "down" : "up"] \the [src]!", "\blue You start pulling [chosen] [src.icon_state == "ladderup"  ? "down" : "up"] \the [src]!", "You hear some grunting, and clanging of a metal ladder being used.")
				if(iscarbon(chosen))
					to_chat(chosen, "\red A hand appears from \the [src] and starts pulling you inside!")
				if(do_after(M, 50))
					if(get_turf(chosen) == T)
						chosen.forceMove(src)
						M.visible_message("\blue \The [M] pulls [chosen] [src.icon_state == "ladderup" ? "down" : "up"] \the [src]!", "\blue You pull [chosen] [src.icon_state == "ladderup"  ? "down" : "up"] \the [src]!", "You hear some grunting, and clanging of a metal ladder being used.")
						return
					else
						to_chat(M, "\red \The [chosen] moved out of range!")
						return
				else
					return

		if(!target || !isloc(target))
			to_chat(M, "\ red The ladder is incomplete and can't be climbed.")
		else
			var/blocked = 0
			for(var/atom/A in T.contents)
				if(A.density && !ismob(A))
					blocked = 1
					break
			if(blocked || istype(T, /turf/simulated/wall))
				to_chat(M, "\red Something is blocking the ladder.")
			else
				M.visible_message("<b>[M.name]</b> starts to climb [src.icon_state == "ladderup" ? "up" : "down"] \the [src]!")
				playsound(src, 'sound/lfwbsounds/ladder.ogg', 70, 1)
				if(do_after(M, 15))
					M.forceMove(target)

	attackby(obj/item/W as obj, mob/M as mob)
		if (istype(W, /obj/item/grab) && get_dist(src,M)<2)
			var/obj/item/grab/G = W
			if(G.state >= 2)
				if(!target || !isloc(target))
					to_chat(M,"\red The ladder is incomplete and can't be climbed.")
					return
				var/turf/T = get_turf(target)
				var/blocked = 0
				for(var/atom/A in T.contents)
					if(A.density && !ismob(A))
						blocked = 1
						break
				if(blocked || issimulatedwall(T))
					to_chat(M,"\red Something is blocking the ladder.")
				else
					M.visible_message("\blue \The [M] puts [G.affecting] [src.icon_state == "ladderup" ? "up" : "down"] \the [src]!", "\blue You put [G.affecting] [src.icon_state == "ladderup"  ? "up" : "down"] \the [src]!", "You hear some grunting, and clanging of a metal ladder being used.")
					G.affecting.forceMove(target)
					qdel(W)


//Spizjeno by guap


/obj/multiz
	icon = 'icons/obj/structures.dmi'
	density = 0
	opacity = 0
	anchored = 1
	var/istop = 1

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density

/obj/multiz/proc/targetZ()
	return src.z + (istop ? 1 : -1)


/obj/multiz/stairs
	name = "Stairs"
	desc = "Stairs.  You walk up and down them."
	icon_state = "ramptop"
	layer = 2.4
	flammable = 0

/obj/multiz/stairs/enter/bottom
	istop = 0
	icon_state = "rampbottom"

/obj/multiz/stairs/enter/New()
	..()
	src.icon_state = ""

/obj/multiz/stairs/active
	density = 1
	opacity = 0
	icon_state = "rampbottom"

/obj/multiz/stairs/active/wood
	icon_state = "wramp"

/obj/multiz/stairs/active/caveramp
	icon_state = "caveramp"

/obj/multiz/stairs/active/Bumped(var/atom/movable/M)
	if(!M.gravitydep)
		return
	if(istype(src, /obj/multiz/stairs/active/bottom) && !locate(/obj/multiz/stairs/enter) in M.loc)
		return //If on bottom, only let them go up stairs if they've moved to the entry tile first.
	//If it's the top, they can fall down just fine.
	if(ismob(M) && M:client)
		M:client.moving = 1
	var/turf/T = locate(M.x, M.y, targetZ())
	if(!T) return;
	M.forceMove(locate(src.x, src.y, targetZ()))
	if(isliving(M))
		var/mob/living/L = M
		if(L.pulling)
			L.pulling.forceMove(locate(src.x, src.y, targetZ()))
		if(L.client)
			if(istype(src, /obj/multiz/stairs/active/bottom))
				to_chat(L,"<i>You climb down the stairs.</i>")
			else
				to_chat(L,"<i>You climb up the stairs.</i>")
	if (ismob(M) && M:client)
		M:client.moving = 0

/obj/multiz/stairs/active/Click()
	if(!istype(usr,/mob/dead/observer))
		return ..()
	usr.client.moving = 1
	usr.Move(locate(src.x, src.y, targetZ()))
	usr.client.moving = 0

/obj/multiz/stairs/active/bottom
	istop = 0
	opacity = 0
	icon_state = "ramptop"

/obj/multiz/stairs/active/bottom/wood
	icon_state = "wramp"

/obj/multiz/stairs/active/bottom/caveramp
	icon_state = "caveramp"

/obj/multiz/attack_tk(mob/user as mob)
	return