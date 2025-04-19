
/mob/living/carbon
	var/datum/skills/my_skills = null

	proc
		init_skills()
			var/datum/skills/newSkills = new
			newSkills.host = src
			newSkills.rand_skills()
			my_skills = newSkills

/datum/skills
	var/mob/living/carbon/host = null
	var/list/skills_holder[SKILL_SIZE]
	var/list/prepare_learn = list()
	var/max_value = 10 //Maxium that can be learn through regular actions.

/*
skills are kept in a global list because they don't need to change runtime
and we don't want every human to have 37 copies of the same thing.
*/
var/static/list/global_skills

/datum/skills/New()
	if(!global_skills)
		global_skills = list()
		for(var/skill_type in subtypesof(/datum/skill))
			var/datum/skill/skill = new skill_type
			global_skills += skill
	for(var/datum/skill/skill in global_skills)
		skills_holder[skill.id] = list("value" = 0, "data"= skill)


/datum/skills/proc/add_skill(stat, n)
	var/S = get_skill_value(stat,src)
	S += n
	if(!S)
		return 0
	get_skill_value(stat,src) = S
	return S

/datum/skills/proc/reduce_skill(stat, n)
	var/S = get_skill_value(stat,src)
	S -= n
	if(!S)
		return 0
	get_skill_value(stat,src) = S
	return S

/datum/skills/proc/change_skill(stat, n)
	get_skill_value(stat,src) = n
	return n

/datum/skills/proc/get_skill(stat)
	var/S = get_skill_value(stat,src)
	if(!S)
		return 0
	return S

/datum/skills/proc/get_skill_name(stat)
	var/S = get_skill_data(stat,src)
	if(!S)
		return 0
	return S:name

/datum/skills/proc/rand_skills()
	change_skill(SKILL_MELEE,0)
	change_skill(SKILL_RANGE,0)
	change_skill(SKILL_FARM,0)
	change_skill(SKILL_COOK,0)
	change_skill(SKILL_ENGINE,0)
	change_skill(SKILL_SURG,0)
	change_skill(SKILL_MEDIC,0)
	change_skill(SKILL_CLEAN,0)
	change_skill(SKILL_MASON,0)
	change_skill(SKILL_SMITH,0)
	change_skill(SKILL_CLIMB,0)
	change_skill(SKILL_SWIM, 0)
	change_skill(SKILL_UNARM,0)
	change_skill(SKILL_PARTY, rand(0,2))
	change_skill(SKILL_SURVIV, rand(0,1))
	change_skill(SKILL_CRAFT, rand(0,1))
	change_skill(SKILL_TAN, rand(1,2))

/datum/skills/proc/job_skills(job)
	if(job && istype(job, /datum/job))
		var/datum/job/J = job
		for(var/list/l in J.skill_mods)
			if(l.len > 2)
				change_skill(l[1],rand(l[2],l[3]))
			else
				change_skill(l[1],l[2])

	if(host.gender == FEMALE)
		if(get_skill(SKILL_CLEAN) <= 7)
			change_skill(SKILL_CLEAN,rand(7,9))
		if(get_skill(SKILL_COOK) <= 7)
			change_skill(SKILL_COOK,rand(7,9))

/******************************************/
/*     STATS, ST, HT, IT, DEX             */
/******************************************/
/mob/living/carbon
	var/datum/stat_holder/my_stats = null
	proc
		init_stats()
			var/datum/stat_holder/newStats = new
			newStats.host = src
			newStats.rand_stats()
			my_stats = newStats

proc/strToDamageModifier(strength, ht)
	var/diff = strength - ht
	var/baseDamage = 5

	if(diff < 0)
		var/parsedDiff = diff * -1
		for(var/x = 0; x < parsedDiff; x++)
			baseDamage -= rand(1, 3)
	if(diff > 0)
		for(var/x = 0; x < diff; x++)
			baseDamage += rand(4, 7)

	if(baseDamage <= 0){
		baseDamage = 3
	}
	return baseDamage

	//SISTEMA ANTIGO
	//ACHO QUE VAI SER PIOR QUE O ATUAL, SE DEUS QUISER O ATUAL É MELHOR

	switch(strength) //HAHAHAHAHAHAHAHAHAHAHAHAH AHHAHAH SIMM!!
		if(1) return 1
		if(2) return 2.5
		if(3) return 3
		if(4) return 5
		if(5) return 6
		if(6) return 8
		if(7) return 9
		if(8) return 10
		if(9) return 11
		if(10) return 12
		if(11) return 14
		if(12) return 17
		if(13) return 19
		if(14) return 24
		if(15) return 27
		if(16) return 30
		if(17) return 33
		if(18) return 36
		if(19) return 40
		if(20) return 42
		if(21) return 43
		if(22) return 44
		if(23) return 45
		if(24) return 46
		if(25) return 47
		if(26) return 49
		if(27) return 51
		if(29) return 53
		if(30) return 55
		if(31) return 57
		if(32) return 60
		if(32 to INFINITY)
			return rand(60, 80)

