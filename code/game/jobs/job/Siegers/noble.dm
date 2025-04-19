/datum/job/count
	title = "Count"
	titlebr = "Count"
	flag = SIEGER
	department_flag = CIVILIAN
	faction = "Siege"
	total_positions = -1
	spawn_positions = -1
	supervisors = "The God King"
	selection_color = "#dddddd"
	idtype = null
	thanati_chance = 0
	access = list()
	minimal_access = list()
	minimal_character_age = 30

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		to_chat(H, "<span class='dreamershitfuckcomicao1'>You're the count.</span>")
		to_chat(H, "<span class='dreamershit'>Guide your grunts and take over Firethorn!</span>")
		H.voicetype = "noble"
		H.age = rand(30, 60)
		H.terriblethings = TRUE
		H.add_perk(/datum/perk/lessstamina)
		H.add_perk(/datum/perk/heroiceffort)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/claymore/bastard(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/sheath(H), slot_belt)
		var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(H)
		R.set_frequency(SYND_FREQ)
		H.equip_to_slot_or_del(R, slot_l_ear)
		H.my_skills.change_skill(SKILL_MELEE, 10)
		H.my_skills.change_skill(SKILL_RANGE, rand(2,2))
		H.my_skills.change_skill(SKILL_MASON, 2)
		H.my_skills.change_skill(SKILL_CRAFT, 2)
		H.my_skills.change_skill(SKILL_CLIMB, rand(5,6))
		H.my_skills.change_skill(SKILL_RIDE, rand(3,4))
		H.my_skills.change_skill(SKILL_COOK, rand(0,0))
		H.my_skills.change_skill(SKILL_OBSERV, rand(5,5))
		H.my_skills.change_skill(SKILL_SWIM,rand(2,2))
		if(H.gender == FEMALE)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/count/countess(H), slot_back)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate/countess(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/card/id/count/countess(H), slot_wear_id)
			H.my_stats.change_stat(STAT_ST , 4)
			H.my_stats.change_stat(STAT_DX , 3)
			H.my_stats.change_stat(STAT_HT , 5)
			H.my_skills.change_skill(SKILL_SWORD, rand(4,5))
			H.my_skills.change_skill(SKILL_UNARM, rand(4,5))
		else
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/count(H), slot_back)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/siegehelmet(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat/gauntlet/steel(H), slot_gloves)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/ironmask(H), slot_wear_mask)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/card/id/count(H), slot_wear_id)
			H.my_stats.change_stat(STAT_ST , 4)
			H.my_stats.change_stat(STAT_DX , 3)
			H.my_stats.change_stat(STAT_HT , 5)
			H.add_perk(/datum/perk/ref/strongback)
			H.my_skills.change_skill(SKILL_SWORD, rand(4,5))
			H.my_skills.change_skill(SKILL_UNARM, rand(4,5))
		H.add_verb(list(/mob/living/carbon/human/proc/reinforcement_call,
		/mob/living/carbon/human/proc/siege_command,
		/mob/living/carbon/human/proc/special_reinforcement,
		/mob/living/carbon/human/proc/recruit_siege,
		/mob/living/carbon/human/proc/capture_throne))
		log_game("[H.real_name]/[H.key] spawned as Count")
		H.create_kg()
		H.outsider = TRUE
		H.siegesoldier = TRUE
		if(ticker.mode.config_tag == "siege")
			var/datum/game_mode/siege/S = ticker.mode
			S.hascount = H
			S.siegerslist += H
			H.update_all_siege_icons()
			S.count_family = new /datum/family(H)
			matchmaker.families |= S.count_family
			S.flag_colors["maincolor"] = input(H, "Please select a main sieger color.", "Uniform") as color|null
			S.flag_colors["secondcolor"] = input(H, "Please select a secondary sieger color.", "Uniform") as color|null
		return 1

