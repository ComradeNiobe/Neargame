var/global/total_runtimes = 0
var/global/total_runtimes_skipped = 0
var/global/regex/actual_error_file_line

#ifdef DEBUG
/world/Error(exception/E)
	if(!istype(E)) //Something threw an unusual exception
		log_world("\[[time_stamp()]] Uncaught exception: [E]")
		return ..()

	if (!global.actual_error_file_line)
		global.actual_error_file_line = regex("^%% (.*?),(.*?) %% ")

	var/static/list/error_last_seen = list()
	var/static/list/error_cooldown = list() /* Error_cooldown items will either be positive(cooldown time) or negative(silenced error)
												If negative, starts at -1, and goes down by 1 each time that error gets skipped*/

	if(!error_last_seen) // A runtime is occurring too early in start-up initialization
		return ..()

	global.total_runtimes++

	var/efile = E.file
	var/eline = E.line

	var/regex/actual_error_file_line = global.actual_error_file_line
	if(actual_error_file_line.Find(E.name))
		efile = actual_error_file_line.group[1]
		eline = actual_error_file_line.group[2]
		E.name = actual_error_file_line.Replace(E.name, "")

	var/erroruid = "[efile],[eline]"
	var/last_seen = error_last_seen[erroruid]
	var/cooldown = error_cooldown[erroruid] || 0

	if(last_seen == null)
		error_last_seen[erroruid] = world.time
		last_seen = world.time

	if(cooldown < 0)
		error_cooldown[erroruid]-- //Used to keep track of skip count for this error
		global.total_runtimes_skipped++
		return //Error is currently silenced, skip handling it
	//Handle cooldowns and silencing spammy errors
	var/silencing = FALSE

	// TODO: un-hardcode these once we get proper decls
	/// "The \"cooldown\" time for each occurrence of a unique error."
	var/configured_error_cooldown     = 600
	/// "How many occurrences before the next will silence them."
	var/configured_error_limit        = 50
	/// "How long a unique error will be silenced for."
	var/configured_error_silence_time = 6000

	//Each occurence of an unique error adds to its cooldown time...
	cooldown = max(0, cooldown - (world.time - last_seen)) + configured_error_cooldown
	// ... which is used to silence an error if it occurs too often, too fast
	if(cooldown > configured_error_cooldown * configured_error_limit)
		cooldown = -1
		silencing = TRUE
		spawn(0)
			usr = null
			sleep(configured_error_silence_time)
			var/skipcount = abs(error_cooldown[erroruid]) - 1
			error_cooldown[erroruid] = 0
			if(skipcount > 0)
				to_world_log("\[[time_stamp()]] Skipped [skipcount] runtimes in [erroruid].")
				if(istype(global.error_cache))
					global.error_cache.log_error(E, skip_count = skipcount)

	error_last_seen[erroruid] = world.time
	error_cooldown[erroruid] = cooldown

	var/list/usrinfo = null
	var/locinfo
	if(istype(usr))
		usrinfo = list("  usr: [log_info_line(usr)]")
		locinfo = log_info_line(usr.loc)
		if(locinfo)
			usrinfo += "  usr.loc: [locinfo]"
	// The proceeding mess will almost definitely break if error messages are ever changed
	var/list/splitlines = splittext(E.desc, "\n")
	var/list/desclines = list()
	if(LAZYLEN(splitlines) > ERROR_USEFUL_LEN) // If there aren't at least three lines, there's no info
		for(var/line in splitlines)
			if(LAZYLEN(line) < 3 || findtext(line, "source file:") || findtext(line, "usr.loc:"))
				continue
			if(findtext(line, "usr:"))
				if(usrinfo)
					desclines.Add(usrinfo)
					usrinfo = null
				continue // Our usr info is better, replace it

			if(copytext(line, 1, 3) != "  ")
				desclines += ("  " + line) // Pad any unpadded lines, so they look pretty
			else
				desclines += line
	if(usrinfo) //If this info isn't null, it hasn't been added yet
		desclines.Add(usrinfo)
	if(silencing)
		desclines += "  (This error will now be silenced for [configured_error_silence_time / 600] minutes)"
	if(istype(global.error_cache)) // istype() rather than nullcheck to avoid new ordering weirdness
		global.error_cache.log_error(E, desclines)

	error_write_log("\[[time_stamp()]] Runtime in [erroruid]: [E]")
	for(var/line in desclines)
		error_write_log(line)

/proc/error_write_log(msg)
	to_world_log(msg)
#endif