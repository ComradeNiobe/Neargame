/datum/craft_recipe/wonders
	var/key
	skillRequired = SKILL_CRAFT

/datum/craft_recipe/wonders/INRI
	name = "Wonder"
	id = "INRI"
	key = 1
	materials = list(/obj/item/bone = 2, /obj/item/skull = 1, /obj/item/reagent_containers/food/snacks/organ/lungs = 3)
	desc_materials = "Bones: 2, Skulls: 1, Lungs: 3"
	path_type = /obj/structure/wonder/first

/datum/craft_recipe/wonders/INRR
	name = "Wonder"
	id = "INRR"
	key = 2
	materials = list(/obj/item/reagent_containers/food/snacks/organ/guts = 2, /obj/item/organ/jaw = 2, /obj/item/reagent_containers/food/snacks/organ/liver = 1)
	desc_materials = "Guts: 2, Jaw: 2, Livers: 1"
	path_type = /obj/structure/wonder/second

/datum/craft_recipe/wonders/INTR
	name = "Wonder"
	id = "INTR"
	key = 3
	materials = list(/obj/item/reagent_containers/food/snacks/organ/stomach = 2, /obj/item/bone = 2, /obj/item/organ/eye = 1)
	desc_materials = "Stomach: 2, Bones: 2, Eye: 1"
	path_type = /obj/structure/wonder/third

/datum/craft_recipe/wonders/INRF
	name = "Wonder"
	id = "INRF"
	key = 4
	materials = list(/obj/item/organ/eye = 2, /obj/item/reagent_containers/food/snacks/organ/kidneys = 1, /obj/item/reagent_containers/food/snacks/organ/stomach = 2)
	desc_materials = "Eye: 2, Kidneys: 1, Stomach: 2"
	path_type = /obj/structure/wonder/fourth

/mob/living/carbon/human/proc/dreamer()
	set name = "Wonders"
	set desc = "Wonders"
	set category = "gpc"

	usr << browse(dreamRecipes(), "window=dreamercreation;size=300x650;can_close=1;can_resize=0;border=0;titlebar=1")

/mob/living/carbon/human/proc/dreamRecipes()
	var/fullHTML = "<html><head><style>.desc{color: #434446; font-size: 65%} .materials{color: #434446; font-size: 70%;} a{color:#656366; font-size: 76%;  font-weight: bold; text-decoration: none; font-decoration: none} a:hover{background-color: #656366; color: black} body{font-size: 135%}</style><title>Crafting</title> <body style='background-color:#0e0c0e; color: #43302f; text-align: center;'> <h3 style='color: #49484a;'>Craft</h3>"

	var/list/recipes = subtypesof(/datum/craft_recipe/wonders)

	for(var/C in recipes)
		var/datum/craft_recipe/wonders/CR = new C
		var/dreamKey
		switch(CR.key)
			if(1)
				dreamKey = usr.mind.antag_datums.heart_key1
			if(2)
				dreamKey = usr.mind.antag_datums.heart_key2
			if(3)
				dreamKey = usr.mind.antag_datums.heart_key3
			if(4)
				dreamKey = usr.mind.antag_datums.heart_key4
		fullHTML += "<A href='byond://?src=\ref[src];[CR.id]=1'>[CR.name] [dreamKey]</A><BR><span class='materials'>[CR.desc_materials]</span><BR><BR>"
		qdel(CR)

	fullHTML += "<BR><BR><div class='desc'>* materials go under the character</div><div class='desc'>** Between the walls</div></body></head></html>"
	return fullHTML

/mob/living/carbon/human/proc/dreamerArchetypes(mob/living/carbon/human/H)
	set hidden = 0
	set name = "dreamerArchetypes"
	set category = "The Dreamer"
	set desc = "The Nightmare"

	var/list/dreamerArchetypeList = list("The Chaser", "The Brute")
	H.dreamerArchetype = input(H,"Select your archetype.","DREAMER ARCHETYPES") in dreamerArchetypeList
	switch(H.dreamerArchetype)
		if("The Chaser") // Ghostface
			H.dreamerArchetype = DREAMER_GHOSTFACE

			H.my_skills.change_skill(SKILL_MELEE, 17)
			H.my_skills.change_skill(SKILL_RANGE, 0)
			H.my_skills.change_skill(SKILL_CRAFT, 15)
			H.my_skills.change_skill(SKILL_CLIMB, 17)
			H.my_skills.change_skill(SKILL_KNIFE, 17)
			H.my_skills.change_skill(SKILL_SNEAK, 17)

			H.my_stats.change_stat(STAT_ST , 5)
			H.my_stats.change_stat(STAT_DX , 15)
			H.my_stats.change_stat(STAT_HT , 15)

			H.add_perk(/datum/perk/ref/silent)
			H.add_perk(/datum/perk/ref/jumper)
			H.add_perk(/datum/perk/ref/slippery)

			to_chat(H, SPAN_DREAMER("BEHIND THE STATUES HAVE WHAT I SEEK."))
			H.verbs -= /mob/living/carbon/human/proc/dreamerArchetypes
		if("The Brute") // Classic Dreamer
			H.dreamerArchetype = DREAMER_BRUTE

			H.my_skills.change_skill(SKILL_MELEE, 17)
			H.my_skills.change_skill(SKILL_RANGE, 0)
			H.my_skills.change_skill(SKILL_CRAFT, 15)
			H.my_skills.change_skill(SKILL_UNARM, 17)

			H.my_stats.change_stat(STAT_ST , 15)
			H.my_stats.change_stat(STAT_DX , 5)
			H.my_stats.change_stat(STAT_HT , 15)

			H.add_perk(/datum/perk/ref/strongback)
			H.add_perk(/datum/perk/morestamina)
			H.add_perk(/datum/perk/ref/disarm)
			H.verbs -= /mob/living/carbon/human/proc/dreamerArchetypes