var/list/department_radio_keys = list(
	  ":r" = "right ear",	"#r" = "right ear",		".r" = "right ear",
	  ":l" = "left ear",	"#l" = "left ear",		".l" = "left ear",
	  ":i" = "intercom",	"#i" = "intercom",		".i" = "intercom",
	  ":h" = "department",	"#h" = "department",	".h" = "department",
	  ":+" = "special",		"#+" = "special",		".+" = "special", //activate radio-specific special functions
	  ":c" = "Command",		"#c" = "Command",		".c" = "Command",
	  ":n" = "Science",		"#n" = "Science",		".n" = "Science",
	  ":m" = "Medical",		"#m" = "Medical",		".m" = "Medical",
	  ":e" = "Engineering", "#e" = "Engineering",	".e" = "Engineering",
	  ":s" = "Security",	"#s" = "Security",		".s" = "Security",
	  ":w" = "whisper",		"#w" = "whisper",		".w" = "whisper",
	  ":t" = "Syndicate",	"#t" = "Syndicate",		".t" = "Syndicate",
	  ":u" = "Supply",		"#u" = "Supply",		".u" = "Supply",

	  ":R" = "right ear",	"#R" = "right ear",		".R" = "right ear",
	  ":L" = "left ear",	"#L" = "left ear",		".L" = "left ear",
	  ":I" = "intercom",	"#I" = "intercom",		".I" = "intercom",
	  ":H" = "department",	"#H" = "department",	".H" = "department",
	  ":C" = "Command",		"#C" = "Command",		".C" = "Command",
	  ":N" = "Science",		"#N" = "Science",		".N" = "Science",
	  ":M" = "Medical",		"#M" = "Medical",		".M" = "Medical",
	  ":E" = "Engineering",	"#E" = "Engineering",	".E" = "Engineering",
	  ":S" = "Security",	"#S" = "Security",		".S" = "Security",
	  ":W" = "whisper",		"#W" = "whisper",		".W" = "whisper",
	  ":T" = "Syndicate",	"#T" = "Syndicate",		".T" = "Syndicate",
	  ":U" = "Supply",		"#U" = "Supply",		".U" = "Supply",

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":�" = "right ear",	"#�" = "right ear",		".�" = "right ear",
	  ":�" = "left ear",	"#�" = "left ear",		".�" = "left ear",
	  ":�" = "intercom",	"#�" = "intercom",		".�" = "intercom",
	  ":�" = "department",	"#�" = "department",	".�" = "department",
	  ":�" = "Command",		"#�" = "Command",		".�" = "Command",
	  ":�" = "Science",		"#�" = "Science",		".�" = "Science",
	  ":�" = "Medical",		"#�" = "Medical",		".�" = "Medical",
	  ":�" = "Engineering",	"#�" = "Engineering",	".�" = "Engineering",
	  ":�" = "Security",	"#�" = "Security",		".�" = "Security",
	  ":�" = "whisper",		"#�" = "whisper",		".�" = "whisper",
	  ":�" = "Syndicate",	"#�" = "Syndicate",		".�" = "Syndicate",
	  ":�" = "Supply",		"#�" = "Supply",		".�" = "Supply",
)

/mob/living/proc/binarycheck()

	if (istype(src, /mob/living/silicon/pai))
		return

	if (!ishuman(src))
		return

	var/mob/living/carbon/human/H = src
	if (H.l_ear || H.r_ear)
		var/obj/item/device/radio/headset/dongle
		if(istype(H.l_ear,/obj/item/device/radio/headset))
			dongle = H.l_ear
		else
			dongle = H.r_ear
		if(!istype(dongle)) return
		if(dongle.translate_binary) return 1

