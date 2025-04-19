//cleansed 9/15/2012 17:48

/*
CONTAINS:
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = 1
	body_parts_covered = null
	slot_flags = SLOT_EARS|SLOT_MASK
	attack_verb = list("burnt", "singed")
	var/lit = 0
	var/icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	var/icon_off = "cigoff"
	var/type_butt = /obj/item/clothing/mask/cigbutt
	var/smoketime = 300
	var/max_smoketime = 300
	var/chem_volume = 30
	var/uses_multiple_cig_smoke_icons = TRUE //until sprites get made for all smokables, let's make sure we don't break shit like cigars.

/obj/item/clothing/mask/cigarette/proc/smoking_percent()// return % of ciggie smoked. Important for updating the smoking icons.
	return (100*smoketime/max_smoketime)

/obj/item/clothing/mask/cigbutt //TODO: Make these stay in your mouth after you finish smoking them.
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon_state = "cigbutt"
	w_class = 1
	throwforce = 1

/obj/item/clothing/mask/cigarette/proc/check_smoking_icon()
	if(!uses_multiple_cig_smoke_icons)//No point in doing this if it doesn't use the icons.
		return
	var/percentage = smoking_percent()
	if(percentage <= 100 && percentage > 80)
		icon_state = "ciglit"
	if(percentage <= 80 && percentage > 60)
		icon_state = "ciglit2"
	if(percentage <= 60 && percentage > 40)
		icon_state = "ciglit3"
	if(percentage <= 40 && percentage > 20)
		icon_state = "ciglit4"
	if(percentage <= 20 && percentage > 0)
		icon_state = "ciglit5"

/obj/item/clothing/mask/cigarette/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	reagents.add_reagent("nicotine", 15)
	max_smoketime = smoketime //For division of smoking cig butts.

/obj/item/clothing/mask/cigarette/Destroy()
	..()
	qdel(reagents)

/obj/item/clothing/mask/cigarette/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/flame))
		var/obj/item/flame/T = W
		if(T.lit)
			light("<span class='notice'>[user] manages to light their [name] with [W].</span>")

	//can't think of any other way to update the overlays :<
	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)
	return


/obj/item/clothing/mask/cigarette/afterattack(obj/item/reagent_containers/glass/glass, mob/user as mob, proximity)
	..()
	if(!proximity) return
	if(istype(glass))	//you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			to_chat(user, "<span class='notice'>You dip \the [src] into \the [glass].</span>")
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, "<span class='notice'>[glass] is empty.</span>")
			else
				to_chat(user, "<span class='notice'>[src] is full.</span>")


/obj/item/clothing/mask/cigarette/proc/light(var/flavor_text = "[usr] lights the [name].")
	if(!src.lit)
		src.lit = 1
		damtype = "fire"
		if(reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		if(reagents.get_reagent_amount("fuel")) // the fuel explodes, too, but much less violently
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("fuel") / 5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		flags &= ~NOREACT // allowing reagents to react after being lit
		playsound(src, 'sound/items/cig_light.ogg', 100)
		reagents.handle_reactions()
		icon_state = icon_on
		item_state = icon_on
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		processing_objects.Add(src)


/obj/item/clothing/mask/cigarette/process()
	var/turf/location = get_turf(src)
	var/mob/living/M = loc
	if(isliving(loc))
		M.IgniteMob()
	smoketime--
	check_smoking_icon()
	if(smoketime < 1)
		die()
		return
	if(location)
		location.hotspot_expose(700, 5)
	if(reagents && reagents.total_volume)	//	check if it has any reagents at all
		if(iscarbon(loc) && (src == loc:wear_mask)) // if it's in the human/monkey mouth, transfer reagents to the mob

			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				if(H.species.flags & IS_SYNTHETIC)
					return

			var/mob/living/carbon/C = loc
			if(prob(15)) // so it's not an instarape in case of acid
				reagents.reaction(C, INGEST)
			reagents.trans_to(C, REAGENTS_METABOLISM)
		else // else just remove some of the reagents
			reagents.remove_any(REAGENTS_METABOLISM)
	return


/obj/item/clothing/mask/cigarette/attack_self(mob/user as mob)
	if(lit == 1)
		user.visible_message("<span class='notice'>[user] calmly drops and treads on the lit [src], putting it out instantly.</span>")
		die()
	return ..()


/obj/item/clothing/mask/cigarette/proc/die()
	var/turf/T = get_turf(src)
	var/obj/item/butt = new type_butt(T)
	transfer_fingerprints_to(butt)
	if(ismob(loc))
		var/mob/living/M = loc
		to_chat(M, "<span class='notice'>Your [name] goes out.</span>")
		M.u_equip(src)	//un-equip it so the overlays can update
		M.update_inv_wear_mask(0)
	processing_objects.Remove(src)
	playsound(T, 'sound/items/cig_snuff.ogg', 100)
	qdel(src)

////////////
// JOINTS //
////////////
/obj/item/clothing/mask/cigarette/weed
	name = "joint"
	desc = "It has a strong odor to it."
	smoketime = 180
	chem_volume = 50
	icon_state = "jointoff"
	icon_on = "jointon"
	icon_off = "jointoff"
	type_butt = /obj/item/cigbutt/jointbutt
	item_state = "jointoff"
	uses_multiple_cig_smoke_icons = FALSE

/obj/item/clothing/mask/cigarette/weed/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	reagents.add_reagent("maconha", 15)

/obj/item/clothing/mask/cigarette/cheapweed
	name = "joint"
	desc = "It has a weak odor to it."
	smoketime = 120
	chem_volume = 50
	icon_state = "jointoff"
	icon_on = "jointon"
	icon_off = "jointoff"
	type_butt = /obj/item/cigbutt/jointbutt
	item_state = "jointoff"
	uses_multiple_cig_smoke_icons = FALSE

/obj/item/clothing/mask/cigarette/cheapweed/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	reagents.add_reagent("maconha", 5)

/obj/item/clothing/mask/cigarette/fakeweed
	name = "joint"
	desc = "It has a chemical odor to it."
	smoketime = 120
	chem_volume = 50
	icon_state = "jointoff"
	icon_on = "jointon"
	icon_off = "jointoff"
	type_butt = /obj/item/cigbutt/jointbutt
	item_state = "jointoff"
	uses_multiple_cig_smoke_icons = FALSE

/obj/item/clothing/mask/cigarette/fakeweed/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	reagents.add_reagent("fakeweed", 15)


////////////
// CIGARS //
////////////
/obj/item/clothing/mask/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	type_butt = /obj/item/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 1500
	chem_volume = 20
	uses_multiple_cig_smoke_icons = FALSE

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"

/obj/item/clothing/mask/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best for the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 7200
	chem_volume = 30

/obj/item/cigbutt //This needs to stay here, it still appears in some random lists. Don't delete this without replacing every instance of it.
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	w_class = 1
	throwforce = 1

/obj/item/cigbutt/New()
	..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	transform = turn(transform,rand(0,360))

/obj/item/cigbutt/jointbutt
	name = "joint butt"
	desc = "A manky old joint butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "jointbutt"
	w_class = 1
	throwforce = 1

/obj/item/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/cigarette/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably made of meershaum or something."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	smoketime = 100
	uses_multiple_cig_smoke_icons = FALSE

/obj/item/clothing/mask/cigarette/pipe/light(var/flavor_text = "[usr] lights the [name].")
	if(!src.lit)
		src.lit = 1
		damtype = "fire"
		icon_state = icon_on
		item_state = icon_on
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		processing_objects.Add(src)

/obj/item/clothing/mask/cigarette/pipe/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		new /obj/effect/decal/cleanable/ash(location)
		if(ismob(loc))
			var/mob/living/M = loc
			M << "<span class='notice'>Your [name] goes out, and you empty the ash.</span>"
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			M.update_inv_wear_mask(0)
		processing_objects.Remove(src)
		return
	if(location)
		location.hotspot_expose(700, 5)
	return

/obj/item/clothing/mask/cigarette/pipe/attack_self(mob/user as mob) //Refills the pipe. Can be changed to an attackby later, if loose tobacco is added to vendors or something.
	if(lit == 1)
		user.visible_message("<span class='notice'>[user] puts out [src].</span>")
		lit = 0
		icon_state = icon_off
		item_state = icon_off
		processing_objects.Remove(src)
		return
	if(smoketime <= 0)
		user << "<span class='notice'>You refill the pipe with tobacco.</span>"
		smoketime = initial(smoketime)
	return



/////////
//ZIPPO//
/////////
/obj/item/flame/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	var/icon_on = "lighter-g-on"
	var/icon_off = "lighter-g"
	w_class = 1
	throwforce = 4
	flags = TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	attack_verb = list("burnt", "singed")

/obj/item/flame/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon_state = "zippo"
	item_state = "zippo"
	icon_on = "zippoon"
	icon_off = "zippo"

/obj/item/flame/lighter/blackzippo
	name = "\improper Black Zippo"
	desc = "The zippo."
	icon_state = "blackzippo"
	item_state = "zippo"
	icon_on = "blackzippoon"
	icon_off = "blackzippo"

/obj/item/flame/lighter/attack_self(mob/living/user)
	if(user.r_hand == src || user.l_hand == src)
		if(!lit)
			lit = 1
			icon_state = icon_on
			item_state = icon_on
			if(istype(src, /obj/item/flame/lighter/zippo) )
				user.visible_message("<b>[user]</b> flips open and lights [src] in one smooth movement.")
			else
				if(prob(95))
					user.visible_message("<b>[user]</b> manages to light the [src].")
				else
					user.adjustFireLoss(5)
					user.visible_message("<b>[user]</b> manages to light the [src], burning their finger in the process.</span>")

			set_light(2, 1, "#ffbf87")
			processing_objects.Add(src)
			playsound(src.loc, 'sound/webbers/lighteron.ogg', 40, 1)
		else
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			if(istype(src, /obj/item/flame/lighter/zippo) )
				user.visible_message("<b>[user]</b> shuts off [src].")
			else
				user.visible_message("<b>[user]</b> quietly shuts off the [src].")

			set_light(0)
			processing_objects.Remove(src)
			playsound(src.loc, 'sound/webbers/lighteroff.ogg', 40, 1)
	else
		return ..()
	return


/obj/item/flame/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!isliving(M))
		return
	M.IgniteMob()

	if(istype(M.wear_mask, /obj/item/clothing/mask/cigarette) && user.zone_sel.selecting == "mouth" && lit)
		var/obj/item/clothing/mask/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/flame/lighter/zippo))
				cig.light("<span class='rose'>[user] whips the [name] out and holds it for [M].</span>")
			else
				cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		..()

/obj/item/flame/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return


/obj/item/flame/lighter/pickup(mob/user)
	if(lit)
		set_light(2, 1, "#ffbf87")
	return


/obj/item/flame/lighter/dropped(mob/user)
	if(lit)
		set_light(2, 1, "#ffbf87")
	return
