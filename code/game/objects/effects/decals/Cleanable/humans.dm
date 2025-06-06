#define DRYING_TIME 2 MINUTES                        //for 1 unit of depth in puddle (amount var)

var/global/list/image/splatter_cache=list()

/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "Something bad happened here."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2.1
	icon = 'icons/effects/blood.dmi'
	color = null
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7", "floor8", "floor9", "floor10", "floor11", "floor12")
	var/base_icon = 'icons/effects/blood.dmi'
	var/list/viruses = list()
	blood_DNA = list()
	var/basecolor="#A10808" // Color when wet.
	var/list/datum/disease2/disease/virus2 = list()
	var/amount = 5
	appearance_flags = NO_CLIENT_COLOR
	var/probtoturnfootblood = 30

/obj/effect/decal/cleanable/blood/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/clothing/head/misero))
		user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>starts to wipe down </span><span class='passivebold'>[src]</span><span class='passive'> with </span><span class='passivebold'>[W]!</span>")
		if(do_after(user,4))
			user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>finishes wiping off the</span> <span class='passivebold'>[src]</span>!")
			qdel(src)

/obj/effect/decal/cleanable/blood/Destroy()
	. = ..()

/obj/effect/decal/cleanable/blood/New()
	..()
	update_icon()
	if(istype(src, /obj/effect/decal/cleanable/blood/gibs))
		return
	if(istype(src, /obj/effect/decal/cleanable/blood/tracks))
		return // We handle our own drying.
	if(src.type == /obj/effect/decal/cleanable/blood)
		if(src.loc && isturf(src.loc))
			for(var/obj/effect/decal/cleanable/blood/B in src.loc)
				if(B != src)
					if (B.blood_DNA)
						blood_DNA |= B.blood_DNA?.Copy()
					qdel(B)
	spawn(DRYING_TIME * (amount+1))
		dry()

/obj/effect/decal/cleanable/blood/update_icon()
	if(basecolor == "rainbow") basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"

/obj/effect/decal/cleanable/blood/Crossed(mob/living/carbon/human/perp)
	if (!istype(perp))
		return
	if(amount < 1)
		return

	var/datum/organ/external/l_foot = perp.get_organ(BP_L_FOOT)
	var/datum/organ/external/r_foot = perp.get_organ(BP_R_FOOT)
	var/hasfeet = 1
	if((!l_foot || l_foot.is_broken()) && (!r_foot || r_foot.is_broken()))
		hasfeet = 0

	if(prob(probtoturnfootblood))

		var/obj/item/clothing/shoes/S = perp.shoes
		if(S)//Adding blood to shoes
			S.blood_color = basecolor
			S.track_blood = max(amount,perp.shoes:track_blood)
			if(!S.blood_overlay)
				S.generate_blood_overlay()
			if(!S.blood_DNA)
				S.blood_DNA = list()
				S.blood_overlay.color = basecolor
				S.overlays += perp.shoes.blood_overlay
			//S?.blood_DNA |= blood_DNA?.Copy()

		else if(hasfeet)//Or feet
			perp.feet_blood_color = basecolor
			perp.track_blood = max(amount,perp.track_blood)
			if(!perp.feet_blood_DNA)
				perp.feet_blood_DNA = list()
			if(!blood_DNA)
				blood_DNA = list()
			//perp?.feet_blood_DNA |= blood_DNA?.Copy()

		perp.update_inv_shoes(1)
		amount--

/obj/effect/decal/cleanable/blood/proc/dry()
		name = "dried [src.name]"
		desc = "It's dry and crusty. Someone is not doing their job."
		color = adjust_brightness("#610505", -2)
		amount = 0

/obj/effect/decal/cleanable/blood/attack_hand(mob/living/carbon/human/user)
	..()
	if (amount && istype(user))
		add_fingerprint(user)
		if (user.gloves)
			return
		var/taken = rand(1,amount)
		amount -= taken
		user << "<span class='notice'>You get some of \the [src] on your hands.</span>"
		if (!user.blood_DNA)
			user.blood_DNA = list()
		user.blood_DNA |= blood_DNA?.Copy()
		user.bloody_hands += taken
		user.hand_blood_color = basecolor
		user.update_inv_gloves(1)
		user.verbs += /mob/living/carbon/human/proc/bloody_doodle