/obj/item/proc/getNewWeaponForce(st, ht){
	var/diff = st - 10
	var/newForce = force

	if(diff < 0) // 8 DE ST BATE EM 12
		var/parsedDiff = diff * -1
		var/sum = 0
		for(var/x = 0; x < parsedDiff; x++)
			sum += newForce / 12
			newForce -= sum
	if(diff > 0)
		var/sum = 0
		for(var/x = 0; x < diff; x++)
			sum += newForce / 10
			newForce += sum

	if(newForce < 0){
		newForce = 0
	}
	return newForce
}

//BASICAMENTE A PROC ABAIXO O PLANO É SER SUBSTITUIDA PELA DE CIMA
//A DE BAIXO É MUITO CAGADA E DEIXA TUDO ROUBADO!!!
proc/strToDamageModifierItem(strength, ht)
	switch(strength)
		if(1 to 5)
			return 1//+3 +3

		if(6 to 9)
			return 3.5//+2 +5

		if(10 to 12)
			return 4

		if(12 to 14)
			return 4.8//+3 +5

		if(14 to 16)
			return 5

		if(16 to 20)
			return 7
		if(20 to 25)
			return 30
		if(25 to 30)
			return 40
		if(31 to INFINITY)
			return 80


/datum/stat_holder
	var/mob/living/carbon/human/host = null
	var/list/datum/stat_mod/stat_mods = list()
	var/list/stats = list(
		STAT_ST  = 10,
		STAT_DX  = 10,
		STAT_HT  = 10,
		STAT_IN  = 10,
		STAT_PR  = 0,
		STAT_WP  = 1,
		STAT_IM  = 0,
		STAT_SPD = 0
	)

/datum/stat_holder/proc/get_stat(x)
	switch(x)
		if(STAT_PR)
			return round(max(stats[STAT_PR] + stats[STAT_IN],0))
		if(STAT_IM)
			return round(max(stats[STAT_HT] + stats[STAT_IM],0))
		else
			return round(max(stats[x],0))

/datum/stat_holder/proc/change_stat(stat, amount)
	if(stats[stat] != null)
		stats[stat] += amount
	if(stats[stat] < 0)
		stats[stat] = 0

/datum/stat_holder/proc/set_stat(stat, amount)
	if(stats[stat] != null)
		stats[stat] = amount
	if(stats[stat] < 0)
		stats[stat] = 0

/datum/stat_holder/proc/job_stats(job)

	if(job && istype(job, /datum/job))
		var/datum/job/J = job
		for(var/i in 1 to J.stat_mods.len)
			stats[i] += J.stat_mods[i]

	host.special_load()
	if(FAT in host.mutations)
		change_stat(STAT_ST, 1)
		change_stat(STAT_DX, -2)
		change_stat(STAT_HT, 1)
	if(host.gender == FEMALE && !host.has_penis())
		change_stat(STAT_ST, -1)
	if(host.age >= 50)
		change_stat(STAT_ST, -1)
		change_stat(STAT_HT, -1)
		change_stat(STAT_IN, 2)
		change_stat(STAT_PR, 2)
	if(host.age <= 16)
		set_stat(STAT_ST, rand(7,9))
		set_stat(STAT_HT, rand(8,10))

/datum/stat_holder/proc/rand_stats()
	for(var/i in 1 to 4)
		change_stat(i,BASE_STAT_CHANGE)

/**************************************
************HUMAN MY NIGGA*************
***************************************/

