var/global/list/admin_ranks = list()								//list of all ranks with associated rights

//load our rank - > rights associations
/proc/load_admin_ranks()
	global.admin_ranks.Cut()

	var/previous_rights = 0

	//load text from file
	var/list/Lines = file2list("config/admin_ranks.txt")

	//process each line seperately
	for(var/line in Lines)
		if(!length(line))				continue
		if(copytext(line,1,2) == "#")	continue

		var/list/List = text2list(line,"+")
		if(!List.len)					continue

		var/rank = ckeyEx(List[1])
		switch(rank)
			if(null,"")		continue
			if("Removed")	continue				//Reserved

		var/rights = 0
		for(var/i=2, i<=List.len, i++)
			switch(ckey(List[i]))
				if("@","prev")					rights |= previous_rights
				if("buildmode","build")			rights |= R_BUILDMODE
				if("admin")						rights |= R_ADMIN
				if("ban")						rights |= R_BAN
				if("fun")						rights |= R_FUN
				if("server")					rights |= R_SERVER
				if("debug")						rights |= R_DEBUG
				if("permissions","rights")		rights |= R_PERMISSIONS
				if("possess")					rights |= R_POSSESS
				if("stealth")					rights |= R_STEALTH
				if("rejuv","rejuvinate")		rights |= R_REJUVINATE
				if("varedit")					rights |= R_VAREDIT
				if("everything","host","all")	rights |= R_HOST
				if("sound","sounds")			rights |= R_SOUNDS
				if("spawn","create")			rights |= R_SPAWN
				if("mod")						rights |= R_MOD

		global.admin_ranks[rank] = rights
		previous_rights = rights

	#ifdef TESTING
	var/msg = "Permission Sets Built:\n"
	for(var/rank in global.admin_ranks)
		msg += "\t[rank] - [admin_ranks[rank]]\n"
	testing(msg)
	#endif


/hook/startup/proc/loadAdmins()
	load_admins()
	return 1

/proc/load_admins()
	//clear the datums references
	global.admin_datums.Cut()
	for(var/client/C in global.admins)
		C.remove_admin_verbs()
		C.holder = null
	global.admins.Cut()

	// Flush profiler access.
	for (var/admin in world.GetConfig("admin"))
		world.SetConfig("APP/admin", admin, null)

	if(config.admin_legacy_system)
		load_admin_ranks()

		//load json from file
		var/list/json = rustg_read_toml_file("config/admins.toml")
		if(!json)
			PRINT_STACK_TRACE("Failed to load admins.toml!")
			return

		for(var/key in json)
			var/ckey = ckey(key)
			if(!ckey)
				continue

			var/rank = ckeyEx(LAZYACCESS(json, key))

			//load permissions associated with this rank
			var/rights = global.admin_ranks[rank]

			//create the admin datum and store it for later use
			var/datum/admins/D = new /datum/admins(rank, rights, ckey)

			//find the client for a ckey if they are connected and associate them with the new admin datum
			D.associate(global.directory[ckey])

	else
		//The current admin system uses SQL

		establish_db_connection()
		if(!dbcon.IsConnected())
			error("Failed to connect to database in load_admins(). Reverting to legacy system.")
			log_misc("Failed to connect to database in load_admins(). Reverting to legacy system.")
			config.admin_legacy_system = TRUE
			load_admins()
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT `ckey`, `rank`, `flags` FROM `erro_admin`")
		query.Execute()
		while(query.NextRow())
			var/ckey = query.item[1]
			var/rank = query.item[2]
			if(rank == "Removed")	continue	//This person was de-adminned. They are only in the admin list for archive purposes.

			var/rights = query.item[3]
			if(istext(rights))	rights = text2num(rights)
			var/datum/admins/D = new /datum/admins(rank, rights, ckey)

			//find the client for a ckey if they are connected and associate them with the new admin datum
			D.associate(global.directory[ckey])
		if(!admin_datums)
			error("The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
			log_misc("The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
			config.admin_legacy_system = TRUE
			load_admins()
			return

	#ifdef TESTING
	var/msg = "Admins Built:\n"
	for(var/ckey in admin_datums)
		var/rank
		var/datum/admins/D = admin_datums[ckey]
		if(D)	rank = D.rank
		msg += "\t[ckey] - [rank]\n"
	testing(msg)
	#endif


#ifdef TESTING
/client/verb/changerank(newrank in admin_ranks)
	if(holder)
		holder.rank = newrank
		holder.rights = admin_ranks[newrank]
	else
		holder = new /datum/admins(newrank,admin_ranks[newrank],ckey)
	remove_admin_verbs()
	holder.associate(src)

/client/verb/changerights(newrights as num)
	if(holder)
		holder.rights = newrights
	else
		holder = new /datum/admins("testing",newrights,ckey)
	remove_admin_verbs()
	holder.associate(src)

#endif
