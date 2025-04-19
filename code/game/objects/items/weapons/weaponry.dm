/obj/item/sharpness = 80
/obj/item/var/weaponteaching = null
/obj/item/var/speciality

/obj/item/banhammer
	desc = "A banhammer"
	name = "banhammer"
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15
	attack_verb = list("banned")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is hitting \himself with the [src.name]! It looks like \he's trying to ban \himself from life.</b>"
		return (BRUTELOSS|FIRELOSS|TOXLOSS|OXYLOSS)

/obj/item/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullrod"
	item_state = "nullrod"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = 18
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = 1

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (BRUTELOSS|FIRELOSS)

/obj/item/nullrod/attack(mob/M as mob, mob/living/user as mob) //Paste from old-code to decult with a null rod.

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")

	msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if (!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		user << "\red You don't have the dexterity to do this!"
		return

	if ((CLUMSY in user.mutations) && prob(50))
		user << "\red The rod slips out of your hand and hits your head."
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

//	if (M.stat !=2)
	/*
		if((M.mind in ticker.mode.cult) && prob(33))
			M << "\red The power of [src] clears your mind of the cult's influence!"
			user << "\red You wave [src] over [M]'s head and see their eyes become clear, their mind returning to normal."
			ticker.mode.remove_cultist(M.mind)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red [] waves [] over []'s head.", user, src, M), 1)
		else if(prob(10))
			user << "\red The rod slips in your hand."
			..()
		else
			user << "\red The rod appears to do nothing."
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red [] waves [] over []'s head.", user, src, M), 1)
			return
		*/

/*
/obj/item/nullrod/afterattack(atom/A, mob/user as mob)
	if (istype(A, /turf/simulated/floor))
		user << "\blue You hit the floor with the [src]."
		call(/obj/effect/rune/proc/revealrunes)(src)
*/
/obj/item/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon_state = "sord"
	item_state = "sord"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = 4
	sharp = 1
	edge = 1
	throwforce = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "sliced", "torn", "ripped", "diced", "cut")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return(BRUTELOSS)

/obj/item/sord/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/claymore
	name = "steel broadsword"
	desc = "A rather impressive formation of steel. Could cleave a man in half with one of these, even if they're a bit unwieldy and illogical for cave combat."
	icon_state = "broadsword"
	item_state = "claymore"
	blooded_icon = FALSE
	blood_suffix = "b"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 30
	force_wielded = 35
	force_unwielded = 30
	sharp = 1
	edge = 0
	throwforce = 10
	w_class = 4
	parry_chance = 20
	weaponteaching = "SWORD"
	drawsound = "unsheath"
	drop_sound = 'sound/effects/drop_sword.ogg'
	hitsound= "blade"
	equip_sound = "sheath"
	attack_verb = list("slices", "cuts", "dices")
	item_worth = 18
	sheathicon = "sword_sh1"
	speciality = SKILL_SWORD
	weight = 3
	weapon_speed_delay = 14
	var/atk_mode = SLASH
	smelted_return = /obj/item/ore/refined/lw/ironlw

	IsShield()
		return 1

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is falling on the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return(BRUTELOSS)

/obj/item/claymore/attack_self(mob/user)
	..()
	if(atk_mode == SLASH)
		atk_mode = STAB
		to_chat(user, "You will now stab.")
		edge = 1
		sharp = 0
		attack_verb = list("stabs")
		hitsound = "stab"
		return

	else if(atk_mode == STAB)
		atk_mode = BASH
		to_chat(user, "You will now bash with the hilt.")
		edge = 0
		sharp = 0
		attack_verb = list("hits", "clubs")
		hitsound = "crowbar_hit"
		force = force/2
		return


	else if(atk_mode == BASH)
		atk_mode = SLASH
		to_chat(user, "You will now slash.")
		attack_verb = list("slashes", "dices", "cuts")
		hitsound = initial(hitsound)
		edge = 0
		sharp = 1
		force = force*2
		return