/mob/living/carbon/human/proc/reinforcement_call()
	set hidden = 0
	set category = "gpc"
	set name = "Reinforcement"
	set desc="Change Reinforcement"

	if(!(src.siegesoldier) || ticker.mode.config_tag != "siege")
		return
	var/datum/game_mode/siege/S = ticker.mode
	var/reinforcement_type = input(src, "Select a reinforcement type.", "Reinforcement Type", "(CANCEL)") in list("Infantry", "Scouts", "Builders", "Healers", "Peasants", "(CANCEL)")
	if(reinforcement_type == "(CANCEL)") return
	var/calling = TRUE
	var/list/have_one
	switch(reinforcement_type)
		if("Infantry")
			have_one = siegerclasses & battlesiegers
			if(length(have_one))
				to_chat(src, "<span class='combat'>I'm already calling this type of reinforcement!</span>")
				return
			else
				if(length(siegerclasses & peasantssiegers))
					siegerclasses -= peasantssiegers
				siegerclasses += battlesiegers
		if("Peasants")
			have_one = siegerclasses & peasantssiegers
			if(length(have_one))
				to_chat(src, "<span class='combat'>I'm already calling this type of reinforcement!</span>")
				return
			else
				if(length(siegerclasses & battlesiegers))
					siegerclasses -= battlesiegers
				siegerclasses += peasantssiegers
				if(S.hasblacksmithsiege)
					siegerclasses -= "Blacksmith"
				if(S.hasalchemistsiege)
					siegerclasses -= "Alchemist"
		if("Scouts")
			have_one = siegerclasses & scoutssiegers
			if(length(have_one))
				siegerclasses -= scoutssiegers
				calling = FALSE
			else
				siegerclasses += scoutssiegers
		if("Healers")
			have_one = siegerclasses & healerssiegers
			if(length(have_one))
				siegerclasses -= healerssiegers
				calling = FALSE
			else
				siegerclasses += healerssiegers
		if("Builders")
			have_one = siegerclasses & builderssiegers
			if(length(have_one))
				siegerclasses -= builderssiegers
				calling = FALSE
			else
				siegerclasses += builderssiegers
	for(var/mob/living/carbon/human/H in S.siegerslist)
		if(calling)
			to_chat(H, "<span class='passive'>Count decides: the siege requires extra [reinforcement_type]!</span>")
		else
			to_chat(H, "<span class='passive'>Count decides: the siege has no need of extra [reinforcement_type]!</span>")
		H << sound(pick('sound/effects/horn1.ogg','sound/effects/horn2.ogg'))

/mob/living/carbon/human/proc/siege_command()
	set hidden = 0
	set category = "gpc"
	set name = "Command"
	set desc="Siege Command"
	if(!(src.siegesoldier) || ticker.mode.config_tag != "siege")
		return
	var/datum/game_mode/siege/S = ticker.mode
	var/command = sanitize(input(src, "Type your command.", "Siege Command", "") as text|null)
	if(!command || !length(command))
		return
	var/comsound = pick('sound/effects/horn1.ogg','sound/effects/horn2.ogg')
	for(var/mob/living/carbon/human/H in S.siegerslist)
		to_chat(H, "<span class='excomm'>[job] orders you to [command]</span>")
		H << sound(comsound)

/mob/living/carbon/human/proc/special_reinforcement()
	set hidden = 0
	set category = "gpc"
	set name = "SpecialReinforcement"
	set desc="Call for Special Reinforcement"
	var/failed = FALSE
	var/specialclass
	if(!(src.siegesoldier) || ticker.mode.config_tag != "siege")
		return
	var/datum/game_mode/siege/S = ticker.mode
	switch(job)
		if("Count")
			if(S.specialrifleman)
				failed = TRUE
		if("Count Hand")
			if(S.specialtownguard)
				failed = TRUE
		if("Count Heir")
			if(S.specialgang)
				failed = TRUE
	if(failed)
		to_chat(src, "<span class='combat'>[pick(fnord)] I already called one!</span>")
		return
	switch(alert("Would you like to call for Special Reinforcements? (You can do this only once for short period of time)","Call for Special Reinforcements","Yes","No"))
		if("Yes")
			switch(job)
				if("Count")
					S.specialrifleman = TRUE
					S.special_troops["Rifleman"] = world.time
					specialclass = "Riflemans"
					siegerclasses += "Rifleman"
				if("Count Hand")
					S.specialtownguard = TRUE
					S.special_troops["Town Guard"] = world.time
					specialclass ="Town Guards"
					siegerclasses += "Town Guard"
				if("Count Heir")
					S.specialgang  = TRUE
					S.special_troops["Mobster"] = world.time
					specialclass = "his Mob"
					siegerclasses += "Mobster"
			for(var/mob/living/carbon/human/H in S.siegerslist)
				to_chat(H, "<span class='excomm'>[job] calls for [specialclass]!</span>")
				H << sound('sound/lfwbambi/invasion.ogg')
		if("No")
			return

