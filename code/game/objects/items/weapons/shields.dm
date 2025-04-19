/obj/item/shield
	name = "shield"
	drop_sound = 'sound/effects/metalshield_drop.ogg'
	parry_chance = 35

/obj/item/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "riot"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
	g_amt = 7500
	m_amt = 1000
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

	IsShield()
		return 0

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item))
			if(cooldown < world.time - 25)
				user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
				playsound(user.loc, pick('sound/weapons/bash1.ogg','sound/weapons/bash2.ogg'), 50, 1)
				cooldown = world.time
		else
			..()

/obj/item/shield/wood
	name = "buckler shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "wbuckler"
	item_state = "wbuckler"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	item_worth = 16
	parry_chance = 40
	w_class = 4.0
	g_amt = 7500
	m_amt = 1000
	weight = 3
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	smelted_return = /obj/item/ore/refined/lw/ironlw

	IsShield()
		return 0

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item))
			if(cooldown < world.time - 25)
				user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
				playsound(user.loc, pick('sound/weapons/bash1.ogg','sound/weapons/bash2.ogg'), 50, 1)
				cooldown = world.time
		else
			..()

/obj/item/shield/fort
	name = "buckler shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "buckler"
	item_state = "buckler"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BACK
	force = 15
	force_wielded = 19
	force_unwielded = 15
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	item_worth = 16
	parry_chance = 50
	w_class = 4.0
	g_amt = 7500
	m_amt = 1000
	weight = 5
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

	IsShield()
		return 0

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item))
			if(cooldown < world.time - 25)
				user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
				playsound(user.loc, pick('sound/weapons/bash1.ogg','sound/weapons/bash2.ogg'), 50, 1)
				cooldown = world.time
		else
			..()


/obj/item/shield/copper
	name = "copper buckler shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cbuckler"
	item_state = "buckler"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BACK
	force = 12.5
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	item_worth = 6
	parry_chance = 25
	w_class = 4.0
	g_amt = 7500
	m_amt = 1000
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	weight = 5
	smelted_return = /obj/item/ore/refined/lw/copperlw
	IsShield()
		return 0

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item))
			if(cooldown < world.time - 25)
				user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
				playsound(user.loc, pick('sound/weapons/bash1.ogg','sound/weapons/bash2.ogg'), 50, 1)
				cooldown = world.time
		else
			..()

/obj/item/shield/largeshield
	name = "Shield of The Gate"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "largeshield"
	item_state = "largeshield"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BACK
	force = 12.5
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	item_worth = 20
	parry_chance = 55
	w_class = 4.0
	g_amt = 7500
	m_amt = 1000
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	weight = 5
	IsShield()
		return 0

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item))
			if(cooldown < world.time - 25)
				user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
				playsound(user.loc, pick('sound/weapons/bash1.ogg','sound/weapons/bash2.ogg'), 50, 1)
				cooldown = world.time
		else
			..()


/obj/item/shield/golden
	name = "golden buckler shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "gshield"
	item_state = "buckler"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BACK
	force = 12.5
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	item_worth = 38
	parry_chance = 25
	w_class = 4.0
	g_amt = 7500
	m_amt = 1000
	weight = 5
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	smelted_return = /obj/item/ore/refined/lw/goldlw

	IsShield()
		return 0

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item))
			if(cooldown < world.time - 25)
				user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
				playsound(user.loc, pick('sound/weapons/bash1.ogg','sound/weapons/bash2.ogg'), 50, 1)
				cooldown = world.time
		else
			..()


/obj/item/shield/crusader
	name = "crusader shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "paladin_shield"
	item_state = "crusader_shield"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	item_worth = 52
	parry_chance = 65
	w_class = 4.0
	g_amt = 7500
	m_amt = 1000
	weight = 5
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	smelted_return = /obj/item/ore/refined/lw/goldlw

	IsShield()
		return 0

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item))
			if(cooldown < world.time - 25)
				user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
				playsound(user.loc, pick('sound/weapons/bash1.ogg','sound/weapons/bash2.ogg'), 50, 1)
				cooldown = world.time
		else
			..()

/obj/item/shield/generator/wrist
	name = "wrist energy shield"
	wrist_use = TRUE
	icon = 'icons/obj/personal.dmi'
	icon_state = "braceshield" // eshield1 for expanded
	item_state = "spiked_bracelet"
	item_worth = 192
	active_state = "braceshield"
	off_state = "braceshield"