proc/skilltxt(skill)
	switch(skill)
		if(-INFINITY to 0)
			return "<small>Pathetic</small>"
		if(1)
			return "Worthless"
		if(2)
			return "Novice"
		if(3 to 4)
			return "Skilled"
		if(5 to 6)
			return "Adept"
		if(7 to 8)
			return "<B>Expert</B>"
		if(9)
			return "<B>Master</B>"
		if(10 to INFINITY)
			return "<span class='greentext'><B>Legendary</B></span>"



proc/skilltxt2(skill)
	switch(skill)
		if(-INFINITY to 0)
			return "<span class='notthatbadactually'>0"
		if(1)
			return "<span class='notthatbadactually'>1"
		if(2)
			return "<span class='notthatbadactually'>2"
		if(3)
			return "<span class='notthatbadactually'>3"
		if(4)
			return "<span class='notthatbadactually'>4"
		if(5)
			return "<span class='notthatbadactually'>5"
		if(6)
			return "<span class='notthatbadactually'>6"
		if(7)
			return "<span class='notthatbadactually'>7"
		if(8)
			return "<span class='notthatbadactually'>8"
		if(9)
			return "<span class='notthatbadactually'>9"
		if(10 to INFINITY)
			return "<span class='notthatbadactually'>10"

/mob/living/carbon/human/proc/check_skills(all_skills = FALSE)
	var/list/combat  = list()
	var/list/combat_numbers = list()
	var/list/general = list()
	for(var/skill_id in 1 to my_skills.skills_holder.len)
		var/datum/skill/S = get_skill_data(skill_id,my_skills)
		var/value = get_skill_value(skill_id,my_skills)
		var/skill_num = skill_id
		if((!all_skills || !S.showing_text) && value <= 0)
			continue
		if(S.combat_skill == TRUE)
			if(S.showing_text)
				combat += skill_num
			else
				combat_numbers += skill_num

		else
			general += skill_num
	var/msg = "<div class='infodiv mood'>"

	msg += "<B>Combat Skills</B>:\n"
	for(var/i in combat)
		var/value = get_skill_value(i,my_skills)
		var/datum/skill/S = get_skill_data(i,my_skills)
		if(S.showing_text)
			msg += "- [S.name]: [skilltxt(value)]\n"
		else
			msg += "- [S.name]: [skilltxt2(value)]\n"

	for(var/i in combat_numbers)
		var/value = get_skill_value(i,my_skills)
		var/datum/skill/S = get_skill_data(i,my_skills)
		if(S.showing_text)
			msg += "- [S.name]: [skilltxt(value)]\n"
		else
			msg += "- [S.name]: [skilltxt2(value)]\n"

	msg += "<hr class='linexd'>"

	msg += "<B>General Skills</B>:\n"

	for(var/i in general)
		var/value = get_skill_value(i,my_skills)
		var/datum/skill/S = get_skill_data(i,my_skills)
		if(S.showing_text)
			msg += "- [S.name]: [skilltxt(value)]\n"
		else
			msg += "- [S.name]: [skilltxt2(value)]\n"

	msg += "\n"
	for(var/datum/perk/PERK in src.perks)
		msg += "<span class='nicebleak'>*[PERK.description]</span>\n"
	to_chat(src, "[msg]</div> ", TRUE)




#define SKILL_SUCESSO 1
#define SKILL_FALHA 0

proc/skillcheck(var/skill, var/requirement, var/show_message, var/mob/user, var/message = "I have failed to do this.")//1 - 100
	skill = (skill+2)*10
	var/mob/living/carbon/human/H = user
	if(requirement > skill)
		if(prob(H.happiness*4))
			return SKILL_SUCESSO
		else if(prob(skill-10+max(0, H.happiness)))
			return SKILL_SUCESSO
		else
			return SKILL_FALHA
	else if(skill > requirement)
		if(prob(skill+H?.happiness+rand(4,9)))
			return SKILL_SUCESSO
		else
			return SKILL_FALHA


proc/statcheck(stat, requirement, show_message, mob/user, message = "I have failed to do this.")//1 - 100
	var/dice = "1d20"
	if(stat < requirement)
		var/H = roll(dice)
		var/requiredroll = requirement - 1
		if(requiredroll < H)
			return 1
		else
			return 0
	else
		var/rola = roll("1d5")
		if(rola == 1)
			return 0
		else
			return 1

