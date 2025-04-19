//XOMITAS QUE ELE VAI AFETAR
var/global/list/xomStatues = list()
var/global/list/xomites = list()

//PRIMEIRO ITEM DA LISTA É A PROBABILIDADE DO EVENTO ACONTECER, O SEGUNDO É A PROC DO EVENTO
var/global/list/xomPowers = list(
	list(20, /mob/living/carbon/human/proc/letsseeafriend),
	list(15, /mob/living/carbon/human/proc/spawnmonsters),
	list(3, /mob/living/carbon/human/proc/throughfire),
	list(10, /mob/living/carbon/human/proc/flylikeabird),
	list(15, /mob/living/carbon/human/proc/getrich),
	list(15, /mob/living/carbon/human/proc/turnintoblackperson),
	list(10, /mob/living/carbon/human/proc/fakeneckwrench),
	list(1, /mob/living/carbon/human/proc/wingame),
	list(10, /mob/living/carbon/human/proc/penisgigante),
	)

//EU DEVIA FAZER UM DATUM MAS FODASE!!
var/xomPhrases = list("Teasing time!", "Have you ever been suckled by a god?", "God forgive me.. but I will have to fight the envious.", "Invite me to the party...", "The zueira never ends!", "YOU ARE MY SOW!", "Shut up motherfucker!", "You are gay.", "Heterosexuals will ruin this planet.", "Is it 17 or is it not?", "Praise Chance!", "Change is necessary.", "I have seen the beginning, and the end.", "I don't know what I am, I haven't had sex yet.", "Shut up retarded child!", "...")

/obj/structure/oldways
	name = "Xom"
	density = 1
	icon = 'icons/mining.dmi'
	icon_state = "XOM"
	var/convertPhrase = list("Are you from the zueira?", "Do you hear the call?", "The zueira can't end..", "Oh my God.", "Get out of here, I'm taking a shower!")
	var/textColor = "#808080"
	var/fontSize = "100%"
	anchored = 1
	breakable = TRUE
	hits = 25

/obj/structure/oldways/xom
	icon_state = "XOM"
	fontSize = "133%"

/obj/structure/oldways/xom/New()
	..()
	xomStatues += src

/obj/structure/oldways/RightClick(mob/living/carbon/human/user)
	if(user.old_ways.god == name || user.religion != "Old Ways")
		return
	var/selection = alert("Do you accept [icon_state] as your leader?", "Old Ways", "Yes", "No")
	if(selection == "Yes")
		user.old_ways.god = name
		to_chat(user, "<b>You serve [name]</b> now!")
		if(prob(50))
			var/message = pick(convertPhrase)
			var/ending = copytext(convertPhrase, length(convertPhrase))
			var/icontogo = "h0"

			switch(ending)
				if("!")
					visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>[message]</b></span></span>\"")
					icontogo = "h2"
				if("?")
					visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]; font-size'>[name]</b></span> <span class='sayverb'>asks, </span>\"<span class='saybasic'>[message]</span></span>\"")
					icontogo = "h1"
				else
					visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>says, </span>\"<span class='saybasic'>[message]</span></span>\"")

			var/image/objchatimage = image('icons/mob/talk.dmi', src, "[icontogo]", "[layer]")
			overlays += objchatimage

			spawn(15)
				overlays -= objchatimage
		playsound(user, 'sound/effects/oldways_convert.ogg', 100, 1)

		if(name == "Xom")
			xomites += user

			spawn(rand(25, 55))
				if(prob(54))
					user.yourenew()
		return
	return

/datum/controller/gameticker/process()
	..()
	if(prob(35))
		if(prob(35))
			if(!xomites.len)
				return
			var/mob/living/carbon/human/victim = pick(xomites)

			if(!victim)
				return
			if(victim.stat == DEAD)
				return
			var/list/chosenPower = pick(xomPowers)
			playsound(victim, 'sound/xom.ogg', 100, 1)
			if(prob(chosenPower[1]))
				return call(victim, chosenPower[2])()
			else
				var/message = pick(xomPhrases)
				var/ending = copytext(message, length(message))
				var/icontogo = "h0"

				switch(ending)
					if("!")
						to_chat(victim, "<span style='font-size: 133%'><span class='saybasic'><b style='color: #808080'>Xom</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>[message]</b></span></span>\"")
						icontogo = "h2"
					if("?")
						to_chat(victim, "<span style='font-size: 133%'><span class='saybasic'><b style='color: #808080'>Xom</b></span> <span class='sayverb'>asks, </span>\"<span class='saybasic'>[message]</span></span>\"")
						icontogo = "h1"
					else
						to_chat(victim, "<span style='font-size: 133%'><span class='saybasic'><b style='color: #808080'>Xom</b></span> <span class='sayverb'>says, </span>\"<span class='saybasic'>[message]</span></span>\"")

				for(var/obj/structure/oldways/O in xomStatues)
					var/image/objchatimage = image('icons/mob/talk.dmi', O, "[icontogo]", O.layer)
					O.overlays += objchatimage

					spawn(15)
						O.overlays -= objchatimage