/mob/living/proc/do_message_checks(var/message = null)
	if(!message)
		return

	message = html_decode(message)

	if(findtext(lowertext(message), config.ic_filter_regex))
		src << 'sound/vam_ban.ogg'
		to_chat(src, "I SHOULDN'T HAVE SAID THAT!")
		sleep(10)
		log_admin("[src.client.ckey] just tried to say cringe")
		message_admins("[src.client.ckey] just tried to say cringe")
		if(!client.holder)
			//bans.Add(src.client.ckey)
			//client.game_remove_whitelist(reason = "Automatic ban: ([real_name]/[key] : [message])")
			qdel(src.client)
		return null

	message = replacetext(message, " i ", " I ") // for�a preto a usar letra em caps
	message = replacetext(message, " ive ", " I've ")// for�a preto a escrever corretamente
	message = replacetext(message, " u ", " you ")// for�a preto a usar you ao inv�s de u
	message = replacetext(message, " i ", " I ") // for�a preto a usar letra em caps
	message = replacetext(message, " ive ", " I've ")// for�a preto a escrever corretamente
	message = replacetext(message, " u ", " you ")// for�a preto a usar you ao inv�s de u
	message = replacetext(message, " today ", " tonight ")
	message = replacetext(message, "today ", "tonight ")
	message = replacetext(message, " today", " tonight")
	message = replacetext(message, "today", "tonight")
	message = replacetext(message, " morning ", " evening ")
	message = replacetext(message, "morning ", "evening ")
	message = replacetext(message, " morning", " evening")
	message = replacetext(message, "morning", "evening")
	message = replacetext(message, " day ", " night ")
	message = replacetext(message, "day ", "night ")
	message = replacetext(message, " day", " night")
	message = replacetext(message, "day", "night") // ISSO AQUI T� UM NOJO QUE NOJO
	message = replacetext(message, " babylon ", " ulysses ")
	message = replacetext(message, "babylon ", "ulysses ")
	message = replacetext(message, " babylon", " ulysses")
	message = replacetext(message, "babylon", "ulysses") // ISSO AQUI T� UM NOJO QUE NOJO
	message = sanitize(message)

	var/end_char = copytext(message, length(message), length(message) + 1)
	if(!(end_char in list(".", "?", "!", "-", "~")))
		message += "." // agora toda mensagem tem um . no final, fvck analfabetos!

	return html_encode(message)

/mob/living/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/italics=0, var/message_range = world.view, var/sound/speech_sound, var/sound_vol, var/was_exclaiming)

	if(!message)
		return

	log_say("[name]/[key] : [message]")
	message = do_message_checks(message)
	if(!message)
		return

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.province == "Salar" || H.h_style == "Forelock")
			message = salarTalk(message)

		if(H.province == "Wei-Ji Burrows" || H.voicetype == "gink")
			message = ginkTalk(message)

	var/turf/T = get_turf(src)

	//handle nonverbal and sign languages here
	if (speaking)
		if (speaking.flags & NONVERBAL)
			if (prob(30))
				src.custom_emote(1, "[pick(speaking.signlang_verb)].")

		if (speaking.flags & SIGNLANG)
			say_signlang(message, pick(speaking.signlang_verb), speaking)
			return 1

	var/list/listening = list()
	var/list/listening_obj = list()

	if(T)
		//make sure the air can transmit speech - speaker's side
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = 1
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

		var/list/hear = hear(message_range, T)
		var/list/hearturfs = list()

		for(var/I in hear)
			if(istype(I, /mob/))
				var/mob/M = I
				listening += M
				hearturfs += M.locs[1]
				for(var/obj/O in M.contents)
					listening_obj |= O
			else if(istype(I, /obj/))
				var/obj/O = I
				hearturfs += O.locs[1]
				listening_obj |= O


		for(var/mob/M in player_list)
			if(M.stat == DEAD && M.client && (M.client.prefs.toggles & CHAT_GHOSTEARS))
				listening |= M
				continue
			if((M.loc && M.locs[1]) in hearturfs)
				listening |= M

	// TODO: refactor this with animate_speech_bubble
	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
	if(was_exclaiming)
		speech_bubble = image('icons/mob/talk.dmi',src,"h2")
	spawn(30)
		qdel(speech_bubble)

	if(copytext_char(message,1,8) == "Poison*" || copytext_char(message,1,8) == "poison*")
		verb = "<span class='poison'>poisons</span>"
		message = copytext_char(message,8)
		message = "<span class='poison'>[message]</span>"

	if(copytext_char(message,1,6) == "Sing*" || copytext_char(message,1,6) == "sing*")
		verb = "<span class='sing'>sings</span>"
		message = copytext_char(message,6)
		message = "<span class='sing'>[message]</span>"

	var/list/temp_message = splittext(message, " ") //List each word in the message. We use this for determining speech words and stupid honk disease stuff.
	var/speechwords = min(round(temp_message.len), 5)

	var/ending = copytext_char(message, length(message))

	if(stuttering)
		if(ending != "!")
			message = stutter(message)
			verb = pick("stammers","stutters")
		else
			message = stutter(message)
			message = "<span class='saybold'>[message]</span>"
			verb = pick("stammers loudly","stutters loudly")

	if(ending == "!")
		playsound(src, "sound/speech/angery[gender][speechwords].ogg", 75)
	else
		playsound(src, "sound/speech/[gender][speechwords].ogg", 75)

	message = lisp(message)

	if(slurring)
		if(ending != "!")
			message = slur(message)
			verb = pick("stammers","stutters")		//Bydlocoded it here to avoid sanitization.
		else
			message = slur(message)
			message = "<span class='saybold'>[message]</span>"
			verb = pick("stutters loudly","stammers loudly","slurs loudly")

	if(!stuttering && !slurring && ending=="!") //This is an awful way of handling this I know. But at least it works. Unlike the other ways of handling it.
		message = "<span class='saybold'>[message]</span>"

	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M)
			to_target(M, speech_bubble)
			M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)
			if(M.client)
				speech_bubble_recipients += M.client

	for(var/obj/O in listening_obj)
		spawn(0)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking)

	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, animate_chat), message, speaking, italics, speech_bubble_recipients)

	last_said = message
	return 1

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name