/mob/living/carbon/human/proc/gainWP(displaymsg, wpgain)
	if(src.special == "doublewp" && wpgain > 0)
		wpgain = wpgain * 2
	src.my_stats.change_stat(STAT_WP , wpgain)
	if(displaymsg)
		src << 'sound/effects/wisewoman.ogg'
		if(wpgain < 0)
			to_chat(src, "<span class='redtext'><B>LOST [wpgain]WP!</B></span>")
		else
			to_chat(src, "<span class='passive'>GAINED [wpgain]WP!</span>")

/mob/living/carbon/human/proc/learn_skill(skill, from, extramodif = 0, show = FALSE)
	if(!mind)
		return
	if(!skill || !my_skills.skills_holder[skill] || my_skills.get_skill(skill) >= my_skills.max_value)
		return
	var/datum/skill/S = get_skill_data(skill,my_skills)
	var/skill_value = my_skills.get_skill(skill)
	var/learn_bonus = extramodif
	var/learning_mod = 0
	var/mob/living/carbon/human/H
	var/obj/structure/lifeweb/statue/dummy/D
	if(mind)
		learning_mod += mind.learning_modif

	if(from)
		if(istype(from, /mob/living/carbon/human))
			H = from
			if(H.my_skills.get_skill(skill) <= my_skills.get_skill(skill))
				return
			if(H.mind)
				learn_bonus += H.mind.teaching_modif
				if(H.check_perk(/datum/perk/ref/teaching))
					learn_bonus += 3
		else if(istype(from, /obj/structure/lifeweb/statue/dummy))
			D = from
			learn_bonus += D.teaching_mod

	learning_mod += learn_bonus
	var/list/roll_result = roll3d6(src,my_stats.get_stat(STAT_IN), learning_mod, TRUE,TRUE)
	var/margin = roll_result[GP_MARGIN]
	margin += learn_bonus + learning_mod - skill_value
	if(margin <= 0)
		margin = 1
	if(H)
		margin += max((H.my_skills.get_skill(skill) - my_skills.get_skill(skill)) * 10, 1)
	if(S.combat_skill)
		margin = max(round(margin / 2), 1)
	switch(roll_result[GP_RESULT])
		if(GP_CRITSUCCESS)
			mind.learning_collector[skill] += (margin * 2)
			if(H)
				to_chat(src, SPAN_PBOLD("Oh, I get it!"))
			else if(D)
				var/text_skill = skill2typerson(round((mind.learning_collector[skill]) / (max(1, skill_value))))
				to_chat(src, SPAN_PBOLD("Oh, I get it!"))
				to_chat(src, SPAN_PBOLD("I understand: [text_skill]</span> \n"), 1)
		if(GP_SUCCESS)
			mind.learning_collector[skill] += margin
			if(H)
				to_chat(src, SPAN_PASSIVE("Oh, I get it."))
			else if(D)
				var/text_skill = skill2typerson(round((mind.learning_collector[skill]) / (max(1, skill_value))))
				to_chat(src, SPAN_PBOLD("I understand: [text_skill] \n"), 1)
		if(GP_FAIL)
			if(H)
				to_chat(src, SPAN_RED("It's hard to understand."))
				H.want_punch(src)
		if(GP_CRITFAIL)
			if(H)
				to_chat(src, SPAN_RED("<B>It's very hard to understand!</B>"))
				rotate_plane()
				H.want_punch(src)

	check_learning(skill)

/mob/living/carbon/human/proc/check_learning(skill)
	if(!mind)
		return FALSE
	if(!mind.learning_collector[skill])
		return FALSE
	var/skill_value = 1
	if(!(my_skills.get_skill(skill) <= 0))
		skill_value = my_skills.get_skill(skill)

	var/learned = mind.learning_collector[skill]
	var/maxlearn = 20 * skill_value

	if(learned < maxlearn)
		return FALSE

	my_skills.add_skill(skill, 1)
	mind.learning_collector[skill] = 0
	to_chat(src, "<span class='holyshituractuallysogooditmakesmecringedudelol'>I learned more about [lowertext(my_skills.get_skill_name(skill))]!</span>")
	return TRUE


/mob/living/carbon/human/proc/skill2typerson(amount)
	switch(amount)
		if(0)
			return "...................."
		if(1)
			return "*..................."
		if(2)
			return "**.................."
		if(3)
			return "***................."
		if(4)
			return "****................"
		if(5)
			return "*****..............."
		if(6)
			return "******.............."
		if(7)
			return "*******............."
		if(8)
			return "********............"
		if(9)
			return "*********..........."
		if(10)
			return "**********.........."
		if(11)
			return "***********........."
		if(12)
			return "************........"
		if(13)
			return "*************......."
		if(14)
			return "**************......"
		if(15)
			return "***************....."
		if(16)
			return "****************...."
		if(17)
			return "*****************..."
		if(18)
			return "******************.."
		if(19)
			return "*******************."
		if(20 to INFINITY)
			return "********************"

