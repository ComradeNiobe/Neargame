
var/global/normal_ooc_colour = "#666699"
/obj/pigforrandy
	icon = 'icons/chat_for_randy.dmi'
	icon_state = "pigforrandy"

/client/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC"

	if(!mob)	return
	if(IsGuestKey(key))
		//src << "Guests may not use OOC."
		return

	msg = sanitize(msg)
	if(!msg)	return


	if(!holder)
		if(silenceofpigs)
			if(!access_comrade.Find(src.ckey) && !access_villain.Find(src.ckey))
				to_chat(src, "<span class='hitbold'>Silence, pig!</span>")
				return
		if(!dooc_allowed && (mob.stat == DEAD))
			to_chat(src,"<span class='highlighttext'>OOC for dead mobs has been turned off.</span>")
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src,"<span class='highlighttext'>You cannot use OOC (muted).</span>")
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src,"<span class='highlighttext'><B>Stop right there criminal scum!</B></span>")
			src << 'sound/sound_ahelp_br.ogg'
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return
		if(findtext(msg, "OOC:"))
			to_chat(src, "<span class='highlighttext'><B>\"OOC:\" is not required.</B></span>")
			src << 'sound/sound_ahelp_br.ogg'
			log_admin("[key_name(src)] has attempted to be carente in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to be carente in OOC: [msg]")
			return

	log_ooc("[mob.name]/[key] : [msg]")

	var/display_colour = normal_ooc_colour
	if(!holder)
		if(ckey(src.key) in donation_mycolor)
			display_colour = src.prefs.ooccolor
		else
			display_colour = normal_ooc_colour
	else
		if(ckey(src.key) in donation_mycolor)
			display_colour = src.prefs.ooccolor
		else
			display_colour = normal_ooc_colour
	msg = emoji_parse(msg)

	if(findtext(lowertext(msg), config.ooc_filter_regex))
		src << 'sound/vam_ban.ogg'
		to_chat(src, "That was pretty cringe!")
		log_admin("[key] just tried to say OOC cringe")
		message_admins("[key] just tried to OOC say cringe")
		//if(!holder)
		//	bans.Add(key)
		//	game_remove_whitelist(reason = "Automatic ban: ([key] : [msg])")
		//	qdel(src)
		return

	if(ticker.current_state == GAME_STATE_PREGAME || ticker.current_state == GAME_STATE_FINISHED || ticker.current_state == GAME_STATE_SETTING_UP)
		for(var/client/C in clients)
			if(C.prefs.toggles & CHAT_OOC)
				var/display_name = "[src.key]"
				to_chat(C, "<span class='oocnew'><font color='[display_colour]'><b>OOC: [display_name]: [msg]</b></font></span>")

	if(ticker.current_state == GAME_STATE_PLAYING)
		for(var/mob/new_player/C in player_list)
			if(C.client.prefs.toggles & CHAT_OOC)
				var/display_name = "[src.key]"
				to_chat(C, "<span class='oocnew'><font color='[display_colour]'><b>LOBBY: [display_name]: [msg]</b></font></span>")

/client/proc/set_ooc(newColor as color)
	set name = "Set Player OOC Colour"
	set desc = "Set to yellow for eye burning goodness."
	set category = "Fun"
	normal_ooc_colour = newColor

/client/verb/fix_chat()
	set name = "FixChat"
	set category = "OOC"
	if (!chatOutput || !istype(chatOutput))
		var/action = alert(src, "Invalid Chat Output data found!\nRecreate data?", "Wot?", "Recreate Chat Output data", "Cancel")
		if (action != "Recreate Chat Output data")
			return
		chatOutput = new /datum/chatOutput(src)
		chatOutput.start()
		action = alert(src, "Goon chat reloading, wait a bit and tell me if it's fixed", "", "Fixed", "Nope")
		if (action == "Fixed")
			log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by re-creating the chatOutput datum")
		else
			chatOutput.load()
			action = alert(src, "How about now? (give it a moment (it may also try to load twice))", "", "Yes", "No")
			if (action == "Yes")
				log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by re-creating the chatOutput datum and forcing a load()")
			else
				action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
				if (action == "Switch to old chat")
					winset(src, "output", "is-visible=true;is-disabled=false")
					winset(src, "browseroutput", "is-visible=false")
				log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window after recreating the chatOutput and forcing a load()")

	else if (chatOutput.loaded)
		var/action = alert(src, "ChatOutput seems to be loaded\nDo you want me to force a reload, wiping the chat log or just refresh the chat window because it broke/went away?", "Hmmm", "Force Reload", "Refresh", "Cancel")
		switch (action)
			if ("Force Reload")
				chatOutput.loaded = FALSE
				chatOutput.start() //this is likely to fail since it asks , but we should try it anyways so we know.
				action = alert(src, "Goon chat reloading, wait a bit and tell me if it's fixed", "", "Fixed", "Nope")
				if (action == "Fixed")
					log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a start()")
				else
					chatOutput.load()
					action = alert(src, "How about now? (give it a moment (it may also try to load twice))", "", "Yes", "No")
					if (action == "Yes")
						log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a load()")
					else
						action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
						if (action == "Switch to old chat")
							winset(src, "output", "is-visible=true;is-disabled=false")
							winset(src, "browseroutput", "is-visible=false")
						log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window forcing a start() and forcing a load()")

			if ("Refresh")
				chatOutput.showChat()
				action = alert(src, "Goon chat refreshing, wait a bit and tell me if it's fixed", "", "Fixed", "Nope, force a reload")
				if (action == "Fixed")
					log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a show()")
				else
					chatOutput.loaded = FALSE
					chatOutput.load()
					action = alert(src, "How about now? (give it a moment)", "", "Yes", "No")
					if (action == "Yes")
						log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a load()")
					else
						action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
						if (action == "Switch to old chat")
							winset(src, "output", "is-visible=true;is-disabled=false")
							winset(src, "browseroutput", "is-visible=false")
						log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window forcing a show() and forcing a load()")
		return

	else
		chatOutput.start()
		var/action = alert(src, "Manually loading Chat, wait a bit and tell me if it's fixed", "", "Fixed", "Nope")
		if (action == "Fixed")
			log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by manually calling start()")
		else
			chatOutput.load()
			alert(src, "How about now? (give it a moment (it may also try to load twice))", "", "Yes", "No")
			if (action == "Yes")
				log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by manually calling start() and forcing a load()")
			else
				action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
				if (action == "Switch to old chat")
					winset(src, "output", list2params(list("on-show" = "", "is-disabled" = "false", "is-visible" = "true")))
					winset(src, "browseroutput", "is-disabled=true;is-visible=false")
				log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window after manually calling start() and forcing a load()")