/obj/item/claymore/bastard
	name = "bastard sword"
	desc = "There is no greater a companion than steel at your hip. The Bastard-sword has existed long before the Night, it will protect you."
	icon_state = "bastard"
	item_state = "bastard"
	force = 30
	force_wielded = 55
	force_unwielded = 30
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	item_worth = 18
	parry_chance = 15
	weight = 5
	sheathicon = "sword_sh10"
	weapon_speed_delay = 18
	slot_flags = SLOT_BELT | SLOT_BACK
	smelted_return = /obj/item/ore/refined/lw/ironlw

/obj/item/claymore/siege
	name = "siege sword"
	desc = "A large steel sword. Durable and sharp"
	icon_state = "siegesword"
	item_state = "bastard"
	force = 30
	force_wielded = 55
	force_unwielded = 30
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	item_worth = 18
	parry_chance = 15
	weight = 5
	sheathicon = "sword_sh10"
	weapon_speed_delay = 18
	slot_flags = SLOT_BELT | SLOT_BACK
	smelted_return = /obj/item/ore/refined/lw/steellw

/obj/item/claymore/reddawn
	name = "trax sword"
	desc = "A large sword coated in red leather. It's seen and caused tragedy."
	icon_state = "trax"
	item_state = "bastard"
	force = 30
	force_wielded = 55
	force_unwielded = 30
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	item_worth = 24
	parry_chance = 15
	weight = 5
	sheathicon = "sword_sh10"
	weapon_speed_delay = 18
	slot_flags = SLOT_BELT | SLOT_BACK
	smelted_return = /obj/item/ore/refined/lw/ironlw

/obj/item/claymore/bastard/silver
	name = "silver bastard sword"
	desc = "Silver may not be as durable as steel, but it'll give you peace against the horrors in the dark."
	icon_state = "sbastard"
	item_state = "bastard"
	force = 20
	force_wielded = 45
	force_unwielded = 20
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	item_worth = 44
	parry_chance = 15
	weight = 3
	sheathicon = "sword_sh10"
	silver = TRUE
	smelted_return = /obj/item/ore/refined/lw/silverlw

/obj/item/claymore/adamantium
	name = "adamantium sword"
	desc = "A sword made of rare Adamantium. You'll be a hero or whoreson with this tonight."
	icon_state = "adsword"
	item_state = "claymore"
	force = 90
	force_wielded = 100
	force_unwielded = 90
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	item_worth = 375
	parry_chance = 35
	weight = 1
	sheathicon = "sword_sh7"
	weapon_speed_delay = 6
	smelted_return = /obj/item/ore/refined/lw/adamantinelw

/obj/item/claymore/copper
	name = "copper sword"
	desc = "While copper is worse in every way to iron, it is incredibly cheap and easy to maintain."
	icon_state = "coppersword"
	item_state = "claymore"
	force = 25
	force_wielded = 30
	force_unwielded = 25
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	item_worth = 6
	weight = 2
	parry_chance = 20
	sheathicon = "sword_sh6"
	smelted_return = /obj/item/ore/refined/lw/copperlw

/obj/item/claymore/golden
	name = "golden sword"
	desc = "Fit for a king."
	icon_state = "goldensword"
	item_state = "goldenclaymore"
	force = 25
	force_wielded = 30
	force_unwielded = 25
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	item_worth = 38
	parry_chance = 20
	weight = 2
	sheathicon = "sword_sh12"
	smelted_return = /obj/item/ore/refined/lw/goldlw

/obj/item/claymore/scimitar
	name = "Scimitar"
	desc = "An exotic curved sword, not common in Evergreen for it's association with Soulbreakers"
	icon_state = "scimitar"
	item_state = "sabre"
	force = 35
	force_wielded = 40
	force_unwielded = 35
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	item_worth = 64
	weapon_speed_delay = 16
	parry_chance = 15
	weight = 2
	sheathicon = "sword_sh4"

/obj/item/claymore/rusty
	name = "rusty sword"
	desc = "This sword has seen better nights."
	icon_state = "rustybroadsword"
	item_state = "claymore"
	force = 25
	force_wielded = 30
	force_unwielded = 25
	sharp = 0
	edge = 1
	throwforce = 5
	w_class = 4
	item_worth = 0
	weight = 3
	parry_chance = 0
	sheathicon = "sword_sh9"

