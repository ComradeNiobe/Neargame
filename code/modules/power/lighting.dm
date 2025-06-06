// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/light)


// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3



/obj/item/light_fixture_frame
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	flags = FPRINT | TABLEPASS| CONDUCT
	var/fixture_type = "tube"
	var/obj/machinery/light/newlight = null
	var/sheets_refunded = 2

/obj/item/light_fixture_frame/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/wrench))
		new /obj/item/stack/sheet/metal( get_turf(src.loc), sheets_refunded )
		qdel(src)
		return
	..()

/obj/item/light_fixture_frame/proc/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in cardinal))
		return
	var/turf/loc = get_turf_loc(usr)
	if (!istype(loc, /turf/simulated/floor))
		usr << "\red [src.name] cannot be placed on this spot."
		return
	usr << "Attaching [src] to the wall."
	playsound(src.loc, 'sound/machines/click.ogg', 75, 1)
	var/constrdir = usr.dir
	var/constrloc = usr.loc
	if (!do_after(usr, 30))
		return
	switch(fixture_type)
		if("bulb")
			newlight = new /obj/machinery/light_construct/small(constrloc)
		if("tube")
			newlight = new /obj/machinery/light_construct(constrloc)
	newlight.dir = constrdir
	newlight.fingerprints = src.fingerprints
	newlight.fingerprintshidden = src.fingerprintshidden
	newlight.fingerprintslast = src.fingerprintslast

	usr.visible_message("[usr.name] attaches [src] to the wall.", \
		"You attach [src] to the wall.")
	qdel(src)

/obj/item/light_fixture_frame/small
	name = "small light fixture frame"
	desc = "Used for building small lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-item"
	flags = FPRINT | TABLEPASS| CONDUCT
	fixture_type = "bulb"
	sheets_refunded = 1

/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = 1
	layer = 5
	var/stage = 1
	var/fixture_type = "tube"
	var/sheets_refunded = 2
	var/obj/machinery/light/newlight = null

/obj/machinery/light_construct/New()
	..()
	if (fixture_type == "bulb")
		icon_state = "bulb-construct-stage1"

/obj/machinery/light_construct/examine()
	set src in view()
	..()
	if (!(usr in view(2))) return
	switch(src.stage)
		if(1)
			usr << "It's an empty frame."
			return
		if(2)
			usr << "It's wired."
			return
		if(3)
			usr << "The casing is closed."
			return

/obj/machinery/light_construct/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (istype(W, /obj/item/wrench))
		if (src.stage == 1)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			usr << "You begin deconstructing [src]."
			if (!do_after(usr, 30))
				return
			new /obj/item/stack/sheet/metal( get_turf(src.loc), sheets_refunded )
			user.visible_message("[user.name] deconstructs [src].", \
				"You deconstruct [src].", "You hear a noise.")
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 75, 1)
			qdel(src)
		if (src.stage == 2)
			usr << "You have to remove the wires first."
			return

		if (src.stage == 3)
			usr << "You have to unscrew the case first."
			return

	if(istype(W, /obj/item/wirecutters))
		if (src.stage != 2) return
		src.stage = 1
		switch(fixture_type)
			if ("tube")
				src.icon_state = "tube-construct-stage1"
			if("bulb")
				src.icon_state = "bulb-construct-stage1"
		new /obj/item/stack/cable_coil(get_turf(src.loc), 1, "red")
		user.visible_message("[user.name] removes the wiring from [src].", \
			"You remove the wiring from [src].", "You hear a noise.")
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		return

	if(istype(W, /obj/item/stack/cable_coil))
		if (src.stage != 1) return
		var/obj/item/stack/cable_coil/coil = W
		coil.use(1)
		switch(fixture_type)
			if ("tube")
				src.icon_state = "tube-construct-stage2"
			if("bulb")
				src.icon_state = "bulb-construct-stage2"
		src.stage = 2
		user.visible_message("[user.name] adds wires to [src].", \
			"You add wires to [src].")
		return

	if(istype(W, /obj/item/screwdriver))
		if (src.stage == 2)
			switch(fixture_type)
				if ("tube")
					src.icon_state = "tube-empty"
				if("bulb")
					src.icon_state = "bulb-empty"
			src.stage = 3
			user.visible_message("[user.name] closes [src]'s casing.", \
				"You close [src]'s casing.", "You hear a noise.")
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 75, 1)

			switch(fixture_type)

				if("tube")
					newlight = new /obj/machinery/light/built(src.loc)
				if ("bulb")
					newlight = new /obj/machinery/light/small/built(src.loc)

			newlight.dir = src.dir
			src.transfer_fingerprints_to(newlight)
			qdel(src)
			return
	..()

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = 1
	layer = 5
	stage = 1
	fixture_type = "bulb"
	sheets_refunded = 1

// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube1"
	desc = "Caked in grime. Functions well enough."
	anchored = 1
	layer = 5  					// They were appearing under mobs which is a little weird - Ostaf
	plane = 22
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	var/on = 0					// 1 if on, 0 if off
	var/on_gs = 0
	var/brightness_range = 5
	var/brightness_power = 4
	var/brightness_color = "#93b4f5"
	var/redalert = 1

	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = 0
	var/light_type = /obj/item/light/tube		// the type of light item
	var/fitting = "tube"
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out
	var/rigged = 0				// true if rigged to explode

// the smaller bulb light fixture

/obj/machinery/light/small
	icon_state = "bulb1"
	base_state = "bulb"
	fitting = "bulb"
	brightness_range = 12
	brightness_power = 9
	brightness_color = "#f7e1ad"
	plane = 22
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb

	seton(var/s)
		on = (s && status == LIGHT_OK)
		update()

/obj/machinery/light/small/weaker
	brightness_range = 12
	brightness_power = 7

/obj/machinery/light/small/green
	brightness_color = "#699c36"

/obj/machinery/light/small/green/weak
	brightness_range = 5
	brightness_power = 3

/obj/machinery/light/small/redr
	brightness_color = "#f4c2c2"

/obj/machinery/light/small/redr/weak
	brightness_range = 5
	brightness_power = 3

/obj/machinery/light/small/amarelosangue
	brightness_color= "#ff8b6b"

/obj/machinery/light/small/amarelosangue/weak
	brightness_range = 5
	brightness_power = 3

/obj/machinery/light/small/blue
	brightness_color = "#4897cf"

/obj/machinery/light/small/yellow
	brightness_color = "#888a5b"

/obj/machinery/light/small/blue/weak
	brightness_range = 5
	brightness_power = 3

/obj/machinery/light/small/mijadablue
	brightness_color = "#2727b3"
	brightness_range = 9
	brightness_power = 8

/obj/machinery/light/small/cinzouotario
	brightness_color = "#636363"
	brightness_range = 9
	brightness_power = 8

/obj/machinery/light/small/mijadababyblue
	brightness_color = "#1b4a49"
	brightness_range = 5
	brightness_power = 3


/obj/machinery/light/small/mijadaroxo
	brightness_color = "#6532cd"
	brightness_range = 9
	brightness_power = 8


/obj/machinery/light/small/roxodaora
	brightness_color = "#685ae6"
	brightness_range = 6
	brightness_power = 9

/obj/machinery/light/small/mijadablue/weak
	brightness_range = 5
	brightness_power = 3

/obj/machinery/light/small/purple
	brightness_color = "#b19cd9"

/obj/machinery/light/small/purple/weak
	brightness_range = 5
	brightness_power = 3

/obj/machinery/light/small/red
	icon_state = "firelight1"
	base_state = "firelight"
	fitting = "bulb"
	brightness_range = 5
	brightness_power = 3
	brightness_color = "#f52727"
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb/fire

/obj/machinery/light/spot
	name = "spotlight"
	fitting = "large tube"
	light_type = /obj/item/light/tube/large

