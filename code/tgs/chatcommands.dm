/datum/tgs_chat_command/status
	name = "status"
	help_text = "shows the status of the server"
	admin_only = FALSE

/datum/tgs_chat_command/status/Run(datum/tgs_chat_user/sender, params)
	var/n = 0
	var/roundstatus = ""
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000

	for(var/client/C in clients)
		n++

	switch(ticker.current_state)
		if(GAME_STATE_PREGAME)
			roundstatus = "Story in Lobby."
		if(GAME_STATE_FINISHED)
			roundstatus = "Your fortress has been abandoned."
		else
			roundstatus = "Story has started."
	return "<byond://play.nearweb.org:59490> [n] players online - Round Duration: [round(hours)]h [round(mins)]m - [roundstatus]"