/obj/item/shield/generator
	name = "energy shield"
	desc = "A shield capable of deflecting most projectile and melee attacks. It can be retracted."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0" // eshield1 for expanded
	item_state = "energyshield"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	w_class = 4.0
	slot_flags = SLOT_BELT
	item_worth = 96
	var/obj/item/cell/crap/leet/CELL = null
	var/active = 0
	var/active_state = "shield1"
	var/off_state = "shield0"

/obj/item/shield/generator/New()
	..()
	CELL = new /obj/item/cell/crap/leet

/obj/item/shield/generator/MouseDrop(var/obj/over_object)
	var/mob/user = usr
	switch(over_object.name)
		if("r_hand")
			if(CELL)
				CELL.loc = get_turf(src.loc)
				user.put_in_hands(CELL)
				user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>removes the cell from the [src].</span>")
				playsound(src, 'sound/lfwbcombatuse/energy_unload.ogg', 25, 0)
				CELL = null
				active = 0
				update_icon()
			else
				to_chat(usr, "<span class='combat'><i>It has no cell!</i></span>")
		if("l_hand")
			if(CELL)
				CELL.loc = get_turf(src.loc)
				user.put_in_hands(CELL)
				user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>removes the cell from the [src].</span>")
				playsound(src, 'sound/lfwbcombatuse/energy_unload.ogg', 25, 0)
				CELL = null
				active = 0
				update_icon()
			else
				to_chat(usr, "<span class='combat'><i>It has no cell!</i></span>")

/obj/item/shield/generator/attackby(var/obj/item/A, var/mob/user)
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

/obj/item/shield/generator/update_icon()
	if(active)
		icon_state = active_state
	else
		icon_state = off_state

/obj/item/shield/generator/process()
	if(active)
		if(CELL.charge == 0)
			active = FALSE
			if(istype(loc, /mob/living/carbon/human))
				loc:update_icons()
			processing_objects.Remove(src)
		else if(CELL.charge > 0)
			CELL.charge = max(0, CELL.charge - 10)

/obj/item/shield/generator/RightClick(mob/living/carbon/human/user as mob)
	playsound(src.loc, 'sound/effects/shield2.ogg', 25, 0, -1)
	if(CELL.charge && active)
		active = 0
		processing_objects.Remove(src)
		update_icon()
		user.update_icons()
		src.add_fingerprint(user)
		return

	if(CELL.charge && !active)
		active = 1
		processing_objects.Add(src)
		update_icon()
		user.update_icons()
		src.add_fingerprint(user)
		return

/obj/item/shield/generator/proc/failure(mob/user as mob)
	var/mob/living/carbon/human/H = user
	if(active)
		to_chat(user, "[src] has been deactivated!")
		processing_objects.Remove(src)
		active = 0
		H.update_icons()
		update_icon()

/obj/item/shield/generator/dropped(mob/user as mob)
	var/mob/living/carbon/human/H = user
	if(active)
		active = 0
		processing_objects.Remove(src)
		H.update_icons()
		update_icon()

/obj/item/shield/generator/emp_act(severity)
	active = 0
	processing_objects.Remove(src)
	update_icon()
	if(ismob(loc))
		loc:update_icons()
	..()

/obj/item/cloaking_device
	name = "camouflage generator"
	desc = "Use this to become invisible to the human eyesocket."
	icon = 'icons/obj/device.dmi'
	icon_state = "bracecam"
	var/active = 0.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "spiked_bracelet"
	throwforce = 10.0
	throw_speed = 2
	wrist_use = TRUE
	throw_range = 10
	item_worth = 80
	w_class = 1.0
	origin_tech = "magnets=3;syndicate=4"
	var/area_locked

/obj/item/cloaking_device/brothel
	name = "brothel camouflage generator"
	desc = "Use this to become invisible to the human eyesocket, it'll only work in the brothel."
	icon = 'icons/obj/device.dmi'
	icon_state = "bracecamb"
	area_locked = /area/dunwell/station/brothel

/obj/item/cloaking_device/RightClick(mob/user as mob)
	var/mob/living/carbon/human/H = user
	src.active = !( src.active )
	playsound(src.loc, 'sound/webbers/console_interact1.ogg', 25, 0, -1)
	if (src.active)
		to_chat(user, "The cloaking device is now active.")
		H.update_icons()
	else
		to_chat(user, "The cloaking device is now inactive.")
		H.update_icons()
	src.add_fingerprint(user)
	return
/obj/item/cloaking_device/dropped(mob/user as mob)
	var/mob/living/carbon/human/H = user
	if(src.active)
		to_chat(user, "The cloaking device is now inactive.")
		src.active = 0
		H.update_icons()

/obj/item/cloaking_device/emp_act(severity)
	active = 0
	if(ismob(loc))
		loc:update_icons()
	..()