/obj/machinery/light/built/New()
	. = ..()

	status = LIGHT_EMPTY
	update(0)

/obj/machinery/light/small/built/New()
	. = ..()

	status = LIGHT_EMPTY
	update(0)

// create a new lighting fixture
/obj/machinery/light/New()

	processing_objects |= src

	spawn(2)
		switch(fitting)
			if("tube")
				//var/br = pick(7,9)
				if(prob(2))
					broken(1)
			if("bulb")


				if(prob(5))
					broken(1)
		spawn(1)
			update(0)

/obj/machinery/light/Destroy()
	processing_objects -= src
	var/area/A = get_area(src)
	if(A)
		on = 0
//		A.update_lights()
	return ..()

/obj/machinery/light/update_icon()

	switch(status)		// set icon_states
		if(LIGHT_OK)
			icon_state = "[base_state][on]"
		if(LIGHT_EMPTY)
			icon_state = "[base_state]-empty"
			on = 0
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			on = 0
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			on = 0
	return

// update the icon_state and luminosity of the light depending on its state
/obj/machinery/light/proc/update(var/trigger = 1)

	update_icon()

	if(on)
		set_light(brightness_range, brightness_power,brightness_color)
	else
		use_power = 1
		set_light(0)

	active_power_usage = (luminosity * 10)
	if(on != on_gs)
		on_gs = on

/obj/machinery/light/proc/isalert()
	if(!(src.z in vessel_z))
		return 0
	if(security_level >= SEC_LEVEL_RED)
		return 1
	else
		return 0

/obj/machinery/light/small/isalert()		//I don't want them to change to red
	return 0


/obj/machinery/light/small/bulb_ov
	icon_state = "bulb_ov"
	layer = 5.1
	mouse_opacity = FALSE

/obj/machinery/light/small/bulb_ov/New()
	color = brightness_color


/obj/machinery/light/small/bulb_light
	icon_state = "bulb_light"
	layer = 5.1
	mouse_opacity = FALSE

/obj/machinery/light/small/bulb_light/New()
	color = brightness_color

/obj/machinery/light/small/New()
	var/area/A = get_area(src)
	A.webItems += src
	Add_LightOverlay()
	switch(dir)
		if(NORTH)
			pixel_y = 4
		if(SOUTH)
			pixel_y = -4
		if(EAST)
			pixel_x = 4
		if(WEST)
			pixel_x = -4

/obj/machinery/light/small/update()
	..()
	if(!on)
		Remove_LightOverlay()

/obj/machinery/light/small/proc/Add_LightOverlay()
	color = brightness_color
	overlays += /obj/machinery/light/small/bulb_ov
	overlays += /obj/machinery/light/small/bulb_light

/obj/machinery/light/small/proc/Remove_LightOverlay()
	color = initial(color)
	overlays -= /obj/machinery/light/small/bulb_ov
	overlays -= /obj/machinery/light/small/bulb_light

// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(var/s)
	on = (s && status == LIGHT_OK)
	if(on)
		playsound(src.loc, 'sound/effects/tube_sound.ogg', 80, 1)
	update()

// examine verb
/obj/machinery/light/examine()
	set src in oview(1)
	if(usr && !usr.stat)
		switch(status)
			if(LIGHT_OK)
				usr << "[desc] It is turned [on? "on" : "off"]."
			if(LIGHT_EMPTY)
				usr << "[desc] The [fitting] has been removed."
			if(LIGHT_BURNED)
				usr << "[desc] The [fitting] is burnt out."
			if(LIGHT_BROKEN)
				usr << "[desc] The [fitting] has been smashed."



// attack with item - insert light (if right type), otherwise try to break the light