/obj/item/claymore/rusty/sabre
	name = "rusty sabre"
	desc = "This sabre has seen better nights."
	icon_state = "rustysabre"
	item_state = "sabre"
	force = 20
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	item_worth = 0
	parry_chance = 5
	weight = 3
	sheathicon = "sword_sh9"
	weapon_speed_delay = 10

/obj/item/claymore/rusty/sabre/wield(mob/user)
	to_chat(user, "You can't wield a sabre with two hands!")
	return

/obj/item/claymore/rusty/rapier
	name = "rusty rapier"
	desc = "This weapon has seen better nights."
	icon_state = "rustyrapier"
	item_state = "sabre"
	force = 15
	sharp = 0
	edge = 1
	throwforce = 11
	w_class = 4
	item_worth = 0
	weight = 3
	parry_chance = 10
	sheathicon = "sword_sh9"
	weapon_speed_delay = 6

/obj/item/claymore/gladius
	name = "Gladius sword"
	icon_state = "gladius"
	item_state = "claymore"
	force = 35
	force_wielded = 40
	force_unwielded = 35
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	item_worth = 46
	parry_chance = 20
	weight = 5
	sheathicon = "sword_sh14"

/obj/item/claymore/wood
	name = "wooden sword"
	icon_state = "wsword"
	item_state = "wsword"
	force = 5
	force_wielded = 10
	force_unwielded = 5
	hitsound= "hitsound"
	sharp = 0
	edge = 0
	throwforce = 5
	w_class = 4
	parry_chance = 30
	item_worth = 6
	sheathicon = "sword_sh8"
	blooded_icon = FALSE
	blood_suffix = null
	weight = 1
	weapon_speed_delay = 8

/obj/item/claymore/axe
	name = "wooden axe"
	icon_state = "traxe"
	item_state = "traxe"
	force = 5
	force_wielded = 10
	force_unwielded = 5
	hitsound= "hitsound"
	sharp = 0
	edge = 0
	throwforce = 5
	w_class = 4
	parry_chance = 30
	item_worth = 6
	blooded_icon = FALSE
	blood_suffix = null
	speciality = SKILL_SWING
	weight = 1
	weapon_speed_delay = 8


/obj/item/claymore/wood/attack_self(mob/user)
	return


/obj/item/claymore/silver
	name = "silver sword"
	desc = "Silver isn't a logical thing to make a sword out of, unless if you're a chimerian fearing man!"
	icon_state = "silversword"
	item_state = "claymore"
	force = 25
	force_wielded = 30
	force_unwielded = 25
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 4
	parry_chance = 20
	item_worth = 44
	silver = TRUE
	sheathicon = "sword_sh5"
	weight = 3
	smelted_return = /obj/item/ore/refined/lw/silverlw

/obj/item/claymore/spear
	name = "spear"
	desc = "The weapon of the masses. Many a proud Knights have died to a dozen of these!"
	icon_state = "spear"
	item_state = "spear"
	penetrating = TRUE
	force = 25
	force_wielded = 40
	force_unwielded = 25
	sharp = 0
	edge = 1
	throwforce = 75
	w_class = 5
	parry_chance = -28
	item_worth = 16
	slot_flags = SLOT_BACK
	weaponteaching = "SPEAR"
	blooded_icon = 0
	blood_suffix = null
	sheathicon = null
	embedicon = "spear"
	hitsound= "stab"
	speciality = SKILL_STAFF
	weight = 12
	smelted_return = /obj/item/ore/refined/lw/ironlw
	item_reach = 2

/obj/item/claymore/cspear
	name = "copper spear"
	desc = "Popularized by low-end milita troops. Arguably the most useful weapon for its cost in Evergreen!"
	icon_state = "cspear"
	item_state = "spear"
	force = 20
	force_wielded = 35
	force_unwielded = 20
	sharp = 0
	edge = 1
	throwforce = 75
	w_class = 5
	parry_chance = -28
	item_worth = 8
	slot_flags = SLOT_BACK
	blooded_icon = 0
	blood_suffix = null
	embedicon = "spear"
	speciality = SKILL_STAFF
	sheathicon = null
	hitsound= "stab"
	weight = 5
	smelted_return = /obj/item/ore/refined/lw/copperlw
	item_reach = 2

