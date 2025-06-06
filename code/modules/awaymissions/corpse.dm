//These are meant for spawning on maps, namely Away Missions.

//If someone can do this in a neater way, be my guest-Kor

//To do: Allow corpses to appear mangled, bloody, etc. Allow customizing the bodies appearance (they're all bald and white right now).

/obj/effect/landmark/corpse
	name = "Unknown"

	var/mobname = "Unknown"  //Unused now but it'd fuck up maps to remove it now
	var/random_name = 0

	gender = MALE

	var/corpseuniform = null //Set this to an object path to have the slot filled with said object on the corpse.
	var/corpsesuit = null
	var/corpseshoes = null
	var/corpsegloves = null
	var/corpseradio = null
	var/corpseglasses = null
	var/corpsemask = null
	var/corpsehelmet = null
	var/corpsebelt = null
	var/corpsepocket1 = null
	var/corpsepocket2 = null
	var/corpseback = null
	var/corpseid = 0     //Just set to 1 if you want them to have an ID
	var/corpseidjob = null // Needs to be in quotes, such as "Clown" or "Chef." This just determines what the ID reads as, not their access
	var/corpseidaccess = null //This is for access. See access.dm for which jobs give what access. Again, put in quotes. Use "Captain" if you want it to be all access.
	var/corpseidicon = null //For setting it to be a gold, silver, centcomm etc ID

	var/mutantrace = "human"

	var/brutedamaged = 0
	var/burndamaged = 0
	var/oxydamaged = 0
	var/toxydamaged = 0

	var/corpsehaircolor = null
	var/corpsehairstyle = null
	var/corpsefhairstyle = null
	New()
		. = ..()
		init_obj.Add(src)

/obj/effect/landmark/corpse/initialize()
	. = ..()
	createCorpse()

/obj/effect/landmark/corpse/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/M = new /mob/living/carbon/human (src.loc)
	M.dna.mutantrace = mutantrace

	if(src.corpsehaircolor)
		M.r_facial = hex2num(copytext(corpsehaircolor, 2, 4))
		M.g_facial = hex2num(copytext(corpsehaircolor, 4, 6))
		M.b_facial = hex2num(copytext(corpsehaircolor, 6, 8))
		M.r_hair = M.r_facial
		M.g_hair = M.g_facial
		M.b_hair = M.b_facial
	if(src.corpsehairstyle)
		M.h_style = corpsehairstyle
	if(src.corpsefhairstyle)
		M.f_style = corpsefhairstyle

	if(gender)
		M.gender = gender
	M.real_name = src.name
	if(random_name)
		M.real_name = random_name(M.gender)

	if(brutedamaged)
		M.apply_damage(brutedamaged, BRUTE)
	if(burndamaged)
		M.apply_damage(brutedamaged, BURN)
	if(oxydamaged)
		M.apply_damage(brutedamaged, OXY)
	if(toxydamaged)
		M.apply_damage(brutedamaged, TOX)

	M.death(1) //Kills the new mob
	if(src.corpseuniform)
		M.equip_to_slot_or_del(new src.corpseuniform(M), slot_w_uniform)
	if(src.corpsesuit)
		M.equip_to_slot_or_del(new src.corpsesuit(M), slot_wear_suit)
	if(src.corpseshoes)
		M.equip_to_slot_or_del(new src.corpseshoes(M), slot_shoes)
	if(src.corpsegloves)
		M.equip_to_slot_or_del(new src.corpsegloves(M), slot_gloves)
	if(src.corpseradio)
		M.equip_to_slot_or_del(new src.corpseradio(M), slot_l_ear)
	if(src.corpseglasses)
		M.equip_to_slot_or_del(new src.corpseglasses(M), slot_glasses)
	if(src.corpsemask)
		M.equip_to_slot_or_del(new src.corpsemask(M), slot_wear_mask)
	if(src.corpsehelmet)
		M.equip_to_slot_or_del(new src.corpsehelmet(M), slot_head)
	if(src.corpsebelt)
		M.equip_to_slot_or_del(new src.corpsebelt(M), slot_belt)
	if(src.corpsepocket1)
		M.equip_to_slot_or_del(new src.corpsepocket1(M), slot_r_store)
	if(src.corpsepocket2)
		M.equip_to_slot_or_del(new src.corpsepocket2(M), slot_l_store)
	if(src.corpseback)
		M.equip_to_slot_or_del(new src.corpseback(M), slot_back)
	if(src.corpseid == 1)
		var/obj/item/card/id/W = new(M)
		W.name = "[M.real_name]'s ID Card"
		var/datum/job/jobdatum
		for(var/jobtype in typesof(/datum/job))
			var/datum/job/J = new jobtype
			if(J.title == corpseidaccess)
				jobdatum = J
				break
		if(src.corpseidicon)
			W.icon_state = corpseidicon
		if(src.corpseidaccess)
			if(jobdatum)
				W.access = jobdatum.get_access()
			else
				W.access = list()
		if(corpseidjob)
			W.assignment = corpseidjob
		W.registered_name = M.real_name
		M.equip_to_slot_or_del(W, slot_wear_id)
	qdel(src)