/obj/machinery/light/attackby(obj/item/W, mob/user)

	//Light replacer code
	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = W
		if(isliving(user))
			var/mob/living/U = user
			LR.ReplaceLight(src, U)
			return

	// attempt to insert light
	if(istype(W, /obj/item/light))
		if(status != LIGHT_EMPTY)
			user << "There is a [fitting] already inserted."
			return
		else
			src.add_fingerprint(user)
			var/obj/item/light/L = W
			if(istype(L, light_type))
				status = L.status
				user << "You insert the [L.name]."
				switchcount = L.switchcount
				rigged = L.rigged


				on = has_power()
				update()

				user.drop_item()	//drop the item to update overlays and such
				qdel(L)

				if(on && rigged)

					log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
					message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

					explode()
			else
				user << "This type of light requires a [fitting]."
				return

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)


		if(prob(1+W.force * 5))

			user << "You hit the light, and it smashes!"
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] smashed the light!", 3, "You hear a tinkle of breaking glass", 2)
			if(on && (W.flags & CONDUCT))
				//if(!user.mutations & COLD_RESISTANCE)
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			user << "You hit the light!"

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(istype(W, /obj/item/screwdriver)) //If it's a screwdriver open it.
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 75, 1)
			user.visible_message("[user.name] opens [src]'s casing.", \
				"You open [src]'s casing.", "You hear a noise.")
			var/obj/machinery/light_construct/newlight = null
			switch(fitting)
				if("tube")
					newlight = new /obj/machinery/light_construct(src.loc)
					newlight.icon_state = "tube-construct-stage2"

				if("bulb")
					newlight = new /obj/machinery/light_construct/small(src.loc)
					newlight.icon_state = "bulb-construct-stage2"
			newlight.dir = src.dir
			newlight.stage = 2
			newlight.fingerprints = src.fingerprints
			newlight.fingerprintshidden = src.fingerprintshidden
			newlight.fingerprintslast = src.fingerprintslast
			qdel(src)
			return

		user << "You stick \the [W] into the light socket!"
		if(has_power() && (W.flags & CONDUCT))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			//if(!user.mutations & COLD_RESISTANCE)
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))


// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/proc/has_power()
	var/area/A = src.loc.loc
	return A.master.lightswitch && A.master.power_light

/obj/machinery/light/proc/flicker(var/amount = rand(10, 20))
	if(flickering) return
	flickering = 1
	playsound(src.loc, pick(lightflickersounds), 20, 0)
	spawn(0)
		if(on && status == LIGHT_OK)
			for(var/i = 0; i < amount; i++)
				if(status != LIGHT_OK) break
				on = !on
				update(0)
				sleep(rand(0.5, 1))
			on = (status == LIGHT_OK)
			update(0)
		flickering = 0
		if(prob(1) && prob(1))
			broken()

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/user)
	src.flicker(1)
	return

/obj/machinery/light/attack_animal(mob/living/simple_animal/M)
	if(M.melee_damage_upper == 0)	return
	if(status == LIGHT_EMPTY||status == LIGHT_BROKEN)
		M << "\red That object is useless to you."
		return
	else if (status == LIGHT_OK||status == LIGHT_BURNED)
		for(var/mob/O in viewers(src))
			O.show_message("\red [M.name] smashed the light!", 3, "You hear a tinkle of breaking glass", 2)
		broken()
	return
// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player

/obj/machinery/light/attack_hand(mob/user)

	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		user << "There is no [fitting] in this light."
		return

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			for(var/mob/M in viewers(src))
				M.show_message("\red [user.name] smashed the light!", 3, "You hear a tinkle of breaking glass", 2)
			broken()
			return

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))

			if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					prot = (G.max_heat_protection_temperature > 360)
		else
			prot = 1

		if(prot > 0 || (COLD_RESISTANCE in user.mutations))
			user << "You remove the light [fitting]"
		else if(TK in user.mutations)
			user << "You telekinetically remove the light [fitting]."
		else
			user << "You try to remove the light [fitting], but it's too hot and you don't want to burn your hand."
			return				// if burned, don't remove the light
	else
		user << "You remove the light [fitting]."

	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/light/L = new light_type()
	L.status = status
	L.rigged = rigged


	// light item inherits the switchcount, then zero it
	L.switchcount = switchcount
	switchcount = 0

	L.update()
	L.add_fingerprint(user)

	user.put_in_active_hand(L)	//puts it in our active hand

	status = LIGHT_EMPTY
	update()


