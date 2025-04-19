/obj/item/device/flashlight
	name = "flashlight"
	desc = "An expensive light source. Handheld and reliable."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flight0"
	w_class = 2
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	var/on = 0
	var/obj/item/cell/crap/leet/CELL = null
	var/obj/effect/flashlight_spot/spotlight = null
	var/obj/effect/flashlight_spot/beam/beam = null

/obj/item/device/flashlight/New()
	..()
	CELL = new /obj/item/cell/crap/leet
	processing_objects.Add(src)

/obj/item/device/flashlight/process()
	if(CELL && CELL.charge && on)
		CELL.charge = max(0, CELL.charge-2)
		if(spotlight && beam)
			spotlight.alpha = 30+(CELL.charge/10)
			beam.alpha = spotlight.alpha

/obj/item/device/flashlight/Destroy()
	processing_objects.Remove(src)
	var/obj/O = CELL
	var/obj/OO = spotlight
	var/obj/OOO = beam
	O = null
	OO = null
	OOO = null
	qdel(O)
	qdel(OO)
	qdel(OOO)
	..()

/obj/item/device/flashlight/MouseDrop(var/obj/over_object)
	var/mob/user = usr
	switch(over_object.name)
		if("r_hand")
			if(CELL)
				CELL.loc = get_turf(src.loc)
				user.put_in_hands(CELL)
				user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>removes the cell from the [src].</span>")
				playsound(src, 'sound/lfwbcombatuse/energy_unload.ogg', 25, 0)
				CELL = null
				on = 0
				update()
			else
				to_chat(usr, "<span class='combat'><i>It has no cell!</i></span>")
		if("l_hand")
			if(CELL)
				CELL.loc = get_turf(src.loc)
				user.put_in_hands(CELL)
				user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>removes the cell from the [src].</span>")
				playsound(src, 'sound/lfwbcombatuse/energy_unload.ogg', 25, 0)
				CELL = null
				on = 0
				update()
			else
				to_chat(usr, "<span class='combat'><i>It has no cell!</i></span>")

/obj/item/device/flashlight/attackby(var/obj/item/A, var/mob/user)
	if(istype(A, /obj/item/cell/crap) && !CELL)
		user.drop_item(sound = 0)
		CELL = A
		CELL.loc = src
		user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>reloads [src]!</span>")
		playsound(src, 'sound/lfwbcombatuse/energy_reload.ogg', 25, 0)
		var/obj/item/cell/crap/C = A			//I didn't know how to do it without hardcoded type
		C.updateicon()
		update_icon()
	else
		return ..()

/obj/item/device/flashlight/attack_self(mob/user)
	if(CELL && CELL.charge)
		on = !on
		update()
	else
		to_chat(user, "No battery.")

/obj/item/device/flashlight/proc/update()
	playsound(src.loc, 'sound/webbers/legacy_toggle_light.ogg', 50, 1)
	spotlight_update()
	if(!on)
		icon_state = "flashlight"
		item_state = "flight0"
		return
	icon_state = "flashlight-on"
	item_state = "flight1"

/mob/living/carbon/human/Move()
	..()
	if(istype(r_hand, /obj/item/device/flashlight))
		var/obj/item/device/flashlight/F = r_hand
		F.spotlight_update()

	if(istype(l_hand, /obj/item/device/flashlight))
		var/obj/item/device/flashlight/F = l_hand
		F.spotlight_update()

/mob/living/carbon/human/set_dir()
	..()
	if(istype(r_hand, /obj/item/device/flashlight))
		var/obj/item/device/flashlight/F = r_hand
		F.spotlight_update()

	if(istype(l_hand, /obj/item/device/flashlight))
		var/obj/item/device/flashlight/F = l_hand
		F.spotlight_update()

/obj/item/device/flashlight/afterattack(atom/A, mob/user)
	spotlight_update(A, src:loc:x - A.x, A.y - src:loc:y)

/obj/item/device/flashlight/proc/spotlight_update(var/atom/onClick, var/finalX, var/finalY)
	if(!on || !CELL || !CELL?.charge)
		if(spotlight)
			var/obj/O = spotlight
			var/obj/OO = beam
			spotlight = null
			beam = null
			qdel(O)
			qdel(OO)
			return
	if(on)
		if(!spotlight)
			spotlight = new
			beam = new
		spotlight.alpha = 30+(CELL.charge/10)
		beam.alpha = spotlight.alpha

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		var/turf/start = get_step(H, H.dir)
		if(!onClick && on)
			beam.Move(H.loc)
			beam.dir = H.dir
		else
			if(on)
				beam.Move(H.loc)
				beam.dir = WEST
				beam.transform = null
				beam.transform = turn(beam.transform, arctan(finalX, finalY))
				spotlight.Move(get_turf(onClick))
		for(var/i = 0; i <= 5; i++)
			if(onClick) break;
			if(!on) break;
			var/turf/T = get_step(start, H.dir)
			var/matrix/M = matrix()
			var/matrix/MM = matrix()
			switch(H.dir)
				if(NORTH)
					beam.pixel_y = -68
					beam.pixel_x = -82
					MM.Scale(1, 1+i/6)
				if(WEST)
					beam.pixel_x = - 82
					beam.pixel_y = -82
					MM.Scale(1+i/6, 1)
				if(EAST)
					beam.pixel_x = - 82
					beam.pixel_y = -82
					MM.Scale(1+i/6, 1)
				if(SOUTH)
					beam.pixel_x = -82
					beam.pixel_y = -92
					MM.Scale(1, 1+i/6)
			M.Scale(0.2+((i+2)/10)) // i max eh 6
			spotlight.Move(start)
			animate(spotlight, transform = M, time = 5)
			animate(beam, transform = MM, time = 5)
			if(T.opacity)
				break;
			for(var/atom/A in T)
				if(A.opacity)
					break;
			start = T

/obj/effect/flashlight_spot
	name = null
	icon = 'icons/effects/64x64.dmi'
	icon_state = ""
	pixel_x = -48
	pixel_y = -48
	alpha = 90
	blend_mode = 2
	mouse_opacity = 0
	var/fforce = 0
	var/range = 0
	plane = 25
	layer = 10
	color = "#ffcb9e"

/obj/effect/flashlight_spot/beam
	name = null
	icon = 'icons/effects/64x64_2.dmi'
	icon_state = ""
	pixel_x = -82
	pixel_y = -64
	alpha = 90
	blend_mode = 2
	mouse_opacity = 0
	force = 3
	range = 2


/obj/effect/flashlight_spot/New()
	..()
	set_light(range, fforce, "#ffbf87")

/obj/effect/flashlight_spot/Destroy()
	set_light(0)
	..()