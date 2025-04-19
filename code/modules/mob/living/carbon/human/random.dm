/datum/species/human/femboy //fetishweb
	name = "Femboy"
	name_plural = "Femboys"
	total_health = 80
	icobase = 'icons/mob/human_races/ff_human.dmi'


/datum/species/human/femboy/handle_post_spawn(var/mob/living/carbon/human/H)
	H.mutations.Cut()
	if(H.f_style)
		H.f_style = "Shaved"
	H.gender = FEMALE //sssh
	to_chat(H, "<span class='erpbold'><big>I am secretly a man!</big></span>")
	return ..()


/mob/living/carbon/human/proc/isFemboy()//Used to tell if someone is scum (a Femboy).
	if(species && species.name == "Femboy")
		return 1
	else
		return 0


/mob/living/carbon/human/proc/hasActiveShield(var/takeBattery = 0)
	if(src.belt && istype(src.belt, /obj/item/shield/generator))
		var/obj/item/shield/generator/G = src.belt
		if(G.active)
			if(takeBattery)
				G.CELL.charge = max(0, G.CELL.charge - rand(200, 300))
			return 1
	if(src.s_store && istype(src.s_store, /obj/item/shield/generator))
		var/obj/item/shield/generator/G = src.s_store
		if(G.active)
			if(takeBattery)
				G.CELL.charge = max(0, G.CELL.charge - rand(200, 300))
			return 1
	if(src.wrist_l && istype(src.wrist_l, /obj/item/shield/generator/wrist))
		var/obj/item/shield/generator/G = src.wrist_l
		if(G.active)
			if(takeBattery)
				G.CELL.charge = max(0, G.CELL.charge - rand(200, 300))
			return 1
	if(src.wrist_r && istype(src.wrist_r, /obj/item/shield/generator/wrist))
		var/obj/item/shield/generator/G = src.wrist_r
		if(G.active)
			if(takeBattery)
				G.CELL.charge = max(0, G.CELL.charge - rand(200, 300))
			return 1
	return 0

/mob/living/carbon/human/proc/getActiveShield()
	if(src.wrist_l && istype(src.wrist_l, /obj/item/shield/generator/wrist))
		var/obj/item/shield/generator/G = src.wrist_l
		return G
	if(src.wrist_r && istype(src.wrist_r, /obj/item/shield/generator/wrist))
		var/obj/item/shield/generator/G = src.wrist_r
		return G
	if(src.belt && istype(src.belt, /obj/item/shield/generator))
		var/obj/item/shield/generator/G = src.belt
		return G
	if(src.s_store && istype(src.s_store, /obj/item/shield/generator))
		var/obj/item/shield/generator/G = src.s_store
		return G
	return 0

/mob/living/carbon/human/proc/isStealth()
	if(src.wrist_l && istype(src.wrist_l, /obj/item/cloaking_device))
		var/obj/item/cloaking_device/C = src.wrist_l
		if(C.active && !C.area_locked)
			return 1
		else if(C.active && istype(src.loc:loc, C.area_locked))
			return 2
	if(src.wrist_r && istype(src.wrist_r, /obj/item/cloaking_device))
		var/obj/item/cloaking_device/C = src.wrist_r
		if(C.active && !C.area_locked)
			return 1
		else if(C.active && istype(src.loc:loc, C.area_locked))
			return 2
	return 0