/obj/effect/decal/cleanable/trail_holder //not a child of blood on purpose
	name = "blood"
	icon_state = "blank"
	desc = "Your instincts say you shouldn't be following these."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	random_icon_states = null
	var/list/existing_dirs = list()
	appearance_flags = NO_CLIENT_COLOR
	blood_DNA = list()


/obj/effect/decal/cleanable/blood/splatter
        random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")
        amount = 2

/obj/effect/decal/cleanable/blood/drip
        name = "drips of blood"
        desc = "It's red."
        gender = PLURAL
        icon = 'icons/effects/drip.dmi'
        icon_state = "1"
        random_icon_states = list("1","2","3","4","5")
        amount = 0

/obj/effect/decal/cleanable/blood/drip/Destroy()
	. = ..()

/obj/effect/decal/cleanable/blood/writing
	icon_state = "tracks"
	desc = "It looks like a writing in blood."
	gender = NEUTER
	random_icon_states = list("writing1","writing2","writing3","writing4","writing5")
	amount = 0
	var/message

/obj/effect/decal/cleanable/blood/writing/New()
	..()
	if(random_icon_states.len)
		for(var/obj/effect/decal/cleanable/blood/writing/W in loc)
			random_icon_states.Remove(W.icon_state)
		icon_state = pick(random_icon_states)
	else
		icon_state = "writing1"

/obj/effect/decal/cleanable/blood/writing/examine()
	..()
	usr << "It reads: <font color='[basecolor]'>\"[message]\"<font>"

/obj/effect/decal/cleanable/blood/writing/Destroy()
	. = ..()

/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "gibbl5"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	appearance_flags = NO_CLIENT_COLOR
	var/fleshcolor = "#FFFFFF"
	var/souNormal = 0

/obj/effect/decal/cleanable/blood/gibs/update_icon()
	if(souNormal) return
	var/image/giblets = new(base_icon, "[icon_state]", dir)
	if(!fleshcolor || fleshcolor == "rainbow")
		fleshcolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	giblets.color = fleshcolor

	var/icon/blood = new(base_icon,"[icon_state]",dir)
	if(basecolor == "rainbow") basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	blood.Blend(basecolor,ICON_MULTIPLY)

	icon = blood
	overlays.Cut()
	overlays += giblets

/obj/effect/decal/cleanable/blood/gibs/Destroy()
	. = ..()

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/up/_1
	random_icon_states = list("gib1", "gib2")

/obj/effect/decal/cleanable/blood/gibs/up/_1/New()
	icon_state = random_icon_states

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

/obj/effect/decal/cleanable/blood/gibs/normal
	random_icon_states = list("gib1", "gib2")
	souNormal = 1
	color = null

/obj/effect/decal/cleanable/blood/gibs/normal/update_icon()
	return

/obj/effect/decal/cleanable/blood/gibs/normal/New()
	icon_state = pick(random_icon_states)

/obj/effect/decal/cleanable/blood/gibs/normal/update_icon()
	icon_state = pick(random_icon_states)

/obj/effect/decal/cleanable/blood/gibs/proc/streak(var/list/directions)
        spawn (0)
                var/direction = pick(directions)
                for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
                        sleep(3)
                        if (i > 0)
                                var/obj/effect/decal/cleanable/blood/b = PoolOrNew(/obj/effect/decal/cleanable/blood/splatter, src.loc)
                                b.basecolor = src.basecolor
                                b.update_icon()
                                for(var/datum/disease/D in src.viruses)
                                        var/datum/disease/ND = D.Copy(1)
                                        b.viruses += ND
                                        ND.holder = b

                        if (step_to(src, get_step(src, direction), 0))
                                break


/obj/effect/decal/cleanable/mucus
	name = "mucus"
	desc = "Disgusting mucus."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "mucus"
	random_icon_states = list("mucus")

	var/list/datum/disease2/disease/virus2 = list()
	var/dry=0 // Keeps the lag down

/obj/effect/decal/cleanable/mucus/New()
	spawn(DRYING_TIME * 2)
		dry=1