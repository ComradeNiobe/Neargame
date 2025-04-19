//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done


// Clickable stat() button.
/obj/effect/statclick
	name = "Initializing..."
	var/target

/obj/effect/statclick/New(loc, text, target) //Don't port this to Initialize it's too critical
	..()
	name = text
	src.target = target

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/Click()
	if(!usr.client.holder || !target)
		return
	if(!class)
		if(istype(target, /datum/controller/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(istype(target, /datum))
			class = "datum"
		else
			class = "unknown"

	usr.client.debug_variables(target)
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")

/client/proc/restart_controller(controller in list("Master","Failsafe"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	switch(controller)
		if("Master")
			Recreate_MC()
			feedback_add_details("admin_verb","RMC")
		if("Failsafe")
			new /datum/controller/failsafe()
			feedback_add_details("admin_verb","RFailsafe")

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")

/client/proc/debug_controller(controller in list("Master","Failsafe","Ticker","Lighting","Air","Jobs","Sun","Radio","Supply Shuttle","Emergency Shuttle","Configuration","pAI", "Cameras", "Transfer Controller", "Train Shuttle"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("Master")
			debug_variables(master_controller)
		if("Ticker")
			debug_variables(ticker)
//		if("Lighting")
//			debug_variables(lighting_controller)
		if("Air")
			debug_variables(air_master)
		if("Jobs")
			debug_variables(job_master)
		if("Sun")
			debug_variables(sun)
		if("Radio")
			debug_variables(radio_controller)
		if("Supply Shuttle")
			debug_variables(supply_shuttle)
		if("Emergency Shuttle")
			debug_variables(emergency_shuttle)
		if("Configuration")
			debug_variables(config)
		if("pAI")
			debug_variables(paiController)
		if("Train Shuttle")
			debug_variables(train_shuttle)
		if("Cameras")
			debug_variables(cameranet)
		if("Transfer Controller")
			debug_variables(transfer_controller)
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
