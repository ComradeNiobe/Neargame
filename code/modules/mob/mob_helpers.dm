
// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
/proc/isrobot(A)
	if(istype(A, /mob/living/silicon/robot))
		return 1
	return 0

/proc/iscorgi(A)
	if(istype(A, /mob/living/simple_animal/corgi))
		return 1
	return 0

/proc/iscrab(A)
	if(istype(A, /mob/living/simple_animal/crab))
		return 1
	return 0

/proc/iscat(A)
	if(istype(A, /mob/living/simple_animal/cat))
		return 1
	return 0

/proc/isspider(A)
	if(istype(A, /mob/living/simple_animal/hostile/giant_spider))
		return 1
	return 0

/proc/ismouse(A)
	if(istype(A, /mob/living/simple_animal/mouse))
		return 1
	return 0

/proc/isbear(A)
	if(istype(A, /mob/living/simple_animal/hostile/bear))
		return 1
	return 0

/proc/iscarp(A)
	if(istype(A, /mob/living/simple_animal/hostile/carp))
		return 1
	return 0

/proc/isclown(A)
	if(istype(A, /mob/living/simple_animal/hostile/retaliate/clown))
		return 1
	return 0

proc/iszombie(A)
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		if(H.species && (H.species.name == "Zombie" || H.species.name == "Zombie Child"))
			return 1
		if(H.zombie)
			return 1
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.zombie)
			return 1
	return 0

proc/isVampire(A)
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		if(H.isVampire)
			return 1
	return 0

proc/isskeleton(A)
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		if(H.species && istype(H.species, /datum/species/human/skeleton))
			return TRUE
		if(SKELETON in H.mutations)
			return TRUE
	return 0

proc/hasorgans(A)
	return ishuman(A)

/proc/hsl2rgb(h, s, l)
	return


/proc/check_zone(zone)
	if(!zone)	return "chest"
/*	switch(zone)
		if("eyes")
			zone = "head"
		if("mouth")
			zone = "head"
		if("l_hand")
			zone = "l_arm"
		if("r_hand")
			zone = "r_arm"
		if("l_foot")
			zone = "l_leg"
		if("r_foot")
			zone = "r_leg"
		if("groin")
			zone = "chest"
*/
	return zone


/proc/ran_zone(zone, probability)
	zone = check_zone(zone)
	if(!probability)
		probability = 90
	if(probability == 100)
		return zone

	if(zone == "chest")
		if(prob(probability))
			return "chest"
		var/t = rand(1, 9)
		switch(t)
			if(1 to 3)
				return "head"
			if(4 to 6)
				return "l_arm"
			if(7 to 9)
				return "r_arm"

	if(prob(probability * 0.90))
		return zone
	return "chest"

// Emulates targetting a specific body part, and miss chances
// May return null if missed
// miss_chance_mod may be negative.
/proc/get_zone_with_miss_chance(zone, var/mob/target, var/miss_chance_mod = 0)
	zone = check_zone(zone)

	// you can only miss if your target is standing and not restrained
	if(!target.buckled && !target.lying)
		var/miss_chance = 10
		switch(zone)
			if("head")
				miss_chance = 40
			if("l_leg")
				miss_chance = 20
			if("r_leg")
				miss_chance = 20
			if("l_arm")
				miss_chance = 20
			if("r_arm")
				miss_chance = 20
			if("l_hand")
				miss_chance = 50
			if("r_hand")
				miss_chance = 50
			if("l_foot")
				miss_chance = 50
			if("r_foot")
				miss_chance = 50
			if("groin")
				miss_chance = 90
			if("throat")
				miss_chance = 12
			if("vitals")
				miss_chance = 70
		miss_chance = max(miss_chance + miss_chance_mod, 0)
		if(prob(miss_chance))
			if(prob(70))
				return null
			else
				var/t = rand(1, 13)
				switch(t)
					if(1)	return "head"
					if(2)	return "l_arm"
					if(3)	return "r_arm"
					if(4) 	return "chest"
					if(5) 	return "l_foot"
					if(6)	return "r_foot"
					if(7)	return "l_hand"
					if(8)	return "r_hand"
					if(9)	return "l_leg"
					if(10)	return "r_leg"
					if(11)	return "vitals"
					if(12)	return "groin"
					if(13)	return "throat"

	return zone

//Replaces some of the characters with *, used in whispers. pr = probability of no star.
//Will try to preserve HTML formatting. re_encode controls whether the returned text is HTML encoded outside tags.
/proc/stars(n, pr = 25, re_encode = 1)
	if (pr < 0)
		return null
	else if (pr >= 100)
		return n

	var/intag = 0
	var/block = list()
	. = list()
	for(var/i = 1, i <= length_char(n), i++)
		var/char = copytext_char(n, i, i+1)
		if(!intag && (char == "<"))
			intag = 1
			. += stars_no_html(JOINTEXT(block), pr, re_encode) //stars added here
			block = list()
		block += char
		if(intag && (char == ">"))
			intag = 0
			. += block //We don't mess up html tags with stars
			block = list()
	. += (intag ? block : stars_no_html(JOINTEXT(block), pr, re_encode))
	. = JOINTEXT(.)

