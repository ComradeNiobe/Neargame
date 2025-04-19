/obj/item/clothing
	name = "clothing"
	var/list/species_restricted = null //Only these species can wear this kit.
	var/fatmaywear = 1
	drop_sound = 'sound/effects/drop_clothing.ogg'
	item_worth = 5
	var/armor_type = ARMOR_ROUPA
	var/DR = 0 //damage resistance
	var/PD = 0 //passive defense
	var/impale_weak
	var/obj/item/clothing/armor_layer
	var/can_layer = FALSE
	var/layerable = FALSE
	var/simple_icon = FALSE

/obj/item/clothing/Destroy()
	. = ..()

//BS12: Species-restricted clothing check.
/obj/item/clothing/mob_can_equip(M as mob, slot)

	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(!fatmaywear)
			if(FAT in H.mutations)
				return 0

		if(species_restricted)

			var/wearable = null
			var/exclusive = null

			if("exclude" in species_restricted)
				exclusive = 1

			if(H.species)
				if(istype(H.species, /datum/species/xenos))		//A little dirty, but...
					M << "\red How do you imagine wearing [src]?"
					return 0
				if(exclusive)
					if(!(H.species.name in species_restricted))
						wearable = 1
				else
					if(H.species.name in species_restricted)
						wearable = 1

				if(!wearable && (slot != 15 && slot != 16)) //Pockets.
					M << "\red Your species cannot wear [src]."
					return 0

	return ..()

/obj/item/clothing/attack_hand(var/mob/user)
	if(!user) return
	if(armor_layer && loc == user)
		remove_armor_layer(user)
		return
	..()

//Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = 1.0
	throwforce = 2
	slot_flags = SLOT_EARS
	var/happiness = 0

/obj/item/clothing/ears/attack_hand(mob/user as mob)
	if (!user) return

	if (src.loc != user || !istype(user,/mob/living/carbon/human))
		..()
		return

	var/mob/living/carbon/human/H = user
	if(H.l_ear != src && H.r_ear != src)
		..()
		return

	if(!canremove)
		return

	var/obj/item/clothing/ears/O
	if(slot_flags & SLOT_TWOEARS )
		O = (H.l_ear == src ? H.r_ear : H.l_ear)
		user.u_equip(O)
		if(!istype(src,/obj/item/clothing/ears/offear))
			qdel(O)
			O = src
	else
		O = src

	user.u_equip(src)

	if (O)
		user.put_in_hands(O)
		O.add_fingerprint(user)

	if(istype(src,/obj/item/clothing/ears/offear))
		qdel(src)

/obj/item/clothing/ears/offear
	name = "Other ear"
	w_class = 5.0
	icon = 'icons/mob/screen1_Midnight.dmi'
	icon_state = "block"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

	New(var/obj/O)
		name = O.name
		desc = O.desc
		icon = O.icon
		icon_state = O.icon_state
		dir = O.dir

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earring
	name = "ear ring"
	desc = "An earring."
	icon = 'icons/life/earring.dmi'
	icon_state = ""
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/earring/equipped(mob/M, var/slot)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(slot == slot_r_ear)
		H.add_event("sheekos", /datum/happiness_event/misc/sheekos)
	else
		H.clear_event("sheekos")

/obj/item/clothing/ears/earring/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	H.clear_event("sheekos")

/obj/item/clothing/ears/earring/gold
	name = "ear ring"
	desc = "A luxurious golden earring"
	icon = 'icons/life/earring.dmi'
	icon_state = "gold_earring"
	item_worth = 19
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earring/silver
	name = "ear ring"
	desc = "A luxurious silver earring"
	icon = 'icons/life/earring.dmi'
	icon_state = "silver_earring"
	item_worth = 13
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	silver = TRUE

/obj/item/clothing/ears/earring/copper
	name = "ear ring"
	desc = "A copper earring"
	icon = 'icons/life/earring.dmi'
	icon_state = "copper_earring"
	item_worth = 3
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earring/bone
	name = "ear ring"
	desc = "An earring made of bone"
	icon = 'icons/life/earring.dmi'
	icon_state = "bone_earring"
	item_worth = 2 // Disgusting animal..
	slot_flags = SLOT_EARS | SLOT_TWOEARS

//Glasses
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = 2.0
	flags = GLASSESCOVERSEYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/invisa_view = 0

/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/