// I'll work on making a list of corpses people request for maps, or that I think will be commonly used. Syndicate operatives for example.










///////////Civilians//////////////////////

/obj/effect/landmark/corpse/chef
	name = "Chef"
	random_name = 1
	corpseuniform = /obj/item/clothing/under/rank/chef
	corpsesuit = /obj/item/clothing/suit/chef/classic
	corpseshoes = /obj/item/clothing/shoes/lw/black
	corpseback = /obj/item/storage/backpack
	corpseradio = /obj/item/device/radio/headset
	corpseid = 1
	corpseidjob = "Chef"
	corpseidaccess = "Chef"

	brutedamaged = 19
	burndamaged = 84
	oxydamaged = 97


/obj/effect/landmark/corpse/doctor
	name = "Doctor"
	random_name = 1
	corpseradio = /obj/item/device/radio/headset/headset_med
	corpseuniform = /obj/item/clothing/under/rank/medical
	corpsesuit = /obj/item/clothing/suit/storage/labcoat
	corpseback = /obj/item/storage/backpack/medic

	corpseshoes = /obj/item/clothing/shoes/lw/black
	corpseid = 1
	corpseidjob = "Medical Doctor"
	corpseidaccess = "Medical Doctor"

/obj/effect/landmark/corpse/doctor/damaged
	brutedamaged = 124
	oxydamaged = 86


/obj/effect/landmark/corpse/engineer
	name = "Engineer"
	random_name = 1
	corpseradio = /obj/item/device/radio/headset/headset_eng
	corpseuniform = /obj/item/clothing/under/rank/engineer
	corpseback = /obj/item/storage/backpack/industrial
	corpseshoes = /obj/item/clothing/shoes/lw/brown
	corpsebelt = /obj/item/storage/belt/utility/full
	corpsegloves = /obj/item/clothing/gloves/yellow
	corpsehelmet = /obj/item/clothing/head/hardhat
	corpseid = 1
	corpseidjob = "Vessel Engineer"
	corpseidaccess = "Vessel Engineer"

/obj/effect/landmark/corpse/clown
	name = "Clown"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpseshoes = /obj/item/clothing/shoes/lw/clown_shoes
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/bikehorn
	corpseback = /obj/item/storage/backpack/clown
	corpseid = 1
	corpseidjob = "Clown"
	corpseidaccess = "Clown"

/obj/effect/landmark/corpse/scientist
	name = "Scientist"
	random_name = 1
	corpseradio = /obj/item/device/radio/headset/headset_sci
	corpseuniform = /obj/item/clothing/under/rank/scientist
	corpsesuit = /obj/item/clothing/suit/storage/labcoat/science
	corpseback = /obj/item/storage/backpack
	corpseshoes = /obj/item/clothing/shoes/lw/brown
	corpseid = 1
	corpseidjob = "Scientist"
	corpseidaccess = "Scientist"

/obj/effect/landmark/corpse/miner
	random_name = 1
	corpseradio = /obj/item/device/radio/headset/headset_cargo
	corpseuniform = /obj/item/clothing/under/rank/miner
	corpsegloves = /obj/item/clothing/gloves/black
	corpseback = /obj/item/storage/backpack/industrial
	corpseshoes = /obj/item/clothing/shoes/lw/black
	corpseid = 1
	corpseidjob = "Shaft Miner"
	corpseidaccess = "Shaft Miner"



/////////////////Officers//////////////////////

/obj/effect/landmark/corpse/bridgeofficer
	name = "Bridge Officer"
	random_name = 1
	corpseradio = /obj/item/device/radio/headset/heads/hop
	corpseuniform = /obj/item/clothing/under/rank/centcom_officer
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseshoes = /obj/item/clothing/shoes/lw/black
	corpseglasses = /obj/item/clothing/glasses/sunglasses
	corpseid = 1
	corpseidjob = "Bridge Officer"
	corpseidaccess = "Captain"
/obj/effect/landmark/corpse/captain_will
	name = "William Wilkerson"
	corpseradio = /obj/item/device/radio/headset/heads/captain
	corpsehaircolor = "#808000"
	corpsehairstyle = "Long Hair"
	corpsefhairstyle = "Goatee"