/obj/machinery/light/attack_tk(mob/user)
	if(status == LIGHT_EMPTY)
		user << "There is no [fitting] in this light."
		return

	user << "You telekinetically remove the light [fitting]."
	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/light/L = new light_type()
	L.status = status
	L.rigged = rigged


	// light item inherits the switchcount, then zero it
	L.switchcount = switchcount
	switchcount = 0

	L.update()
	L.add_fingerprint(user)
	L.loc = loc

	status = LIGHT_EMPTY
	update()

// break the light and make sparks if was on

/obj/machinery/light/proc/broken(var/skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src.loc, 'sound/machines/lightbreak.ogg', 75, 1)
		if(on)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(1, 1, src)
			s.start()
	status = LIGHT_BROKEN
	update()

/obj/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK

	on = 1
	update()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/machinery/light/emp_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(75))
				broken()
		if(3.0)
			if (prob(50))
				broken()

/obj/machinery/light/bullet_act()
	broken()




// timed process
// use power

#define LIGHTING_POWER_FACTOR 20		//20W per unit luminosity

/obj/machinery/light/process()//TODO: remove/add this from machines to save on processing as needed ~Carn PRIORITY
	if(on)
		use_power(luminosity * LIGHTING_POWER_FACTOR, LIGHT)
		if(prob(1))
			flicker()

/obj/machinery/light/proc/update_redalert()
	if(on)
		on = 0
		update()
		sleep(rand(0,8))
		on = 1
		update()


// called when area power state changes
/obj/machinery/light/power_change()
	spawn(10)
		var/area/A = src.loc.loc
		A = A.master
		seton(A.lightswitch && A.power_light)

// called when on fire

/obj/machinery/light/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

// explode the light

/obj/machinery/light/proc/explode()
	var/turf/T = get_turf(src.loc)
	spawn(0)
		broken()	// break it first to give a warning
		sleep(2)
		explosion(T, 0, 0, 2, 2)
		sleep(1)
		qdel(src)

// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/light
	icon = 'icons/obj/lighting.dmi'
	flags = FPRINT | TABLEPASS
	force = 2
	throwforce = 5
	w_class = 1
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	m_amt = 60
	var/rigged = 0		// true if rigged to explode
	var/brightness = 2



/obj/item/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	g_amt = 100





/obj/item/light/tube/large
	w_class = 2
	name = "large light tube"

/obj/item/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	g_amt = 100

/obj/item/light/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "flight"
	base_state = "flight"
	item_state = "egg4"
	g_amt = 100


// update the icon state and description of the light

/obj/item/light/proc/update()
	switch(status)
		if(LIGHT_OK)
			icon_state = base_state
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			desc = "A broken [name]."


/obj/item/light/New()
	..()
	update()


// attack bulb/tube with object
// if a syringe, can inject plasma to make it explode
/obj/item/light/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = I

		user << "You inject the solution into the [src]."

		if(S.reagents.has_reagent("plasma", 5))

			log_admin("LOG: [user.name] ([user.ckey]) injected a light with plasma, rigging it to explode.")
			message_admins("LOG: [user.name] ([user.ckey]) injected a light with plasma, rigging it to explode.")

			rigged = 1

		S.reagents.clear_reagents()
	else
		..()
	return

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != "hurt")
		return

	shatter()

/obj/item/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		//src.visible_message("\red [name] shatters.","\red You hear a small glass object shatter.")
		status = LIGHT_BROKEN
		force = 5
		playsound(src.loc, 'sound/machines/lightbreak.ogg', 75, 1)
		update()