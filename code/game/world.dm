var/current_server
var/story_id = 0
var/server_language = "IZ"
var/april_fools = FALSE
var/currentmaprotation = "Default"
var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
var/rtlog_path


#define RECOMMENDED_VERSION 516
/world/New()
	//logs]
	set waitfor = FALSE
#ifdef NEARWEB_LIVE
	server_language = "IZ"
	current_server = "S1"
#endif
	TgsNew(minimum_required_security_level = TGS_SECURITY_TRUSTED)
	for(var/obj/effect/landmark/mapinfo/L in landmarks_list)
		if (L.name == "mapinfo" && L.mapname != "Mini War")
			currentmaprotation = L.mapname
	load_configuration()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	world_name()
	callHook("startup")
	load_admins()
	LoadBansjob()
	load_whitelist()
	if(!fexists("data/game_version.sav"))//This should only have to be run once.
		add_story_id()
	get_story_id()
	#ifdef NEARWEB_LIVE
	load_db_whitelist()
	load_db_bans()
	load_comrade_list()
	load_pigplus_list()
	load_villain_list()
	get_story_id()
	#endif
	SetupLogs()
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently
	jobban_loadbanfile()
	jobban_updatelegacybans()
	src.update_status()

	. = ..()

	populate_seed_list()
	src.update_status()
	world.log << "--†SERVER LANGUAGE†--"
	world.log << "[server_language] ON [src.port]"
	// Init the debugger first so we can debug Master
	init_debugger()
	processScheduler = new
	thanatiGlobal = new
	master_controller = new /datum/controller/game_controller()
	Master.Initialize(10, FALSE)
	spawn(1)
		processScheduler.deferSetupFor(/datum/controller/process/ticker)
		processScheduler.setup()
		master_controller.setup()
		thanatiGlobal.setup()
	TgsInitializationComplete()

	spawn(3000)		//so we aren't adding to the round-start lag
		if(config.ToRban)
			ToRban_autoupdate()

#undef RECOMMENDED_VERSION

	return

/world/Topic(T, addr, master, key)
	TGS_TOPIC
	diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if (T == "status")
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config ? abandon_allowed : 0
		s["enter"] = enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["players"] = list()
		var/n = 0
		var/admins = 0

		for(var/client/C in clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue	//so stealthmins aren't revealed by the hub
				admins++
			s["player[n]"] = C.key
			n++
		s["players"] = n

		s["admins"] = admins

		return list2params(s)


/world/Reboot(reason)
	TgsTargetedChatBroadcast("<@&1075561850374209546> The round has restarted! - <byond://[world.address]:[world.port]>", FALSE)
	story_holder.story_number++
	add_story_id()
	for(var/client/C in clients)
		C << link("byond://[world.address]:[world.port]")
	auxcleanup()
	TgsReboot()
	TgsEndProcess()
	..(reason)

/world/Del()
	processScheduler.stop()
	Master.Shutdown()
	auxcleanup()
	. = ..()

/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			diary << "Saved mode is '[master_mode]'"

/world/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	join_motd = sanitize(file2text("config/motd.txt"))

/world/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.loadsql("config/dbconfig.txt")
	// apply some settings from config..
	abandon_allowed = config.respawn

/world/proc/SetupLogs()
	global.log_directory = "data/logs/[time2text(world.realtime, "YYYY/MM/DD")]/round-"
	if(story_id)
		global.log_directory += "[story_id]"
	else
		global.log_directory += "[replacetext(time_stamp(), ":", ".")]"

	global.world_qdel_log = file("[global.log_directory]/qdel.log")
	to_file(global.world_qdel_log, "\n\nStarting up round ID [story_id]. [time_stamp()]\n---------------------")

	global.world_href_log = file("[global.log_directory]/href.log") // Used for config-optional total href logging
	diary = file("[global.log_directory]/main.log") // This is the primary log, containing attack, admin, and game logs.
	to_file(diary, "[log_end]\n[log_end]\nStarting up. (ID: [story_id]) [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]")

	//if(get_config_value(/decl/config/toggle/log_runtime))
	var/runtime_log = file("[global.log_directory]/runtime.log")
	to_file(runtime_log, "Game [story_id] starting up at [time2text(world.timeofday, "hh:mm.ss")]")
	log = runtime_log // runtimes and some other output is logged directly to world.log, which is redirected here.

/world/proc/update_status()
	var/s = ""
	s += "<b>Neargame†: A Machine For Pigs</b> &#8212; "
	s += " ("
	s += "<a href=\"https://discord.gg/wYHkRTYc5J\">" //Change this to wherever you want the hub to link to.
	s += "Discord"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	s += "<br>Immersive Dark Science Fantasy Roleplay"

	var/list/features = list()

	var/n = length(global.clients)

	if (n > 1)
		features += "~[n] addicts"
	else if (n > 0)
		features += "~[n] addict"

	features += "<b>+\[18 Only\]</b>"

	if (features)
		s += "<br>[list2text(features, ", ")]"
	s += "<br><b>Map of the Week:</b> [currentmaprotation]"
	s += "<br><b>Hosted by:</b> [config.hostedby]"
	if(!private_party)
		s += "<br><b>PUBLIC PARTY</b>"
	if(master_mode == "holywar")
		s += "<br><b>HOLY WAR!</b>"
	if(master_mode == "miniwar")
		s += "<br><b>MINIWAR!</b>"
	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0

#ifdef NEARWEB_LIVE
/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."
	return 1
#endif

/proc/setup_database_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = sqllogin
	var/pass = sqlpass
	var/db = sqldb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()
	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0
	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1

#undef FAILED_DB_CONNECTION_CUTOFF



//runtime logging.

/proc/loc_name(atom/A)
	if(!istype(A))
		return "(INVALID LOCATION)"

	var/turf/T = A
	if (!istype(T))
		T = get_turf(A)

	if(istype(T))
		return "([T.name] ([T.x],[T.y],[T.z]))"
	else if(A.loc)
		return "(UNKNOWN (?, ?, ?))"

/world/proc/init_debugger()
	var/dll = GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (dll)
		call_ext(dll, "auxtools_init")()
		enable_debugging()

/world/proc/auxcleanup()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call_ext(debug_server, "auxtools_shutdown")()