/obj/item/claymore/wspear
	name = "wooden spear"
	desc = "Commonly seen in the hands of untrained conscripts, skinless and other poor-fucking-bastards."
	icon_state = "wspear"
	item_state = "spear"
	force = 15
	force_wielded = 30
	force_unwielded = 15
	sharp = 0
	edge = 1
	throwforce = 35
	w_class = 5
	parry_chance = -45
	weaponteaching = "SPEAR"
	embedicon = "spear"
	slot_flags = SLOT_BACK
	item_worth = 5
	speciality = SKILL_STAFF
	sheathicon = null
	hitsound= "stab"
	weight = 3
	item_reach = 2

/obj/item/claymore/rapier
	name = "rapier"
	desc = "An elegant steel rapier for the nobility to stab smerds with."
	icon_state = "rapier"
	item_state = "rapier"
	force = 20
	force_wielded = 20
	force_unwielded = 20
	sharp = 0
	edge = 1
	throwforce = 15
	w_class = 4
	item_worth = 30
	weight = 3
	parry_chance = 30
	sheathicon = "sword_sh9"
	drawsound = 'sound/lfwbcombatuse/rapier.ogg'
	hitsound= "stab"
	attack_verb = list("stabs")
	weapon_speed_delay = 6
	smelted_return = /obj/item/ore/refined/lw/steellw

/obj/item/claymore/rapier/xeno
	name = "sharp claws"
	desc = "A mighty claw."
	icon_state = null
	item_state = null

/obj/item/claymore/tribal_spear
	name = "wei-ji spear"
	icon_state = "tribal_spear"
	item_state = "tribal_spear"
	wielded_icon = "tribal_spear"
	wielded_underlay = TRUE
	force = 25
	force_wielded = 40
	force_unwielded = 25
	sharp = 0
	edge = 1
	throwforce = 60
	w_class = 5
	parry_chance = -35
	item_worth = 24
	weaponteaching = "SPEAR"
	speciality = SKILL_STAFF
	slot_flags = SLOT_BACK
	sheathicon = null
	hitsound= "stab"
	weight = 5

/obj/item/claymore/bardiche
	name = "bardiche"
	desc = "A polearm with a heavy blade. It'll cut a rider and their Arelite in half!"
	icon_state = "bardiche"
	item_state = "bardiche"
	force = 25
	force_wielded = 65
	force_unwielded = 25
	sharp = 1
	edge = 0
	throwforce = 2
	w_class = 5
	parry_chance = 15
	item_worth = 18
	weapon_speed_delay = 22
	slot_flags = SLOT_BACK
	sheathicon = null
	speciality = SKILL_STAFF
	weight = 10
	hitsound= "bardiche"
	smelted_return = /obj/item/ore/refined/lw/ironlw

/obj/item/claymore/saxaxe
	name = "sax Axe"
	desc = "A long axe common amonst fishermen."
	icon_state = "savaxe"
	item_state = "savaxe"
	force = 25
	force_wielded = 65
	force_unwielded = 25
	sharp = 1
	edge = 0
	throwforce = 2
	w_class = 5
	parry_chance = 15
	item_worth = 16
	weapon_speed_delay = 22
	slot_flags = SLOT_BACK
	sheathicon = null
	speciality = SKILL_STAFF
	weight = 10
	hitsound= "bardiche"
	smelted_return = /obj/item/ore/refined/lw/ironlw

/obj/item/claymore/sabre
	name = "sabre"
	desc = "Elegant and sleek, perfect for resolving violent disputes!"
	icon_state = "sabre"
	item_state = "sabre"
	edge = 0
	sharp = 1
	force = 30
	force_wielded = 30
	force_unwielded = 30
	parry_chance = 25
	item_worth = 30
	weight = 3
	sheathicon = "sword_sh3"
	drawsound = 'sound/weapons/sabre_draw.ogg'
	weapon_speed_delay = 10
	smelted_return = /obj/item/ore/refined/lw/steellw

/obj/item/claymore/rapier/wield(mob/user)
	to_chat(user, "You can't wield a rapier with two hands!")
	return

