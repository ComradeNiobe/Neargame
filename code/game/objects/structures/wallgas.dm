/obj/structure/vent_gas
	desc = "A large ventilation panel attached to the wall."
	name = "vent"
	icon = 'icons/obj/structures.dmi'
	icon_state = "obj37"
	density = 1
	anchored = 1
	flags = 300000000
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 3
	level = 3
	plane = 21
	explosion_resistance = 1
	var/obj/mainParticle = null

/obj/structure/vent_gas/New()
	..()
	mainParticle = new/obj/particles/gas(src.loc)

/obj/particles/gas/New()
	..()
	mouse_opacity = 0
	var/particles/gas/F = new
	src.pixel_y = 12
	src.plane = 22
	particles += F
	mainParticle = F

particles/gas
	width = 100
	height = 200
	count = 20
	spawning = 1
	lifespan = 25
	fade = 1
	grow = 0
	velocity = list(0, 0)
	position = generator("circle", 0, 0, NORMAL_RAND)
	gravity = list(0, 0.15)
	icon = 'icons/obj/gas_particles.dmi'
	scale       =   generator("vector", list(0.3, 0.3), list(1,1), NORMAL_RAND)
	rotation    =   30
	spin        =   generator("num", -5, 5)
/*
/obj/effect/gas_particle
	name = "gas particles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke2"
	opacity = 0
	anchored = 1
	layer = 4.1
	plane = 15
	alpha = 120
	mouse_opacity = 0
	pixel_y = 12
*/

/obj/structure/vent_gas_deactivated
	desc = "A large ventilation panel attached to the wall."
	name = "vent"
	icon = 'icons/obj/structures.dmi'
	icon_state = "obj37"
	density = 1
	anchored = 1
	flags = 300000000
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 3
	level = 3
	explosion_resistance = 1