/mob/living/carbon/human/proc/recruit_siege()
	set hidden = 0
	set category = "gpc"
	set name = "Recruit"
	set desc="Recruit to Siege Troops"
	if(!(src.siegesoldier) || ticker.mode.config_tag != "siege")
		return
	var/datum/game_mode/siege/S = ticker.mode
	var/recruit_text = sanitize(input(src, "What you would to say?", "Siege Recruit", "") as text|null)
	if(!recruit_text || !length(recruit_text))
		return
	say(recruit_text)
	var/list/to_recruit = get_mobs_in_view(world.view,src)
	to_recruit -= S.siegerslist
	for(var/mob/living/carbon/human/H in to_recruit)
		switch(alert("Would you like to join the Siege side?","Joining the Siege","Yes","No"))
			if("Yes")
				if(!(src in get_mobs_in_view(world.view, H)))
					return
				for(var/mob/O in get_mobs_in_view(world.view, H))
					O.show_message("<span class='examinebold'>[H]</span> <span class='examine'>kneels to</span> <span class='examinebold'>[src]!</span>",1)
				H.siegesoldier = TRUE
				S.siegerslist += H
				H.update_all_siege_icons()
				S.max_losses++
				log_game("[H.real_name]/[H.key] joins the Siege side!")
			if("No")
				return

/mob/living/carbon/human/proc/capture_throne()
	set hidden = 0
	set category = "gpc"
	set name = "CaptureThrone"
	set desc="Capture Throne"
	var/needed_sieger = 7

	if(ticker?.mode.config_tag != "siege")
		return
	var/datum/game_mode/siege/S = ticker.mode
	if(!buckled || !istype(buckled, /obj/structure/stool/bed/chair/ThroneMid))
		to_chat(src, "<span class='combat'>You need to sit on the Firethorn's throne!</span>")
		return
	var/obj/structure/stool/bed/chair/ThroneMid/TM = buckled
	if(TM.captured)
		to_chat(src, "<span class='combat'>Throne already captured, wait for the party!</span>")
		return
	if(!head || !istype(head, /obj/item/clothing/head/caphat))
		var/siegers_throne = 0
		var/list/areas = get_areas(/area/dunwell/station/bridge/noble/throne_room)
		for(var/area/A in areas)
			for(var/mob/living/carbon/human/H in A)
				if(H == src)
					continue
				if(H in S.siegerslist)
					siegers_throne += 1
		if(siegers_throne < needed_sieger)
			to_chat(src, "<span class='combat'>You need to have a crown, or at least 7 siegers in the Throne Room!</span>")
			return
	to_chat(world, "<br>")
	to_chat(world, "<span class='ravenheartfortress'>Enoch's Gate Hold</span>")
	to_chat(world, "<span class='excomm'>¤The fortress was taken by Count [src.real_name]¤</span>")
	to_chat(world, "<span class='excomm'>The party starts in throne room after a minute.</span>")
	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<br>")
	to_chat(world, "<span class='decree'>New Count's decree!</span>")
	to_chat(world, "<br>")
	TM.captured = TRUE
	spawn(600)
		if(!roundendready)
			unlock_medal("Lord of the Caves", 0, "Lead your expedition to glory of dominating the South.", "12")
			S.result = SIEGE_WIN_THRONE
			roundendready = TRUE

