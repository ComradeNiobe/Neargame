var/roundsinvite = 1

/client/verb/prompt_command()
	set name = "Command Prompt"
	set category = "OOC"
	var/list/inputlist = list(
		"showlads",
		"togglenat",
		"setspouse",
		"invite",
		"togglefuta",
		"mycolor",
		"retro",
		"add_donator",
		"ban",
		"unban",
		"add_role",
		"absencelabiosdeseda",
		"superretro",
		"remove_role",
		"musica",
		"tremer",
		"rsctoggle",
		"fix64",
		"togglesquire",
		"togglesize",
		"setfontsize"
	)
	var/list/debug = list(
		"showgamemode",
		"setgamemode",
		"changeskill",
		"showaspect"
	)
	var/chosenoption = sanitize_safe(input("Input a command.","[src.key]"))
	if(!chosenoption)
		return
	if(inputlist.Find(chosenoption))
		to_chat(src, "Command Used : <b>[chosenoption]</b>")
		switch(chosenoption)
			if("showlads")
				src.showlads()
				return
			if("setspouse")
				src.set_spouse()
				return
			if("invite")
				if(!usr.client.holder && !(usr.ckey in access_comrade))
					to_chat(usr, "<span class='highlighttext'>You are not allowed to do that.</span>")
					return
				invite_ckey()

			if("superretro")
				if(src.prefs.UI_type == "Luna")
					to_chat(src, "Retro UI enabled, Remember to Reconnect.")
					src.prefs.UI_type = "Retro"
					src.prefs.UI_style = "Luna"
					src.prefs.save_preferences()
					if(mob.hud_used)	qdel(mob.hud_used)		//remove the hud objects
					mob.hud_used = new /datum/hud(mob)
					mob.add_filter_effects()
					mob.updateStatPanel()
					mob?.hud_used?.add_inventory_overlay()
					mob?.Do_OLDHUD()

			if("retro")
				if(src.prefs.UI_type == "Luna")
					to_chat(src, "Retro UI enabled, Remember to Reconnect.")
					src.prefs.UI_type = "Retro"
					src.prefs.UI_style = "Luna"
					src.prefs.save_preferences()
					if(mob.hud_used)	qdel(mob.hud_used)		//remove the hud objects
					mob.hud_used = new /datum/hud(mob)
					mob.add_filter_effects()
					mob.updateStatPanel()
					mob?.hud_used?.add_inventory_overlay()
				else
					to_chat(src, "Retro UI disabled, Remember to Reconnect.")
					src.prefs.UI_type = "Luna"
					src.prefs.UI_style = "Luna"
					src.prefs.save_preferences()
					if(mob.hud_used)	qdel(mob.hud_used)		//remove the hud objects
					mob.hud_used = new /datum/hud(mob)
					mob.add_filter_effects()
					mob.updateStatPanel()
					mob?.hud_used?.add_inventory_overlay()
					mob?.hud_used?.persistant_inventory_update()
					mob?.hud_used?.hidden_inventory_update()
				return
			if("mycolor")
				src.colorooc()
				return
			if("togglefuta")
				if(src.mob.type != /mob/new_player)
					to_chat(usr, "<span class='combatbold'>FAIL!</span><span class='combat'> It can only be changed in the lobby!</span>")
					return

				var/input = input(usr, "Are you sure you want to disable / enable futa?", "Nearweb") in list("Yes", "No")
				switch(input)
					if("No")
						return
					if("Yes")
						if(src.prefs.togglefuta)
							to_chat(usr, "<span class='highlighttext'>You disabled futa.</span>")
							src.prefs.togglefuta = FALSE
							prefs.save_preferences()
							prefs.savefile_update()
						else
							to_chat(usr, "<span class='highlighttext'>You enabled futa.</span>")
							src.prefs.togglefuta = TRUE
							prefs.save_preferences()
							prefs.savefile_update()
						return
				return
			if("togglesize")
				if(src.mob.type != /mob/new_player)
					to_chat(usr, "<span class='combatbold'>FAIL!</span><span class='combat'> It can only be changed in the lobby!</span>")
					return

				var/input = input(usr, "Are you sure you want to disable / enable 30cm?", "Nearweb") in list("Yes", "No")
				switch(input)
					if("No")
						return
					if("Yes")
						if(src.prefs.togglesize)
							to_chat(usr, "<span class='highlighttext'>You disabled 30cm.</span>")
							src.prefs.togglesize = FALSE
							prefs.save_preferences()
							prefs.savefile_update()
						else
							to_chat(usr, "<span class='highlighttext'>You enabled 30cm.</span>")
							src.prefs.togglesize = TRUE
							prefs.save_preferences()
							prefs.savefile_update()
						return
				return

			if("togglenat")
				var/input = input(usr, "Are you sure you want to hide/show your country?", "Nearweb") in list("Yes", "No")
				switch(input)
					if("No")
						return
					if("Yes")
						if(src.prefs.toggle_nat == TRUE)
							to_chat(usr, "<span class='highlighttext'>You've hidden your country.</span>")
							src.prefs.toggle_nat = FALSE
							prefs.save_preferences()
							prefs.savefile_update()
						else
							to_chat(usr, "<span class='highlighttext'>You've shown your country.</span>")
							src.prefs.toggle_nat = TRUE
							prefs.save_preferences()
							prefs.savefile_update()
						return
				return
			if("ban")
				if(!usr.client.holder && !(usr.ckey in puppeteers))
					to_chat(usr, "<span class='highlighttext'>You are not allowed to do that.</span>")
					return
				remove_whitelist()
			if("unban")
				if(!usr.client.holder && !(usr.ckey in puppeteers))
					to_chat(usr, "<span class='highlighttext'>You are not allowed to do that.</span>")
					return
				remove_ban()
			if("add_role")
				if(!usr.client.holder && !(usr.ckey in puppeteers))
					to_chat(usr, "<span class='highlighttext'>You are not allowed to do that.</span>")
					return
				var/input = input(usr, "Which role do you want to add an user to?", "Nearweb") in list("Villain", "Comrade","Pig+")
				switch(input)
					if("Comrade")
						add_comrade()
					if("Villain")
						add_villain()
					if("Pig+")
						add_pigplus()
			if("remove_role")
				if(!usr.client.holder && !(usr.ckey in puppeteers))
					to_chat(usr, "<span class='highlighttext'>You are not allowed to do that.</span>")
					return
				var/input = input(usr, "Which role do you want to remove an user from?", "Nearweb") in list("Villain", "Comrade","Pig+")
				switch(input)
					if("Comrade")
						remove_comrade()
					if("Villain")
						remove_villain()
					if("Pig+")
						remove_pigplus()
			if("musica")
				if((ishuman(src.mob)) && (usr.ckey in tier_marduk))
					var/mob/living/carbon/human/H = mob

					if(H.combat_musicoverlay)
						H.combat_musicoverlay = null
						to_chat(H, "<span class='highlighttext'><b>MÚSICA CUSTOM DESATIVADA</b></span>")
						return

					var/sound/S = input("Your music file") as sound|null

					if(S)
						H.combat_musicoverlay = S
						to_chat(H, "<span class='highlighttext'><b>MÚSICA CUSTOM ATIVADA</b></span>")
					return
			if("tremer")
				if((ishuman(src.mob)) && (usr.ckey in tier_marduk))
					var/mob/living/carbon/human/H = mob

					if(H.fakeDREAMER)
						H.fakeDREAMER = 0
						return
					H.fakeDREAMER = 1
					return
			if("rsctoggle")
				if(src.prefs.rsc_fix == 1)
					src.prefs.rsc_fix = 0
				else
					src.prefs.rsc_fix = 1
				src.prefs.save_preferences()
				if(src.prefs.rsc_fix)
					to_chat(src, "Resources will now download before you connect, Remember to Reconnect.")
				else
					to_chat(src, "Resources will now download as they are needed, Remember to Reconnect.")
			if("fix64")
				if(src.prefs.zoom_level == 2)
					src.prefs.zoom_level = 0
				else
					src.prefs.rsc_fix = 2
				src.prefs.save_preferences()
				if(src.prefs.zoom_level)
					to_chat(src, "You have enabled 2x Zoom. Remember to Reconnect.")
				else
					to_chat(src, "You have enabled stretch to fit. Remember to Reconnect.")
			if("togglesquire")
				var/input = input(usr, "Are you sure you want to disable / enable adult squire?", "Nearweb") in list("Yes", "No")
				switch(input)
					if("No")
						return
					if("Yes")
						if(src.prefs.toggle_squire == TRUE)
							to_chat(usr, "<span class='highlighttext'>You disabled adult squire.</span>")
							src.prefs.toggle_squire = FALSE
							prefs.save_preferences()
							prefs.savefile_update()
						else
							to_chat(usr, "<span class='highlighttext'>You enabled adult squirea.</span>")
							src.prefs.toggle_squire = TRUE
							prefs.save_preferences()
							prefs.savefile_update()
						return
			if("setfontsize")
				var/input = input(usr, "CURRENT: [src.prefs.font_size / 10] \n Set your font size.", "Nearweb") as num
				to_chat(src, "Font size is now: [input]")
				input = round(input *= 10,10)
				src.prefs.font_size = input
				chat_resize()
				prefs.save_preferences()
				prefs.savefile_update()
		return
	else if(debug.Find(chosenoption) && (src.ckey in puppeteers))
		to_chat(src, "Command Used : <b>[chosenoption]</b>")
		switch(chosenoption)
			if("showgamemode")
				to_chat(usr, "Current Gamemode: <b>[ticker.mode.config_tag]</b>")
				return
			if("setgamemode")
				var/input = input(usr, "Wich one?", "Farbebra") in list("kingwill", "changeling", "revolution", "dreamer", "succubus", "inspector", "siege", "quietday", "alien", "None", "(CANCEL)")
				if(input == "(CANCEL)")
					return
				log_game("[src.ckey] forces a gamemode called: [input]")
				if(input == "None")
					ticker.forcemod = null
					to_chat(usr, "Forced Gamemode: <b>None</b>")
				else
					ticker.forcemod = input
					to_chat(usr, "Forced Gamemode: <b>[ticker?.forcemod]</b>")
				return
			if("changeskill")
				if(istype(mob, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = mob
					if(!length(H.my_skills.skills_holder))
						return
					var/list/skills_list = list()
					for(var/skill_id in 1 to H.my_skills.skills_holder.len)
						var/datum/skill/S = get_skill_data(skill_id, H.my_skills)
						if(!S)
							continue
						skills_list[S.name] = skill_id
					if(!length(skills_list))
						to_chat(src, "<span class='combat'>I'm dumb...</span>")
						return
					var/name_skill = input(src, "Which skill i want to change?", "Thinking") in skills_list
					if(!name_skill)
						return
					var/num_skill = input(src, "Change to?", "Thinking") as num
					if(num_skill > 20)
						to_chat(src, "Too high!")
						return
					else if(num_skill < 0)
						to_chat(src, "Too low!")
						return
					log_game("[src.ckey]/[H.real_name] changes his skill([name_skill]) to [num_skill]")
					H.my_skills.change_skill(skills_list[name_skill], round(num_skill))
					to_chat(src, "Skill Changed!")
					return
			if("showaspect")
				to_chat(src, "mode: [ticker?.eof?.name]")
				return
	else
		to_chat(src, "<span class='highlighttext'>Fail!: <span class='feedback'>[chosenoption]</span> <span class='highlighttext'>isn't a valid command.</span>")
		return

/client/verb/ambi_volume()
	set name = "AmbiVolume"
	set category = "OOC"
	if(!prefs)
		return
	var/input = input(usr, "CURRENT: [src?.prefs?.ambi_volume] \n Set your Ambience Volume (0/255 Maximum)", "Nearweb") as num
	if(input > 255 || input < 0)
		return
	to_chat(usr, "<spanclass='jogtowalk'>New Ambience volume is now [input]%</span>")
	prefs?.ambi_volume = input
	prefs?.save_preferences()
	prefs?.savefile_update()

/client/verb/music_volume()
	set name = "MusicVolume"
	set category = "OOC"
	if(!prefs)
		return
	var/input = input(usr, "CURRENT: [src?.prefs?.music_volume] \n Set your Music Volume (0/255 Maximum)", "Nearweb") as num
	if(input > 255 || input < 0)
		return
	to_chat(usr, "<spanclass='jogtowalk'>New Music volume is now [input]%</span>")
	prefs?.music_volume = input
	prefs?.save_preferences()
	prefs?.savefile_update()