//Ingnores the possibility of breaking tags.
/proc/stars_no_html(text, pr, re_encode)
	text = html_decode(text) //We don't want to screw up escaped characters
	. = list()
	for(var/i = 1, i <= length_char(text), i++)
		var/char = copytext_char(text, i, i+1)
		if(char == " " || prob(pr))
			. += char
		else
			. += "*"
	. = JOINTEXT(.)
	if(re_encode)
		. = html_encode(.)

/proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng=length_char(phrase)
	var/counter=length_char(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext_char(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		switch(rand(1,15))
			if(1 to 4)	newletter="[lowertext(newletter)]"
			if(5 to 8)	newletter="[uppertext(newletter)]"
			if(9)	newletter+="'"
			else	newletter = newletter
		newphrase+="[newletter]";counter-=1
	return newphrase

/// t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added
/proc/Gibberish(t, p)
	/* Turn text into complete gibberish! */
	var/returntext = ""
	for(var/i = 1, i <= length_char(t), i++)

		var/letter = copytext_char(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")

		returntext += letter

	return returntext

/proc/stutter(phrase)
	phrase = rhtml_decode(phrase)

	var/list/split_phrase = dd_text2list(phrase," ") //Split it up into words.

	var/list/unstuttered_words = split_phrase.Copy()
	var/i = rand(1,3)
	/*if(stunned) */
	i = split_phrase.len
	for(,i > 0,i--) //Pick a few words to stutter on.

		if (!unstuttered_words.len)
			break
		var/word = pick(unstuttered_words)
		unstuttered_words -= word //Remove from unstuttered words so we don't stutter it again.
		var/index = split_phrase.Find(word) //Find the word in the split phrase so we can replace it.

		//Search for dipthongs (two letters that make one sound.)
		var/first_sound = copytext(word,1,7)
		var/first_letter = copytext(word,1,2)
		if(lowerrustext(first_sound) in list("&#255;"))
			first_letter = first_sound

		//Repeat the first letter to create a stutter.
		var/rnum = rand(1,3)
		switch(rnum)
			if(1)
				word = "[first_letter]-[word]"
			if(2)
				word = "[first_letter]-[first_letter]-[word]"
			if(3)
				word = "[first_letter]-[first_letter]-[first_letter]-[word]"

		split_phrase[index] = word

	return sanitize(dd_list2text(split_phrase," "))

proc/NoChords(t, p)
	var/returntext = ""
	for(var/i = 1, i <= length(t), i++)

		var/letter = copytext(t, i, i+1)
		if(prob(100))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("K","h","r","k","hr")

		returntext += letter

	return returntext

proc/Illiterate(t, p)
	var/returntext = ""
	for(var/i = 1, i <= length(t), i++)

		var/letter = copytext(t, i, i+1)
		if(prob(100))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("U","h","u","m","n")

		returntext += letter

	return returntext

/proc/ninjaspeak(n)
/*
The difference with stutter is that this proc can stutter more than 1 letter
The issue here is that anything that does not have a space is treated as one word (in many instances). For instance, "LOOKING," is a word, including the comma.
It's fairly easy to fix if dealing with single letters but not so much with compounds of letters./N
*/
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = 1
	while(p <= n)
		var/n_letter
		var/n_mod = rand(1,4)
		if(p+n_mod>n+1)
			n_letter = copytext(te, p, n+1)
		else
			n_letter = copytext(te, p, p+n_mod)
		if (prob(50))
			if (prob(30))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]")
			else
				n_letter = text("[n_letter]-[n_letter]")
		else
			n_letter = text("[n_letter]")
		t = text("[t][n_letter]")
		p=p+n_mod
	return copytext(sanitize(t),1,MAX_MESSAGE_LEN)


/proc/shake_camera(mob/M, duration, strength=1)
	if(!M || !M.client || M.shakecamera || M.stat || isAI(M))
		return
	M.shakecamera = 1
	spawn(1)
		if(!M.client)
			return

		var/atom/oldeye=M.client.eye
		var/x
		for(x=0; x<duration, x++)
			M.client.eye = locate(dd_range(1,M.loc.x+rand(-strength,strength),world.maxx),dd_range(1,M.loc.y+rand(-strength,strength),world.maxy),M.loc.z)
			sleep(1)
		M.client.eye=oldeye
		M.shakecamera = 0

#define TEMPO_BASE 7

/proc/recoil(mob/M)
	if(!M || !M.client || M.shakecameraslight || M.stat || isAI(M))
		return
	M.shakecameraslight = 1
	spawn(0)
		if(!M.client)
			return
		var/client/C = M.client
		for(var/i=1; i<=3; i++)
			var/_y = rand(-6, -3)
			spawn(TEMPO_BASE)
				animate(C, pixel_y = _y, time = TEMPO_BASE)
				spawn(TEMPO_BASE)
					animate(C, pixel_y = 0, time = TEMPO_BASE)
	M.shakecameraslight = 0

/proc/recoil_two(mob/M)
	if(!M || !M.client || M.shakecameraslight || M.stat || isAI(M))
		return
	M.shakecameraslight = 1
	var/TEST_EASING = pick(ELASTIC_EASING, BOUNCE_EASING, JUMP_EASING, LINEAR_EASING)
	var/_y = rand(-8, -6)

	var/rand1 = rand(1, 3)

	animate(M.client, pixel_y = _y, time = rand1, easing = TEST_EASING)
	sleep(rand1)
	animate(M.client, pixel_y = _y/2, time = rand1, easing = TEST_EASING)
	sleep(rand1)
	animate(M.client, pixel_y = _y, time = rand1, easing = TEST_EASING)
	sleep(rand1)
	animate(M.client, pixel_y = 0, time = rand1, easing = TEST_EASING)
	sleep(rand1)
	M.shakecameraslight = 0


#undef TEMPO_BASE

/proc/findname(msg)
	for(var/mob/M in mob_list)
		if (M.real_name == text("[msg]"))
			return 1
	return 0

/mob/proc/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask)))
		return 1

	if((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )))
		return 1

	return 0

