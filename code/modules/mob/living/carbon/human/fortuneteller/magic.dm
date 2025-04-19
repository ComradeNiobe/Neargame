var/list/cursed = list()

/obj/item/fortune/hair
	name = "hair"
	desc = "A lock of someone's hair."
	icon = 'icons/obj/items.dmi'
	icon_state = "hair"
	force = 3.0
	throwforce = 2.0
	throw_speed = 1
	slot_flags = SLOT_POCKET
	throw_range = 4
	var/mob/living/carbon/human/owner = null

/obj/item/fortune/hairsnatcher
	name = "hair grabber"
	desc = "A device used for covertly acquiring someone's hair."
	icon = 'icons/obj/items.dmi'
	icon_state = "hairgrabber0"
	force = 3.0
	throwforce = 2.0
	slot_flags = SLOT_POCKET
	throw_speed = 1
	throw_range = 4
	contents = list()
	var/filled = 0

/obj/item/fortune/hairsnatcher/attack(mob/living/carbon/human/M as mob, mob/living/user as mob)
	if(!filled)
		var/obj/item/fortune/hair/V = new /obj/item/fortune/hair
		V.owner = M
		contents += V
		filled = 1
		update_icon()
		to_chat(user, "\blue You collect a lock of hair from [M]")
		if(prob(25))
			to_chat(M, "<span class='combatglow'>You feel a jolt of pain as something pulls your hair!</span>")
	else
		to_chat(user, "[pick(fnord)] the grabber is already full!")

/obj/item/fortune/hairsnatcher/attack_self(mob/living/user as mob)
	if(!filled)
		to_chat(user, "[pick(fnord)] the grabber is empty!")
	else
		for(var/obj/item/fortune/hair/V in contents)
			user.put_in_hands(V)
			V.name = "[V.owner.real_name]'s hair"
			contents -= V
			filled = 0
			update_icon()
			to_chat(user, "You empty the hair grabber.")

/obj/item/fortune/hairsnatcher/update_icon()
	if(filled)
		icon_state = "hairgrabber1"
	else
		icon_state = "hairgrabber0"

/obj/structure/fortune/veilpillar
	name = "Pillar of the Veil"
	icon = 'icons/obj/structures.dmi'
	icon_state = "veilpillar0"
	density = 1
	anchored = 1
	dir = SOUTH
	breakable = 1
	drops = list(/obj/item/stone, /obj/item/stone)
	break_sounds = list('sound/effects/npc_human_pickaxe_01.ogg','sound/effects/npc_human_pickaxe_02.ogg','sound/effects/npc_human_pickaxe_03.ogg','sound/effects/npc_human_pickaxe_05.ogg')
	var/activated = 0
	

/obj/structure/fortune/veilpillar/Bumped(mob/M as mob)
	if(istype(M, /mob/dead/observer))
		if(!activated)
			activated = 1
			icon_state = "veilpillar1"
			set_light(4, 3,"#552c70")
			visible_message("<span class='warning'>[src] flashes to life, emanating an eerie aura.</span>")
		else return

/obj/structure/fortune/veilpillar/RightClick(mob/living/carbon/human/user as mob)
	if(user.job == "Fortune Teller")
		if(activated)
			activated = 0
			icon_state = "veilpillar0"
			light.Destroy()
			update_light()
			visible_message("[user] waves their hand over the pillar, intoning something under \his breath as the light fades.")
			for(var/mob/dead/observer/G in mob_list)
				if(G.tellerrevealed)
					to_chat(G, "<span class='combatglow'>You are no longer attuned to [user]</span>")
					G.tellerrevealed = 0
		else
			to_chat(user, "It's not activated!")

	else
		to_chat(user, "What is this?")