//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = 2.0
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.50
	var/wired = 0
	var/obj/item/cell/cell = 0
	var/clipped = 0
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	species_restricted = list("exclude","Unathi","Tajaran")
	fatmaywear = 1
	var/blocks_firing = FALSE //If the gloves are too big to fit into a trigger guard.

/obj/item/clothing/gloves/examine()
	set src in usr
	..()
	return

/obj/item/clothing/gloves/emp_act(severity)
	if(cell)
		cell.charge -= 1000 / severity
		if (cell.charge < 0)
			cell.charge = 0
		if(cell.reliability != 100 && prob(50/severity))
			cell.reliability -= 10 / severity
	..()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()

//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	layerable = TRUE

/obj/item/clothing/head/add_armor_layer(var/obj/item/I, var/mob/user)
	if(user:head != src)
		return
	var/image/stateover = image("icon" = I.icon, "icon_state" = "[I.icon_state]")
	stateover.layer = FLOAT_LAYER
	user.drop_item()
	armor_layer = I
	I.loc = src
	overlays += stateover
	to_chat(user,"You're now wearing \a [I] on your [src]!")
	user:update_inv_head(1)

/obj/item/clothing/head/remove_armor_layer(var/mob/user)
	..()
	user:update_inv_head(1)


//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK

/obj/item/clothing/mask/proc/d_filter_air(datum/gas_mixture/air)
	return

//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	var/chained = 0
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET
	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	species_restricted = list("exclude","Unathi","Tajaran","Child")
	fatmaywear = 1