/datum/job/count_hand
	title = "Count Hand"
	titlebr = "Count Hand"
	flag = SIEGER
	department_flag = CIVILIAN
	faction = "Siege"
	total_positions = -1
	spawn_positions = -1
	supervisors = "Count"
	selection_color = "#dddddd"
	idtype = /obj/item/card/id/count/hand
	thanati_chance = 0
	access = list()
	minimal_access = list()
	minimal_character_age = 19

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.terriblethings = TRUE
		H.voicetype = "noble"
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/lessstamina)
		H.add_perk(/datum/perk/heroiceffort)
		H.my_stats.change_stat(STAT_ST , 3)
		H.my_stats.change_stat(STAT_DX , 1)
		H.my_stats.change_stat(STAT_HT , 3)
		H.my_skills.change_skill(SKILL_MELEE, rand(5,5))
		H.my_skills.change_skill(SKILL_RANGE, rand(2,2))
		H.my_skills.change_skill(SKILL_MASON, 2)
		H.my_skills.change_skill(SKILL_CRAFT, 2)
		H.my_skills.change_skill(SKILL_CLIMB, rand(4,5))
		H.my_skills.change_skill(SKILL_RIDE, rand(3,4))
		H.my_skills.change_skill(SKILL_COOK, rand(0,0))
		H.my_skills.change_skill(SKILL_OBSERV, rand(3,3))
		H.my_skills.change_skill(SKILL_SWIM,rand(2,2))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/countflag(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(H), slot_wear_suit)
		var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(H)
		R.set_frequency(SYND_FREQ)
		H.equip_to_slot_or_del(R, slot_l_ear)
		log_game("[H.real_name]/[H.key] spawned as Count's Hand")
		var/weapon = pick(list(SKILL_SWORD, SKILL_SWING, SKILL_STAFF))
		H.my_skills.change_skill(weapon, rand (5, 7))
		switch(weapon)
			if(SKILL_SWORD)
				H.equip_to_slot_or_del(new /obj/item/claymore/bastard(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/sheath(H), slot_belt)
			if(SKILL_SWING)
				if(prob(50))
					H.equip_to_slot_or_del(new /obj/item/melee/classic_baton/mace(H), slot_r_hand)
				else
					H.equip_to_slot_or_del(new /obj/item/hatchet(H), slot_r_hand)
			if(SKILL_STAFF)
				H.equip_to_slot_or_del(new /obj/item/claymore/spear(H), slot_r_hand)
		H.add_verb(list(/mob/living/carbon/human/proc/siege_command,
		/mob/living/carbon/human/proc/special_reinforcement,
		/mob/living/carbon/human/proc/recruit_siege))
		H.create_kg()
		H.outsider = TRUE
		H.siegesoldier = TRUE
		if(ticker.mode.config_tag == "siege")
			var/datum/game_mode/siege/S = ticker.mode
			S.siegerslist += H
			S.hascounthand = TRUE
			H.update_all_siege_icons()
		return 1

/datum/job/count_heir
	title = "Count Heir"
	titlebr = "Count Heir"
	flag = SIEGER
	department_flag = CIVILIAN
	faction = "Siege"
	total_positions = -1
	spawn_positions = -1
	supervisors = "Count"
	selection_color = "#dddddd"
	idtype = /obj/item/card/id/count/heir
	thanati_chance = 0
	access = list()
	minimal_access = list()
	minimal_character_age = 19

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.terriblethings = TRUE
		H.voicetype = "noble"
		H.age = rand(19, 25)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics(H), slot_w_uniform) // tanktop + leather pants
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/countheir(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/claymore/rapier(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/sheath(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/tricorn(H), slot_head)
		var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(H)
		R.set_frequency(SYND_FREQ)
		H.equip_to_slot_or_del(R, slot_l_ear)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		H.add_perk(/datum/perk/lessstamina)
		H.my_stats.change_stat(STAT_ST , 1)
		H.my_stats.change_stat(STAT_DX , 1)
		H.my_stats.change_stat(STAT_HT , 1)
		log_game("[H.real_name]/[H.key] spawned as Count's Heir")
		H.my_skills.change_skill(SKILL_MELEE, rand(2,5))
		H.my_skills.change_skill(SKILL_RANGE, rand(2,2))
		H.my_skills.change_skill(SKILL_CLIMB,rand(2,2))
		H.my_skills.change_skill(SKILL_RIDE, rand(0,3))
		H.my_skills.change_skill(SKILL_PARTY,rand(4,4))
		H.my_skills.change_skill(SKILL_SWIM,rand(0,0))
		H.my_skills.change_skill(SKILL_MUSIC, rand(0,0))
		H.my_skills.change_skill(SKILL_OBSERV, rand(2,2))
		H.my_skills.change_skill(SKILL_SWORD, rand(0,4))
		H.my_skills.change_skill(SKILL_UNARM, rand(1,2))
		H.add_verb(/mob/living/carbon/human/proc/special_reinforcement)
		H.create_kg()
		H.outsider = TRUE
		H.siegesoldier = TRUE
		if(ticker.mode.config_tag == "siege")
			var/datum/game_mode/siege/S = ticker.mode
			S.siegerslist += H
			S.hascountheir = H
			H.update_all_siege_icons()
			if(S.count_family)
				S.count_family.add_member(H)
				matchmaker.update_family_icons(H)
		if(FAT in H.mutations) // no fat sprite for countheir coat, if you want fat count heir do it yourself or MAYBE? ask spooky
			H.mutations.Remove(FAT)
		return 1