/obj/structure/fortune/veilpillar/clean_mmb(mob/living/carbon/human/user as mob)
	if(user.job == "Fortune Teller")
		if(activated)
			playsound(src.loc, 'sound/spectre/w_suc.ogg', 40, 0, -1)
			icon_state = "veilpillar2"
			visible_message("[user] raises \his hand to pillar, mumbling something as the pillar glows!")
			for(var/mob/dead/observer/G in range(3, src))
				to_chat(G, "<span class='passiveglow'>My spirit is attuned to [user].</span>")
				G.tellerrevealed = 1
		else
			to_chat(user, "It's not activated!")

	else
		to_chat(user, "What is this?")

/obj/structure/fortune/veilpillar/attackby(var/obj/item/W as obj, var/mob/user as mob)
	var/list/options = list("Curse", "Charm", "Locate", "Clear Curse")
	var/list/curses = list("Journey to Evergreen", "Soil Contribution","Aroma of Despair","Alopecian Beauty","Virtuous Disability")
	if(istype(W, /obj/item/spacecash/silver/c2))
		visible_message("[user] inserts the metal into the pillar, speaking in tongues as \he shapes it.")
		if(do_after(user, 120))
			visible_message("[user] completes the ritual, removing a fully formed blank charm.")
			qdel(W)
			user.put_in_hands(new /obj/item/clothing/head/amulet/charm)
	if(istype(W, /obj/item/storage/bible) || istype(W, /obj/item/melee/classic_baton/crossofravenheart))
		visible_message("[user] begins to cleanse the pillar!")
		if(do_after(user, 30))
			visible_message("[user] destroys the pillar!")
			Destroy()
	if(istype(W, /obj/item/fortune/hair))
		visible_message("[user] holds the hair up to the pillar, speaking in tongues as \he alters it.")
		activated = 1
		icon_state = "veilpillar2"
		var/obj/item/fortune/hair/T = W
		var/input = input(user, "What would you like to do?", "What?", "") in options
		switch(input)
			if("Curse")
				var/inputcurse = input(user, "Which curse?", "What?", "") in curses
				to_chat(T.owner, "<span class='combatglow'>You feel a dark aura loom over you.</span>")
				if(do_after(user, 120))
					if(knifeprayer == TRUE)
						to_chat(user, "[pick(fnord)], the fortress is under Holy Protection!")
					for(var/mob/living/carbon/human/V in cursed)
						if(V == T.owner)
							to_chat(user, "[pick(fnord)], that person's already been cursed!")
							return
					if(!inputcurse)
						return
					cursed += T.owner
					playsound(src.loc, 'sound/spectre/w_suc.ogg', 40, 0, -1)
					switch(inputcurse)
						if("Aroma of Despair")									
							T.owner.hygiene = -400
						if("Alopecian Beauty")
							T.owner.h_style = "Bald"
							T.owner.update_hair()
						else
							T.owner.curse = inputcurse
					qdel(T)
			if("Charm")
				var/obj/item/A = user.get_inactive_hand()
				if(!istype(A, /obj/item/clothing/head/amulet/charm))
					to_chat(user, "[pick(fnord)], I need to be holding the blank charm!")
					return
				var/obj/item/clothing/head/amulet/charm/I = A
				var/selectedstat = pick(STAT_DX, STAT_ST, STAT_HT, STAT_IN, STAT_PR)
				activated = 1
				icon_state = "veilpillar2"
				if(do_after(user, 120))
					visible_message("[user] combines the hair with the charm before the altar, intoning strange words.")
					qdel(T)
					playsound(src.loc, 'sound/spectre/w_suc.ogg', 40, 0, -1)
					T.owner.my_stats.change_stat(selectedstat , 1)
					I.benefitstat = selectedstat
					I.beneficiary = T.owner
					I.name = "activated charm"
					I.icon_state = "evil"
				activated = 0
				icon_state = "veilpillar0"

			if("Locate")
				var/arealoc = get_area(T.owner)
				playsound(src.loc, 'sound/spectre/w_suc.ogg', 40, 0, -1)
				if(T.owner.stat >= 1)
					to_chat(user, "They are located at [arealoc]. They are dead or dying.")
				else
					to_chat(user, "They are located at [arealoc]. They are alive.")
				qdel(T)
			if("Clear Curse")
				switch(T.owner.curse)
					if("Aroma of Despair")									
						T.owner.hygiene = 100
					else
						cursed -= T.owner
				qdel(T)
				
		icon_state = "veilpillar0"
		activated = 0