/mob/living/proc/lisp(message) //Intensity = how hard will the dude be lisped
	if(ishuman(src))
		var/lisp = 0
		var/mob/living/carbon/human/H = src
		var/datum/organ/external/mouth/O = locate(/datum/organ/external/mouth) in H.organs
		if(O)
			if(!O.teeth_list.len || O.get_teeth() <= 0)
				lisp = 100 //No teeth = full lisp power
			else
				lisp = (1 - (O.get_teeth()/O.max_teeth)) * 100 //Less teeth = more lisp
		else
			lisp = 0 //No head = no lisp.
		message = prob(lisp) ? replacetext(message, "f", "ph") : message
		message = prob(lisp) ? replacetext(message, "t", "ph") : message
		message = prob(lisp) ? replacetext(message, "s", "sh") : message
		message = prob(lisp) ? replacetext(message, "th", "hh") : message
		message = prob(lisp) ? replacetext(message, "ck", "gh") : message
		message = prob(lisp) ? replacetext(message, "c", "gh") : message
		message = prob(lisp) ? replacetext(message, "k", "gh") : message
		return message
	return

/mob/living/proc/salarTalk(message)
	message = replacetextEx(message, "M", "М") //replacetextEx() is case-senstitive version of replacetext()
	message = replacetextEx(message, "N", "И")
	message = replacetextEx(message, "B", "Б")
	message = replacetextEx(message, "F", "Ф")
	message = replacetextEx(message, "D", "Д")
	message = replacetextEx(message, "Z", "З")
	message = replacetextEx(message, "Ch", "Ч")
	message = replacetextEx(message, "CH", "Ч")
	message = replacetextEx(message, "m", "м")
	message = replacetextEx(message, "n", "и")
	message = replacetextEx(message, "b", "б")
	message = replacetextEx(message, "f", "ф")
	message = replacetextEx(message, "d", "д")
	message = replacetextEx(message, "z", "з")
	message = replacetextEx(message, "ch", "ч")

	return message

/mob/living/proc/ginkTalk(message)
	message = replacetext(message, "l", "r")
	message = replacetext(message, "th", "s")
	message = replacetext(message, "a", "ya")
	message = replacetext(message, "d", "t")
	message = replacetext(message, "z", "j")

	return message