/obj/item/claymore/rusty/rapier/wield(mob/user)
	to_chat(user, "You can't wield a rapier with two hands!")
	return

/obj/item/claymore/sabre/wield(mob/user)
	to_chat(user, "You can't wield a sabre with two hands!")
	return

/obj/item/claymore/falchion
	name = "falchion"
	desc = "A single-edged blade. Popular among mercenaries"
	icon_state = "falchion"
	item_state = "falchion"
	force = 25
	force_wielded = 30
	force_unwielded = 25
	edge = 0
	sharp = 1
	weapon_speed_delay = 10
	blunt = 1
	parry_chance = 20
	item_worth = 18
	sheathicon = "sword_sh15"
	weight = 4
	smelted_return = /obj/item/ore/refined/lw/ironlw

/obj/item/katana
	name = "katana"
	desc = "Woefully underpowered in D20"
	icon_state = "katana"
	item_state = "katana"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 55
	sharp = 1
	edge = 1
	throwforce = 10
	w_class = 3
	attack_verb = list("attacked", "slashed", "sliced", "torn", "ripped", "diced", "cut")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>"
		return(BRUTELOSS)

/obj/item/katana/IsShield()
		return 1

/obj/item/katana/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/harpoon
	name = "harpoon"
	sharp = 1
	edge = 0
	desc = "Tharr she blows!"
	icon_state = "harpoon"
	item_state = "harpoon"
	force = 30
	throwforce = 15
	w_class = 3
	attack_verb = list("jabbed","ripped")

/obj/item/stone
	name = "rock"
	desc = "A small rock."
	icon = 'icons/obj/decalsLW.dmi'
	icon_state = "smallrock1"
	origin_tech = "materials=1;biotech=1"
	force = 5
	force_wielded = 12
	w_class = 1
	throwforce = 35
	parry_chance = -5

/obj/item/stone/attackby(obj/item/W as obj, mob/living/carbon/human/user as mob)
	if(istype(W, /obj/item/stone))
		usr.visible_message("<span class='passivebold'>[usr]</span> <span class='passive'>hits</span> <span class='passivebold'>[src]</span><span class='passive'> with </span> <span class='passivebold'>[W]</span>")
		playsound(user.loc, 'sound/effects/stonestone.ogg', 65, 1)
		if(prob(12))
			usr.visible_message("<span class='bname'>[src]</span> makes a spark!")
			for(var/obj/O in oview(1))
				if(istype(O, /obj/item/flame/torch))
					var/obj/item/flame/torch/T = O
					T.turn_on()
					if(T.loc == user.contents)
						user.on_fire = 1
						user.update_fire()
				if(istype(O, /obj/structure/fireplace))
					var/obj/structure/fireplace/T = O
					T.turn_on()
				if(istype(O, /obj/structure/campfire))
					var/obj/structure/campfire/T = O
					if(!T.spent)
						T.on = TRUE
						T.checkfire()

/obj/item/stone/unholy
	name = "unholy rock"
	force = 50
	throwforce = 200
	parry_chance = 45

/obj/item/rope
	name = "rope"
	desc = "small strings of rope."
	icon = 'icons/obj/decalsLW.dmi'
	icon_state = "smallrock1"

/obj/item/stone/New(var/loc, var/amount=null)
	icon_state = pick("smallrock1","smallrock2","smallrock3","smallrock4","smallrock5")
	update_icon()
	return ..()

///////////////////////////////
//////////ARMAS DE THROW///////
///////////////////////////////
/obj/item/throwingknife
	name = "copper throwing knife"
	desc = "A small throwing knife."
	icon_state = "throwing"
	origin_tech = "materials=1;biotech=1"
	force = 13
	throwforce = 23
	throw_speed = 6
	w_class = 2.0
	throw_range = 8
	item_worth = 3
	parry_chance = 2
	sharp = 1
	speciality = SKILL_KNIFE
	edge = 0

/obj/item/throwingknife/silver
	name = "silver throwing knife"
	icon_state = "sthrowing"
	force = 11
	throwforce = 18
	throw_speed = 6
	throw_range = 13
	item_worth = 13
	parry_chance = 2
	sharp = 1
	silver = TRUE