/mob/living/carbon/human/proc/teach_others()
	if(stat || !(length(my_skills.skills_holder))) return
	var/list/skills_list = list()
	for(var/skill_id in 1 to my_skills.skills_holder.len)
		var/datum/skill/S = get_skill_data(skill_id,my_skills)
		var/value = get_skill_value(skill_id,my_skills)
		if(!S)
			continue
		if(value <= 0)
			continue
		skills_list[S.name] = skill_id
	if(!length(skills_list))
		to_chat(src, "<span class='redtext'>I'm dumb...</span>")
		return
	var/teaching_skill = input(src, "Which skill i want to teach them?", "Thinking") in skills_list
	if(!teaching_skill) return
	var/teaching_text = sanitize(input(src, "What i want to say?", "Telling", "") as message)
	if(!teaching_text) return

	say(teaching_text)

	var/text_power = round(length(teaching_text) / 20)

	for(var/mob/living/carbon/human/M in view(3))
		if(M == src) continue
		if(M.my_skills.get_skill(skills_list[teaching_skill]) >= my_skills.get_skill(skills_list[teaching_skill])) continue
		M.ready_to_learn(text_power, src, skills_list[teaching_skill])


/mob/living/carbon/human/proc/ready_to_learn(var/text_power, var/mob/living/carbon/human/who, var/skill)
	var/to_delete = "[skill]-[world.time]"
	my_skills.prepare_learn[to_delete] = list(skill, who, text_power)
	spawn(50)
		if(to_delete in my_skills.prepare_learn)
			my_skills.prepare_learn.Remove(to_delete)

/mob/living/carbon/human/proc/spendWP()
	if(my_stats.get_stat(STAT_WP) <= 0)	return
	if(willpower_active)
		to_chat(src, "I already am spending my willpower.")
		return
	var/wpPicked

	var/multiplier = 1
	var/list/WPList = list("+1 ST" = STAT_ST,"+1 DX" = STAT_DX,"+1 IN" = STAT_IN, "+1 HT" = STAT_HT, "+2 PR" = STAT_PR, "+4 IM" = STAT_IM, "Resist Disgust")
	if(src.check_perk(/datum/perk/heroiceffort))
		multiplier = 2
		WPList += "Stamina Effort"

	WPList += "(CANCEL)"

	wpPicked = input(src,"Please, select an effort!","Triumph of the Will",wpPicked) in WPList
	if(willpower_active)
		to_chat(src, "I already am spending my willpower.")
		return

	var/wp_target //this is shit
	var/amount
	if(WPList[wpPicked]) //this means we have a stat
		wp_target = WPList[wpPicked]
		amount = text2num(copytext(wpPicked,2,3)) //this is even worse
		var/list/stat_list = list(
		STAT_ST  = 0,
		STAT_DX  = 0,
		STAT_HT  = 0,
		STAT_IN  = 0,
		STAT_PR  = 0,
		STAT_WP  = 0,
		STAT_IM  = 0,
		STAT_SPD = 0)
		stat_list[wp_target] = amount*multiplier
		src.my_stats.add_mod("spent_WP", stat_list, time = 1200, override = TRUE, override_timer = TRUE)
		willpower_active = num2text(amount*multiplier) + copytext(wpPicked,3,0)
		spawn(1200)
			willpower_active = ""
			to_chat(src, "The Willpower effect wears off.")
		gainWP(1, -1)
		spawn(5)
			src << 'sound/effects/wpspent.ogg'
	else
		switch(wpPicked)
			if("Resist Disgust")
				src.resisting_disgust = TRUE
				willpower_active = "Resisting Disgust"
				spawn(1200)
					src.resisting_disgust = FALSE
					willpower_active = ""
					to_chat(src, "The Willpower effect wears off.")
			if("Stamina Effort")
				src.stamina_loss = max(0, stamina_loss-50)
			if("(CANCEL)")
				return
		gainWP(1, -1)
		spawn(5)
			src << 'sound/effects/wpspent.ogg'