//converts intent-strings into numbers and back
var/list/intents = list(I_HELP,I_DISARM,I_GRAB,I_HURT)
/proc/intent_numeric(argument)
	if(istext(argument))
		switch(argument)
			if(I_HELP)		return 0
			if(I_DISARM)	return 1
			if(I_GRAB)		return 2
			else			return 3
	else
		switch(argument)
			if(0)			return I_HELP
			if(1)			return I_DISARM
			if(2)			return I_GRAB
			else			return I_HURT

//change a mob's act-intent. Input the intent as a string such as "help" or use "right"/"left

/mob/verb/a_intent_change(input as text)
	set name = "a-intent"
	set hidden = 1

	if(ishuman(src) || isalienadult(src) || isbrain(src))
		switch(input)
			if(I_HELP,I_DISARM,I_GRAB,I_HURT)
				if(hand)
					left_hand_intent = input
					a_intent = input
				else
					right_hand_intent = input
					a_intent = input
			if("right")
				a_intent = intent_numeric((intent_numeric(a_intent)+1) % 4)
			if("left")
				a_intent = intent_numeric((intent_numeric(a_intent)+3) % 4)
		if(hud_used && hud_used.action_intent)
			hud_used.action_intent.icon_state = "[a_intent]"

	else if(isrobot(src) || ismonkey(src) || islarva(src))
		switch(input)
			if("help")
				a_intent = "help"
			if("hurt")
				a_intent = "hurt"
			if("right","left")
				a_intent = intent_numeric(intent_numeric(a_intent) - 3)
		if(hud_used && hud_used.action_intent)
			if(a_intent == "hurt")
				hud_used.action_intent.icon_state = "harm"
			else
				hud_used.action_intent.icon_state = "help"

/proc/get_both_hands(mob/living/carbon/M)
	var/list/hands = list(M.l_hand, M.r_hand)
	return hands


/proc/check_both_hands_empty(mob/living/carbon/M)
	if(M.l_hand)
		return 0
	if(M.r_hand)
		return 0
	return 1

/proc/get_location_accessible(mob/M, location)
	var/covered_locations	= 0	//based on body_parts_covered
	var/face_covered		= 0	//based on flags_inv
	var/eyesmouth_covered	= 0	//based on flags
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		for(var/obj/item/clothing/I in list(C.back, C.wear_mask))
			covered_locations |= I.body_parts_covered
			face_covered |= I.flags_inv
			eyesmouth_covered |= I.flags
		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			for(var/obj/item/I in list(H.wear_suit, H.w_uniform, H.shoes, H.belt, H.gloves, H.glasses, H.head, H.r_ear, H.l_ear))
				covered_locations |= I.body_parts_covered
				face_covered |= I.flags_inv
				eyesmouth_covered |= I.flags

	switch(location)
		if("head")
			if(covered_locations & HEAD)
				return 0
		if("eyes")
			if(covered_locations & HEAD || face_covered & HIDEEYES || eyesmouth_covered & GLASSESCOVERSEYES)
				return 0
		if("mouth")
			if(covered_locations & HEAD || face_covered & HIDEFACE || eyesmouth_covered & MASKCOVERSMOUTH)
				return 0
		if("chest")
			if(covered_locations & UPPER_TORSO)
				return 0
		if("groin")
			if(covered_locations & LOWER_TORSO)
				return 0
		if("l_arm")
			if(covered_locations & ARM_LEFT)
				return 0
		if("r_arm")
			if(covered_locations & ARM_RIGHT)
				return 0
		if("l_leg")
			if(covered_locations & LEG_LEFT)
				return 0
		if("r_leg")
			if(covered_locations & LEG_RIGHT)
				return 0
		if("l_hand")
			if(covered_locations & HAND_LEFT)
				return 0
		if("r_hand")
			if(covered_locations & HAND_RIGHT)
				return 0
		if("l_foot")
			if(covered_locations & FOOT_LEFT)
				return 0
		if("r_foot")
			if(covered_locations & FOOT_RIGHT)
				return 0

	return 1