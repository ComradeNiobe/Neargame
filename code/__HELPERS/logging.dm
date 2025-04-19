var/runtime_diary = null
//print an error message to world.log
/proc/error(msg)
	world.log << "## ERROR: [msg]"

//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg]"

//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg]"

/proc/log_admin(text)
	admin_log.Add(text)
	if (config.log_admin)
		diary << "\[[time_stamp()]]ADMIN: [text]"


/proc/log_debug(text)
	if (config.log_debug)
		diary << "\[[time_stamp()]]DEBUG: [text]"

	for(var/client/C in admins)
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			C << "DEBUG: [text]"


/proc/log_game(text)
	if (config.log_game)
		diary << "\[[time_stamp()]]GAME: [text]"

/proc/log_vote(text)
	if (config.log_vote)
		diary << "\[[time_stamp()]]VOTE: [text]"

/proc/log_access(text)
	if (config.log_access)
		diary << "\[[time_stamp()]]ACCESS: [text]"

/proc/log_say(text)
	if (config.log_say)
		diary << "\[[time_stamp()]]SAY: [text]"

/proc/log_ooc(text)
	if (config.log_ooc)
		diary << "\[[time_stamp()]]OOC: [text]"

/proc/log_whisper(text)
	if (config.log_whisper)
		diary << "\[[time_stamp()]]WHISPER: [text]"

/proc/log_emote(text)
	return

/proc/log_attack(text)
	if (config.log_attack)
		diary << "\[[time_stamp()]]ATTACK: [text]" //Seperate attack logs? Why?

/proc/log_adminsay(text)
	if (config.log_adminchat)
		diary << "\[[time_stamp()]]ADMINSAY: [text]"

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		diary << "\[[time_stamp()]]ADMINWARN: [text]"

/proc/log_pda(text)
	if (config.log_pda)
		diary << "\[[time_stamp()]]PDA: [text]"

/proc/log_misc(text)
	game_log("MISC", text)

//more or less a logging utility
/proc/key_name(var/whom, var/include_link = null, var/include_name = 1, var/highlight_special_characters = 1)
	var/mob/M
	var/client/C
	var/key

	if(!whom)	return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
	else if(istype(whom, /datum/mind))
		var/datum/mind/D = whom
		key = D.key
		M = D.current
		if(D.current)
			C = D.current.client
	else if(istype(whom, /datum))
		var/datum/D = whom
		return "*invalid:[D.type]*"
	else
		return "*invalid*"

	. = ""

	if(key)
		if(include_link && C)
			. += "<a href='?priv_msg=\ref[C]'>"

		. += key

		if(include_link)
			if(C)	. += "</a>"
			else	. += " (DC)"
	else
		. += "*no key*"

	if(include_name && M)
		var/name

		if(M.real_name)
			name = M.real_name
		else if(M.name)
			name = M.name


		if(include_link && is_special_character(M) && highlight_special_characters)
			. += "/(<font color='#FFA500'>[name]</font>)" //Orange
		else
			. += "/([name])"

	return .

/proc/key_name_admin(var/whom, var/include_name = 1)
	return key_name(whom, 1, include_name)

// Helper procs for building detailed log lines
/datum/proc/get_log_info_line()
	return "[src] ([type]) ([any2ref(src)])"

/area/get_log_info_line()
	return "[..()] ([isnum(z) ? "[x],[y],[z]" : "0,0,0"])"

/turf/get_log_info_line()
	//var/obj/effect/overmap/visitable/O = global.overmap_sectors[num2text(z)]
	//if(istype(O))
	//	return "[..()] ([x],[y],[z] - [O.name]) ([loc ? loc.type : "NULL"])"
	//else
	return "[..()] ([x],[y],[z]) ([loc ? loc.type : "NULL"])"

/atom/movable/get_log_info_line()
	var/turf/t = get_turf(src)
	if(t)
		//var/obj/effect/overmap/visitable/O = global.overmap_sectors[num2text(t.z)]
		//if(istype(O))
		//	return "[..()] ([t]) ([t.x],[t.y],[t.z] - [O.name]) ([t.type])"
		return "[..()] ([t]) ([t.x],[t.y],[t.z]) ([t.type])"
	return "[..()] ([loc?.name || "NULL" ]) (NULL) ([loc?.type || "NULL"])"

/mob/get_log_info_line()
	return ckey ? "[..()] ([ckey])" : ..()

/proc/log_info_line(var/datum/d)
	if(isnull(d))
		return "*null*"
	if(islist(d))
		var/list/out = list()
		var/list/dlist = d
		for(var/entry in dlist)
			// Indexing on numbers just gives us the same number again in the best case and causes an index out of bounds runtime in the worst
			var/value = isnum(entry) ? null : dlist[entry]
			out += "[log_info_line(entry)][" - [log_info_line(value)]"]"
		return "\[[jointext(out, ", ")]\]" // We format the string ourselves, rather than use json_encode(), because it becomes difficult to read recursively escaped "
	if(!istype(d))
		return json_encode(d)
	return d.get_log_info_line()

/proc/is_special_character(var/character) // returns 1 for special characters and 2 for heroes of gamemode
	if(!ticker || !ticker.mode)
		return
	var/datum/mind/M
	if (ismob(character))
		var/mob/C = character
		M = C.mind
	else if(istype(character, /datum/mind))
		M = character

	if(M?.special_role)
		return TRUE

	if(isrobot(character))
		var/mob/living/silicon/robot/R = character
		if(R.emagged)
			return TRUE

	return

// call to generate a stack trace and print to runtime logs
/proc/get_stack_trace(msg, file, line)
	CRASH("%% [file],[line] %% [msg]")