/mob/living/carbon/human/proc/yourenew(var/fontSize = "133%", var/textColor = "#808080  ", var/name = "Xom")
	visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>You're new!</b></span></span>\"")

	my_stats.change_stat(STAT_ST , rand(-3,3))
	my_stats.change_stat(STAT_HT , rand(-3,3))
	my_stats.change_stat(STAT_DX , rand(-3,3))
	my_stats.change_stat(STAT_IN , rand(-3,3))

/mob/living/carbon/human/proc/wingame(var/fontSize = "133%", var/textColor = "#808080  ", var/name = "Xom")
	visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>Do you want to know the truth?</b></span></span>\"")
	spawn(200)
		src.unlock_medal("Xomed", 0, "Finish game through Xom.", "17")
		bans.Add(ckey)
		qdel(src?.client)

/mob/living/carbon/human/proc/givechromies(var/fontSize = "133%", var/textColor = "#808080", var/name = "Xom")
	if(!client)
		return
	to_chat(src, "<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>Take a present for yourself!</b></span></span>\"")

	var/timesToChromie = rand(1, 4)
	var/removeLater = 0
	for(var/x = 0; x != timesToChromie; x++)
		var/randChromies = rand(1, 5)
		removeLater += randChromies
		client.ChromieWinorLoose(randChromies)
		sleep(1)

	spawn(rand(70, 130))
		to_chat(src, "<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>It was brinks! I don't like people like you!</b></span></span>\"")
		client.ChromieWinorLoose(-1 * removeLater)

/mob/living/carbon/human/proc/letsseeafriend(var/fontSize = "133%", var/textColor = "#808080", var/name = "Xom")
	var/list/friends = list()
	for(var/mob/living/carbon/human/bumbot/B in mob_list)
		friends += B

	if(!friends.len)
		return
	visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>You are too lonely!!</b></span></span>\"")

	spawn(rand(15, 25))
		var/mob/living/carbon/human = pick(friends)
		x = human.x
		y = human.y
		z = human.z
		visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>You two! Talk to each other!</b></span></span>\"")

/mob/living/carbon/human/proc/spawnmonsters(var/fontSize = "133%", var/textColor = "#808080", var/name = "Xom")
	visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>Troll! Zuei!</b></span></span>\"")

	for(var/turf/T in oview(9, src))
		var/monster = pick(subtypesof(/mob/living/carbon/human/monster))

		if(prob(10))
			new monster(T)
		if(prob(5))
			return

/mob/living/carbon/human/proc/throughfire(var/fontSize = "133%", var/textColor = "#808080", var/name = "Xom")
	var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
	visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>Through the fires and flames!</b></span></span>\"")

	on_fire = 1
	update_fire()

	for(var/dir in dirs)
		var/turf/T = get_step(src, dir)

		new /obj/structure/fire(T)

/mob/living/carbon/human/Life()
	..()
	if(on_fire)
		apply_damage(rand(15, 40), BURN, pick("l_foot", "r_foot", "l_leg", "r_leg", "chest", "head"))
		if(isturf(loc))
			var/turf/T = loc
			if(prob(50))
				new/obj/structure/fire(T)

/mob/living/carbon/human/proc/flylikeabird(var/fontSize = "133%", var/textColor = "#808080", var/name = "Xom")
	var/turf/T = locate(x, y, z + 1)

	if(!istype(T, /turf/simulated/floor/open))
		return

	visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>Fly like a pigeon!</b></span></span>\"")
	Move(T)
	T.Enter(src)

/mob/living/carbon/human/proc/getrich(var/fontSize = "133%", var/textColor = "#808080", var/name = "Xom")
	if(goldXoomed)
		return
	visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>Do you want to be rich and powerful? Shit! Shit!</b></span></span>\"")

	if(prob(75))
		bowels = 1000
		spawn(rand(60, 75))
			visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>The more poop you eat! Richer will be!</b></span></span>\"")
		return 1

	goldXoomed = 1
	spawn(rand(300, 600))
		goldXoomed = 0
	return 1

/mob/living/carbon/human/proc/fakeneckwrench(var/fontSize = "133%", var/textColor = "#808080", var/name = "Xom")
	visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>Hey. Goodbye. See you later.</b></span></span>\"")
	spawn(50)
		var/datum/organ/external/head/H = get_organ("head")
		neckXommed = 1
		if(H.headwrenched)
			H.unwrenchedhead()
			return
		H.wrenchedhead()


/mob/living/carbon/human/proc/turnintoblackperson(var/fontSize = "133%", var/textColor = "#808080", var/name = "Xom")
	if(s_tone <= -150){
		return
	}
	if(prob(2)){
		visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>Imitate Izumi!</b></span></span>\"")
	}
	visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>[name]</b></span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>Look at the bag!</b></span></span>\"")
	s_tone = -185
	update_body()

	var/res = prob(50) ? "l_leg" : "r_leg"
	if(prob(20)){
		var/datum/organ/external/leg = get_organ(res)

		leg.droplimb(1, 0)
	}

/mob/living/carbon/human/proc/penisgigante(var/fontSize = "133%", var/textColor = "#808080", var/name = "Xom")
	visible_message("<span style='font-size: [fontSize]'><span class='saybasic'><b style='color: [textColor]'>( ͡° ͜ʖ ͡°)</b></span></span>\"")

	penis_size = rand(5, 30)
	resistenza = rand(400, 500)
	lust = 10