//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	flags = FPRINT | TABLEPASS
	allowed = list()
	armor = list(melee = 5, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	var/hide_uniform_sleeves = FALSE

/obj/item/clothing/suit/add_armor_layer(var/obj/item/I, var/mob/user)
	if(user:wear_suit != src)
		return
	var/image/stateover = image("icon" = I.icon, "icon_state" = "[I.icon_state]")
	stateover.layer = FLOAT_LAYER
	user.drop_item()
	armor_layer = I
	I.loc = src
	overlays += stateover
	to_chat(user,"You're now wearing \a [I] on your [src]!")
	user:update_inv_wear_suit(1)

/obj/item/clothing/suit/remove_armor_layer(var/mob/user)
	..()
	user:update_inv_wear_suit(1)
/*
/obj/item/clothing/suit/proc/update_above(var/mob/living/carbon/human/H,var/lying = 0)
	if(simple_icon)
		return
	var/s = lying ? "2" : ""
	var/list/icon/parts = list() //body 1, lower 2, left 3, right 4
	var/icon/suit = icon('icons/mob/human.dmi',"blank")
	if(istype(H.species,/datum/species/human/child))
		parts = male_icons
	else if(FAT in H.mutations)
		parts = fat_icons
	else if(H.gender == FEMALE)
		parts = female_icons
	else
		parts = male_icons
	if(body_parts_covered & ARM_LEFT)
		var/chunk = icon(parts[3],icon_state = "[icon_state][s]")
		suit.Blend(chunk,ICON_OVERLAY)
	if(body_parts_covered & ARM_RIGHT)
		var/chunk = icon(parts[4],icon_state = "[icon_state][s]")
		suit.Blend(chunk,ICON_OVERLAY)
	if(armor_layer)
		var/list/over = armor_layer:update_above(H)
		suit.Blend(over,ICON_OVERLAY)
	return suit


/obj/item/clothing/suit/proc/update_worn_icon(var/mob/living/carbon/human/H,var/lying = 0)
	var/s = lying ? "2" : ""
	if(simple_icon)
		var/icon/suit = icon('icons/mob/clothing/suit.dmi',"[icon_state][s]")
		if(armor_layer)
			suit.Blend(armor_layer:update_worn_icon(H),ICON_OVERLAY)
		return suit
	var/list/icon/parts = list() //body 1, lower 2, left 3, right 4
	var/icon/suit = icon('icons/mob/human.dmi',"blank")
	if(istype(H.species,/datum/species/human/child))
		parts = male_icons
	else if(FAT in H.mutations)
		parts = fat_icons
	else if(H.gender == FEMALE)
		parts = female_icons
//		if(H.pregnant)
	//	parts[1] = 'icons/mob/clothing/suit_parts_female_plus.dmi'
	else
		parts = male_icons
	//body
	var/body_chunk = icon(parts[1],icon_state = "[icon_state][s]")
	suit.Blend(body_chunk,ICON_OVERLAY)
	//legs
	if(body_parts_covered & LEGS_TOGETHER) //&& (body_parts_covered & LEG_LEFT || body_parts_covered & LEG_RIGHT))
		var/chunk = icon(parts[2],icon_state = "[icon_state][s]")
		suit.Blend(chunk,ICON_OVERLAY)
	else
		if(body_parts_covered & LEG_LEFT)
			var/chunk = icon(parts[2],icon_state = "[icon_state]_l_leg[s]")
			suit.Blend(chunk,ICON_OVERLAY)
		if(body_parts_covered & LEG_RIGHT)
			var/chunk = icon(parts[2],icon_state = "[icon_state]_r_leg[s]")
			suit.Blend(chunk,ICON_OVERLAY)

	if(armor_layer)
		var/list/over = armor_layer:update_worn_icon(H)
		suit.Blend(over,ICON_OVERLAY)

	return suit
*/
/obj/item/clothing/proc/remove_part(var/part)
	body_parts_covered  &= ~part

//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|GROIN
	permeability_coefficient = 0.90
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/has_sensor = 1//For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/obj/item/clothing/tie/hastie = null
	var/obj/item/medal/medal_attached = null
	var/image/medal_overlay = null
	var/displays_id = 1
	var/sleeves = 2
	var/pants_down = FALSE

/obj/item/clothing/under/MiddleClick(mob/living/carbon/human/user as mob)
	user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
	if(sleeves > 0)
		to_chat(user, "<span class='passive'>You begin to rip [src] sleeve.</span>")
		if(do_after(user,30))
			user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>rips a sleeve from</span> <span class='passive'>[src]</span><span class='passive'>!</span>")
			sleeves -= 1
			var/obj/item/clothing/mask/sleeve/S = new(user.loc)
			S.colorize(src)
			user.put_in_hands(S)
			playsound(src.loc, 'sound/misc/cloth_rip.ogg', 80, 1)
	else
		to_chat(user, "<span class='passivebold'>There's no sleeves for me to rip!</span>")

/obj/item/clothing/under/attack_hand(mob/user as mob)

	if(pants_down)
		to_chat(user,"<span class='redtext'>I Must pull my pants up first!</span>")
		return
	..()


/obj/item/clothing/under/MouseDrop(var/obj/over_object)
	..()
	//if(!istype(src.loc,/mob) || src.loc:w_uniform != src)
	//	return
	if(over_object.name != "i_clothing"  || !istype(over_object, /obj/screen/inventory))
		return
	pull_pants(loc)

/obj/item/clothing/under/dropped()//should only be called by someone stripping the wearer
	..()
	pants_down = FALSE

/obj/item/clothing/under/proc/pull_pants(var/mob/owner, var/mob/user)
	var/mob/living/carbon/human/H = user ? user : owner

	if(do_after(H, 1 SECONDS))
		pants_down = !pants_down
//		owner:update_pants(1)
		playsound(owner.loc, 'sound/effects/drop_clothing.ogg', 50, 1)
		owner.visible_message("<span class = 'bluetext'><B>[H]</B></span> <span class='bluetext'>pulls [user ? "[owner]'s" : "their"] pants [pants_down ? "down" : "up"].</span>")





/obj/item/clothing/proc/add_armor_layer(obj/item/I, mob/user)
	return


/obj/item/clothing/attackby(obj/item/I, mob/user)
	if(!can_layer)
		return ..()
	if(!istype(I,/obj/item/clothing) || !I:layerable)
		return ..()
	if(armor_layer)
		return ..()
	add_armor_layer(I,user)

/obj/item/clothing/proc/remove_armor_layer(mob/user)
	if(!layer || loc != user)
		return
	var/image/stateover = image("icon" = armor_layer.icon, "icon_state" = "[armor_layer.icon_state]")
	overlays -= stateover
	user.put_in_hands(armor_layer)
	armor_layer = null

/obj/item/clothing/under/proc/attachTie(obj/item/I, mob/user)
	if(istype(I, /obj/item/clothing/tie))
		if(hastie)
			if(user)
				user << "<span class='warning'>[src] already has an accessory.</span>"
			return
		else
			if(user)
				user.drop_item()
			hastie = I
			I.loc = src
			if(user)
				user << "<span class='notice'>You attach [I] to [src].</span>"
			I.transform *= 0.5	//halve the size so it doesn't overpower the under
			I.pixel_x += 8
			I.pixel_y -= 8
			I.layer = FLOAT_LAYER
			overlays += I


			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				H.update_inv_w_uniform(0)

			return

/obj/item/clothing/under/examine()
	set src in view()
	..()
	switch(src.sensor_mode)
		if(0)
			usr << "Its sensors appear to be disabled."
		if(1)
			usr << "Its binary life sensors appear to be enabled."
		if(2)
			usr << "Its vital tracker appears to be enabled."
		if(3)
			usr << "Its vital tracker and tracking beacon appear to be enabled."
	if(hastie)
		usr << "\A [hastie] is clipped to it."

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	var/mob/M = usr
	if (istype(M, /mob/dead/)) return
	if (usr.stat) return
	if(src.has_sensor >= 2)
		usr << "The controls are locked."
		return 0
	if(src.has_sensor <= 0)
		usr << "This suit does not have any sensors."
		return 0
	src.sensor_mode += 1
	if(src.sensor_mode > 3)
		src.sensor_mode = 0
	switch(src.sensor_mode)
		if(0)
			usr << "You disable your suit's remote sensing equipment."
		if(1)
			usr << "Your suit will now report whether you are live or dead."
		if(2)
			usr << "Your suit will now report your vital lifesigns."
		if(3)
			usr << "Your suit will now report your vital lifesigns as well as your coordinate position."
	return

/obj/item/clothing/under/verb/removetie()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(hastie)
		if (istype(hastie,/obj/item/clothing/tie/holster))
			verbs -= /obj/item/clothing/under/proc/holster

		if (istype(hastie,/obj/item/clothing/tie/storage))
			verbs -= /obj/item/clothing/under/proc/storage
			var/obj/item/clothing/tie/storage/W = hastie
			if (W.hold)
				W.hold.close(usr)

		usr.put_in_hands(hastie)
		hastie = null

		if(istype(loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()

/obj/item/clothing/under/rank/New()
	sensor_mode = pick(0,1,2,3)
	..()

/obj/item/clothing/under/proc/holster()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if (!hastie || !istype(hastie,/obj/item/clothing/tie/holster))
		usr << "\red You need a holster for that!"
		return
	var/obj/item/clothing/tie/holster/H = hastie

	if(!H.holstered)
		if(!istype(usr.get_active_hand(), /obj/item/gun))
			usr << "\blue You need your gun equiped to holster it."
			return
		var/obj/item/gun/W = usr.get_active_hand()
		if (!W.isHandgun())
			usr << "\red This gun won't fit in \the [H]!"
			return
		H.holstered = usr.get_active_hand()
		usr.drop_item()
		H.holstered.loc = src
		usr.visible_message("\blue \The [usr] holsters \the [H.holstered].", "You holster \the [H.holstered].")
	else
		if(istype(usr.get_active_hand(),/obj) && istype(usr.get_inactive_hand(),/obj))
			usr << "\red You need an empty hand to draw the gun!"
		else
			if(usr.a_intent == "hurt")
				usr.visible_message("\red \The [usr] draws \the [H.holstered], ready to shoot!", \
				"\red You draw \the [H.holstered], ready to shoot!")
			else
				usr.visible_message("\blue \The [usr] draws \the [H.holstered], pointing it at the ground.", \
				"\blue You draw \the [H.holstered], pointing it at the ground.")
			usr.put_in_hands(H.holstered)
			H.holstered = null

/obj/item/clothing/under/proc/storage()
	set name = "Look in storage"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if (!hastie || !istype(hastie,/obj/item/clothing/tie/storage))
		usr << "\red You need something to store items in for that!"
		return
	var/obj/item/clothing/tie/storage/W = hastie

	if (!istype(W.hold))
		return

	W.hold.loc = usr
	W.hold.attack_hand(usr)

/obj/item/clothing/under/proc/update_overclothes(var/mob/living/carbon/human/H)
	return


/obj/item/clothing/under/proc/add_color(var/icon/I)
	return I
/*
/obj/item/clothing/under/proc/update_body(var/mob/living/carbon/human/H, var/lying = FALSE)
	var/s = lying ? "l" : "s"
	var/base = null
	var/icon/body = icon('icons/mob/human.dmi',"blank")
	if(istype(H.species,/datum/species/human/child))
		base = male_icons[1]
	else if(FAT in H.mutations)
		base	= fat_icons[1]
	else if(H.gender == FEMALE)
		base	= female_icons[1]
	//	if(H.pregnant)
		//	base =  'icons/mob/clothing/under_female_plus.dmi'
	else
		base	= male_icons[1]
	if(male_icons.len == 1)
		var/chunk = icon(base,"[icon_state]_body_[s]")
		body.Blend(chunk,ICON_OVERLAY)
	else
		var/num = s == "s" ? "" : "2" //painful
		var/chunk = icon(base,"[icon_state][num]")
		body.Blend(chunk,ICON_OVERLAY)
	return body

/obj/item/clothing/under/proc/update_sleeves(var/mob/living/carbon/human/H, var/lying = FALSE, var/list/dirs)
	var/s = lying ? "l" : "s"
	if(male_icons.len == 1)
		var/base = null
		var/icon/sleeves = icon('icons/mob/human.dmi',"blank")
		if(istype(H.species,/datum/species/human/child))
			base = male_icons[1]
		else if(FAT in H.mutations)
			base	= fat_icons[1]
		else if(H.gender == FEMALE)
			base	= female_icons[1]
		else
			base	= male_icons[1]
		if((body_parts_covered & ARM_LEFT) && dirs["left"])
			var/chunk = icon(base,icon_state = "[icon_state]_l_arm_[s]")
			sleeves.Blend(chunk,ICON_OVERLAY)
		if((body_parts_covered & ARM_RIGHT) && dirs["right"])
			var/chunk = icon(base,icon_state = "[icon_state]_r_arm_[s]")
			sleeves.Blend(chunk,ICON_OVERLAY)

		return sleeves
	else
		//body 1, lower 2, left 3, right 4
		var/list/parts
		var/num = s == "s" ? "" : "2" //painful
		var/icon/sleeves = icon('icons/mob/human.dmi',"blank")
		if(istype(H.species,/datum/species/human/child))
			parts = male_icons
		else if(FAT in H.mutations)
			parts	= fat_icons
		else if(H.gender == FEMALE)
			parts	= female_icons
		else
			parts	= male_icons
		if((body_parts_covered & ARM_LEFT) && dirs["left"])
			var/chunk = icon(parts[3],icon_state = "[icon_state][num]")
			sleeves.Blend(chunk,ICON_OVERLAY)
		if((body_parts_covered & ARM_RIGHT) && dirs["right"])
			var/chunk = icon(parts[4],icon_state = "[icon_state][num]")
			sleeves.Blend(chunk,ICON_OVERLAY)
		return sleeves


/obj/item/clothing/under/proc/update_pants(var/mob/living/carbon/human/H, var/lying = FALSE)
	var/s = lying ? "l" : "s"
	var/icon/pants = icon('icons/mob/human.dmi',"blank")
	if(!pants_down)
		if(male_icons.len == 1)
			var/base = null
			if(istype(H.species,/datum/species/human/child))
				base = male_icons[1]
			else if(FAT in H.mutations)
				base	= fat_icons[1]
			else if(H.gender == FEMALE)
				base	= female_icons[1]
			else
				base	= male_icons[1]
			if(body_parts_covered & LEG_LEFT)
				var/chunk = icon(base,icon_state = "[icon_state]_l_leg_[s]")
				pants.Blend(chunk,ICON_OVERLAY)
			if(body_parts_covered & LEG_RIGHT)
				var/chunk = icon(base,icon_state = "[icon_state]_r_leg_[s]")
				pants.Blend(chunk,ICON_OVERLAY)
			return pants
		else
			//body 1, lower 2, left 3, right 4
			var/num = s == "s" ? "" : "2" //painful
			var/list/parts
			if(istype(H.species,/datum/species/human/child))
				parts = male_icons
			else if(FAT in H.mutations)
				parts	= fat_icons
			else if(H.gender == FEMALE)
				parts	= female_icons
			else
				parts	= male_icons
			if(body_parts_covered & LEG_LEFT)
				var/chunk = icon(parts[2],icon_state = "[icon_state]_l_leg[num]")
				pants.Blend(chunk,ICON_OVERLAY)
			if(body_parts_covered & LEG_RIGHT)
				var/chunk = icon(parts[2],icon_state = "[icon_state]_r_leg[num]")
				pants.Blend(chunk,ICON_OVERLAY)
	else
		var/num = s == "s" ? "0" : "1" //painful
		var/chunk = icon('icons/mob/clothing/pants_male.dmi',icon_state = "[icon_state][num]")
		pants.Blend(chunk,ICON_OVERLAY)

	return pants

*/

/obj/item/proc/negates_gravity()
	return 0
