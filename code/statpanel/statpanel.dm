/* HOW TO USE:
add/remove verbs with add_verb(verb_path) & remove_verb(verb_path).
both support lists which are better to use if you're adding/removing multiple verbs at once.

to make verbs appear in the panel. You'll need to set the verb's caregory to one of ("craft","verb","emotes","gpc","cross","crown","fangs","dead","villain")
and set its desc to what you want the verb to appear as in the statpanel.
*/
/client
	var/scrollbarready = 0
	var/statpanel_loaded = FALSE
	var/list/stat_tabs = list()
	var/current_button
	var/list/html_verbs = list()

/typeverb
	var/name as text
	var/desc as text
	var/category as text
	var/hidden as num


/client/proc/add_verb(var/path)
	verbs |= path
	mob?.updateStatPanel()


/client/proc/remove_verb(var/path)
	verbs -= path
	mob?.updateStatPanel()

/mob/proc/add_verb(var/path)
	verbs |= path
	updateStatPanel()

/mob/proc/remove_verb(var/path)
	verbs -= path
	updateStatPanel()

/client/proc/init_panel()
	if(!statpanel_loaded)
		spawn(10)
			init_panel()
		return
	var/list/buttons = list("craft","verb","emotes","gpc","cross","crown","fangs","dead","villain")
	for(var/button in buttons)
		html_verbs.Remove(button)
	mob.updateStatPanel()
	newtext(mob.noteUpdate())
	current_button = "note"

/client/verb/debug_panel()
	init_panel()


/client/proc/loadDataPig()
	var/list/common_dirs = list(
		"code/statpanel/html/rsc/",
		"code/statpanel/html/html/"
	)
	for (var/path in common_dirs)
		var/list/filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) != "/") // Ignore directories.
				if(fexists(path + filename))
					src << browse_rsc(file(path + filename),filename)

	lobbyPig()

/client/verb/ready()
	set hidden = 1
	set name = "doneRsc"

	pigReady = 1
	init_panel()

/client/verb/unready()
	set hidden = 1
	set name = "notdoneRsc"

	pigReady = 0

/mob/new_player/proc/updateTimeToStart()
	if(!client)
		return
	if(!client.pigReady)
		return
//	client << output(list2params(list("#timestart", "[ticker?.pregame_timeleft]")), "outputwindow.browser:change")

/mob/new_player/Login()
	..()
	sleep(35)
	if(client)
		client.init_panel()
		updateTimeToStart()

/mob/Login()
	..()
	client.init_panel()

/mob/new_player/Life()
	..()
	updateTimeToStart()
//	updateStatPanel()


/mob/living/carbon/human/proc/updateSmalltext()
	if(!client)
		return

	var/list/text = list()
	var/fulltext = ""

	if(willpower_active)
		text += "Effort: [willpower_active]"
	if(job == "Pusher")
		if(mind)
			text += "TIME TO PAY: <span id='timepusher'>[mind.time_to_pay]</span>"
	if(job == "Sniffer")
		if(mind && Inquisitor_Type == "Month's Inquisitor")
			text += "Avowals of Guilt sent: (<span id='timepusher'>[mind.avowals_of_guilt_sent] / 6)</span>"
		text += "Investigation Points: <span id='timepusher'>[Inquisitor_Points]</span>"
	if(old_ways.god)
		if(old_ways.god == "Xom")
			text += "THOU ARE XOM'S TOY"

	if(src?.mind?.succubus)
		text += "Slaves : [src.mind.succubus.succubusSlaves.len]"

	for(var/T in text)
		fulltext += "[T]<br>"

	return fulltext