/obj/structure/fortune/veilpillar/Destroy()
	..()
	for(var/mob/living/carbon/human/L in cursed)
		if(L.curse == "Aroma of Despair")									
			L.hygiene = 100
		L.clear_event(/datum/happiness_event/cursed)
	for(var/mob/living/carbon/human/W in mob_list)
		if(W.job == "Fortune Teller")
			W.emote("scream")
			W.client.ChromieWinorLoose(-2)
			W.death()
	cursed = null
	

/obj/item/clothing/head/amulet/witch
	name = "wooden amulet"
	desc = "Who would wear an amulet made of wood?"
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "witch"
	item_state = "witch"
	neck_use = TRUE
	item_worth = 2

/obj/item/clothing/head/amulet/charm
	name = "blank charm"
	desc = "Who would wear an amulet made of wood?"
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "zodiac_charm"
	item_state = "zodiac_charm"
	neck_use = TRUE
	item_worth = 8
	var/mob/living/carbon/human/beneficiary = null
	var/benefitstat = null

/obj/item/clothing/head/amulet/charm/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/storage/bible) || istype(W, /obj/item/melee/classic_baton/crossofravenheart) || istype(W, /obj/item/claymore))
		visible_message("[user] begins to destroy the charm!")
		if(do_after(user, 30))
			visible_message("[user] destroys the charm!")
			Destroy()
	else
		to_chat(user, "<span class='combatglow'>[pick(fnord)], it's not strong enough!</span>")

/obj/item/clothing/head/amulet/charm/Destroy()
	..()
	beneficiary.emote("scream")
	to_chat(beneficiary, "<span class='combatglow'>You feel a dark aura loom over you.</span>")
	beneficiary.my_stats.change_stat(benefitstat , -3)

/mob/living/carbon/human/proc/mirage(mob/living/carbon/human/user)
	set hidden = 0
	set category = "gpc"
	set name = "Mirage"
	set desc="Mirage"

	var/obj/item/clothing/head/amulet/A = user.amulet
	var/appearancelist = list("Red", "Yellow", "Black")
	if(istype(A, /obj/item/clothing/head/amulet/witch))
		if(witchdisguised == 1)
			for(var/obj/item/clothing/suit/witch/R in world)
				R.icon_state = "witch"
				R.name = "ragged dress"
			age = 120
			h_style = "Bedhead"
			r_hair = 128
			g_hair = 128
			b_hair = 128
			witchdisguised = 0
			update_inv_wear_suit()
			update_hair()
			return
		user.age = 20
		var/obj/item/clothing/suit/R = user.wear_suit
		if(istype(R, /obj/item/clothing/suit/witch))
			R.icon_state = "ndress"
			R.name = "purple dress"
		var/input = input(user, "Which appearance should I take?", "What?", "") in appearancelist
		switch(input)
			if("Red")
				user.h_style = "Tress Hair"
				user.r_hair = 204
				user.g_hair = 90
				user.b_hair = 14
			if("Yellow")
				user.h_style = "Wild Hair"
				user.r_hair = 186
				user.g_hair = 186
				user.b_hair = 129
			if("Black")
				user.h_style = "Egirl"
				user.r_hair = 0
				user.g_hair = 0
				user.b_hair = 0
		user.update_inv_wear_suit()
		user.update_hair()
		witchdisguised = 1
	else to_chat(user, "[pick(fnord)] I need my amulet!")
	