/proc/generateVerbHtml(var/verbname = "", var/displayname = "", var/number = 1)
	if(number % 2)
		return {"<a href='#' class='verb dim' onclick='window.location = "byond://winset?command=[verbname]"'>[displayname]</a>"}
	return {"<a href='#' class='verb' onclick='window.location = "byond://winset?command=[verbname]"'>[displayname]</a>"}

/proc/generateVerbList(var/list/verbs = list(), var/count = 1)
	var/html = ""
	var/counter = count
	for(var/list/L in verbs)
		counter++
		html += generateVerbHtml(L[1], L[2], counter) + "<BR>"

	return html

/client/proc/newtext(var/newcontent = "",var/id)
	if(!newcontent || newcontent == "")
		return
	src << output(list2params(list("[newcontent]")), "outputwindow.browser:InputMsg")

/client/proc/changebuttoncontent(var/idcontent = "", var/newcontent = "")
	return
	if(!statpanel_loaded)
		return
	src << output(list2params(list("[newcontent]", "[idcontent]")), "outputwindow.browser:changel")

/client/proc/addbutton(var/newcontent = "", var/selector = "")
	src << output(list2params(list("[newcontent]", "")), "outputwindow.browser:UpdateDynamicpanel")


/mob/proc/updateStatPanel()
	set waitfor = 0
	if(!client)
		return
	if(!client.statpanel_loaded)
		return

	var/list/buttons = list("options","chrome","verbs","emotes","fangs","dead","craft","gpc","cross","crown","villain","thanati")
	var/list/no_draw = list("options","chrome")
	var/list/new_default_buttons = default_buttons  + no_draw
	var/pixelDistancing = 46
	var/buttonTimes = 0
	var/list/stat_verbs = list()
	var/list/verb_list = list()
	verb_list += verbs
	verb_list += client.verbs
	for(var/v in verb_list)
		var/typeverb/new_verb = v
		if(!new_verb)
			continue
		if(!buttons.Find(new_verb.category))
			continue
		if(!istext(new_verb.category))
			continue
		if(new_verb.hidden)
			continue
		if(!stat_verbs[new_verb.category])
			stat_verbs[new_verb.category] = list()
		stat_verbs[new_verb.category] += list(list(new_verb.name, new_verb.desc))

	var/buttonHTML
	var/current_content = FALSE
	for(var/button in buttons)
		var/add_top = buttonTimes < 2 ? 0 : 2
		var/distance = {"margin-top: -[50 - add_top]px; margin-left: [pixelDistancing * buttonTimes]px;"}
		if(stat_verbs[button] || new_default_buttons.Find(button))
			if(!new_default_buttons.Find(button))
				client.html_verbs[button] = "<table><tr><td>" + generateVerbList(stat_verbs[button]) +"</td></tr></table>"
			else if(!client.html_verbs[button])
				client.html_verbs[button] = client.defaultButton(button)
			if(button == client.current_button)
				client.newtext(client.html_verbs[button])
				current_content = TRUE
			if(!no_draw.Find(button))
				if(!buttonTimes)
					buttonHTML += {"<a href="byond://?_src_=stat;buttondynamic=[button]">"} + {"<div style="background-image: url(\'[button].png\'); margin-right: 8px;" id="[button]" class="button"></div></a>"}
				else
					buttonHTML += {"<a href="byond://?_src_=stat;buttondynamic=[button]">"} + {"<div style="background-image: url(\'[button].png\'); [distance]" id="[button]" class="button"></div></a>"}
				buttonTimes++
	if(!current_content)
		client.current_button = "note"
		client.newtext(noteUpdate())
	client.addbutton(buttonHTML, "#dynamicpanel")


/client/proc/optionsUpdate()
	return "<tr><td>" + generateVerbList(list(list("OOC", "OOC"), list("Adminhelp", "Admin Help"), list(".togglefullscreen", "Toggle Fullscreen"), list("LobbyMusic", "Toggle Lobby Music"), list("Midis", "Toggle Midis"), list("FixChat", "Fix chat"), list("AmbiVolume", "Ambience Volume (0-255)"), list("MusicVolume", "Music Volume (0, 255)"))) + "</td></tr>"


/client/proc/chromeUpdate()
	return "<tr><td>" + generateVerbList(list(list("MigracaodeTodos", "(100) Allmigration"), list("LimparCromossomos", "(100) Wipe Chromosomes"), list("ChamarCharon", "(10) Launch Ulysses"), list("EscondercargoCustom", "(10) Hide Custom Job"), list("Escondercargo", "(2) Hide Job"), list("ReRolarSpecial", "(2) Reroll Special"), list("RetirarVice", "(1) Remove Vice"), list("silencePigs", "(2) Silence Pigs"), list("Trapokalipsis", "(15) Trapokalipsis"))) +  "</td></tr>"

/mob/proc/noteUpdate()
	return

/mob/living/carbon/human/noteUpdate()
	var/newHTML = ""
	newHTML += {"<span class='statstable'><table>\
<tr>\
<td><span class = 'ST smaller'>ST: [src.my_stats.get_stat(STAT_ST)]<BR>HT: [src.my_stats.get_stat(STAT_HT)]<BR>IN: [src.my_stats.get_stat(STAT_IN)]<BR>DX: [src.my_stats.get_stat(STAT_DX)]</span></th>\
<td><span class = 'ST smaller MINOR'>PR: [src.my_stats.get_stat(STAT_PR)]<BR>IM: [src.my_stats.get_stat(STAT_IM)]<BR>WP: [src.my_stats.get_stat(STAT_WP)]<BR>CR: [client.chromie_holder.chromie_number]</span></th>\
</tr>\
</table></span>"}

	newHTML += "<span class='smallstat'>[src.updateSmalltext()]</span>"

	return newHTML

/mob/proc/verbUpdate()
	return
/mob/new_player/noteUpdate()
	var/newHTML = ""
	var/lobby = ""
	if(ticker.current_state == GAME_STATE_PREGAME)
		lobby += "Time to Start: <span id='timestart'>[ticker.pregame_timeleft]</span><BR>"
		lobby += "Chromosomes: [client.chromie_holder.chromie_number]<BR>"
	if(ticker.current_state == GAME_STATE_PLAYING)
		lobby += "Next Migrant Wave: [ticker.migwave_timeleft]s<BR>"
		lobby += "Migrants: [ticker.migrants_inwave.len]/[ticker.migrant_req]<BR>"
		lobby += "Chromosomes: [client.chromie_holder.chromie_number]"
		for(var/client/C in ticker.migrants_inwave)
			var/religioncheck = ""
			var/gendercheck = "M"
			var/familycheck = ""

			if(C.prefs.religion != LEGAL_RELIGION)
				religioncheck = "!"
			if(C.prefs.family)
				familycheck = "*"
			if(C.prefs.gender != MALE)
				gendercheck = "F"

			lobby += "<BR><b>[C.prefs.real_name]</b> ([C.prefs.age] [gendercheck]) [familycheck][religioncheck]"
		lobby += "<BR><BR><i>! - Pagan </i> <i>* - Family</i>"
	newHTML += {"<span style='color:#600; font-weight:bold;'>[lobby]</span>"}
	return newHTML

/mob/dead/observer/noteUpdate()
	var/newHTML = ""
	var/note = ""
	note += "Chromosomes: [client.chromie_holder.chromie_number]<BR>"
	note += "Pain: [client.wraith_pain]<BR>"
	newHTML += {"<span style='color:#600; font-weight:bold;'>[note]</span>"}
	return newHTML


/client/proc/lobbyPig()
	src << browse('code/chatpanel/browserassets/html/chatpanel.html', "window=browseroutput")
	src << browse('code/statpanel/html/html/statpanel.html', "window=outputwindow.browser; size=411x330;")

client/proc/defaultButton(var/button)
	var/newHTML
	switch(button)
		if("verbs")
			newHTML = {"<table><tr><td>[generateVerbList(list(list("DisguiseVoice", "Disguise Voice"), list("Warn", "Warn"), list("Dance", "Dance"), list("vomit", "Try to Vomit"), list("Pee", "Pee"), list(".asktostop", "Stop")))]</td>"} + {"<td>[generateVerbList(list(list("Notes", "Memories"), list("Pray", "Pray"), list("Clean", "Clean"), list("Masturbate", "Masturbate"), list("Poo", "Poo")), 2)]</td></tr></table>"}
		if("emotes")
			newHTML =  {"<table><tr><td>[generateVerbList(list(list("Slap", "Slap"), list("Nod", "Nod"), list("Praise", "Cross"), list("Hug", "Hug"), list("Bow", "Bow"), list("Scream", "Scream"), list("Whimper", "Whimper"), list("Laugh", "Laugh"), list("Sigh", "Sigh"), list("Clearthroat", "Clear Throat"), list("Collapse", "Collapse")))]</td>"} + {"<td>[generateVerbList(list(list("Kiss", "Kiss"), list("LickLips", "Lick Lips"), list("Cough", "Cough"), list("SpitonSomeone", "Spit on Someone"), list("Yawn", "Yawn"), list("Wink", "Wink"), list("Grumble", "Grumble"), list("Cry", "Cry"), list("Hem", "Hem"), list("Smile", "Smile")), 2)]</td></tr></table>"}
		if("craft")
			newHTML = {"<table><tr><td>[generateVerbList(list(list("Furniture", "Furniture"), list("Cult", "Cult"), list("Items", "Items"), list("Leather", "Leather"), list("Mason", "Mason"), list("Tanning", "Tanning"), list("Signs", "Signs")))]</td><td>[generateVerbList(list(list("Weapons", "Weapons"), list("Other", "Other")), 2)]</td></tr></table>"}
		if("options")
			newHTML = optionsUpdate()
		if("chrome")
			newHTML = chromeUpdate()
	return newHTML

/client/New()
	..()
	loadDataPig()

	statpanel_loaded = TRUE
	if(!holder)
		return
	winset(src, "outputwindow.csay", "is-visible=true")

/mob/new_player/say(message)
	if(!client)
		return

	client.ooc(message)

/mob/living/carbon/human/New()
	..()

/mob/living/carbon/human/Login()
	..()
	updateStatPanel()