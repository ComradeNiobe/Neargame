/datum/tgs_chat_command/status
	name = "status"
	help_text = "shows the status of the server"
	admin_only = FALSE

/datum/tgs_chat_command/status/Run(datum/tgs_chat_user/sender, params)
	var/n = length(global.clients)
	var/roundstatus = ""
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000

	switch(ticker.current_state)
		if(GAME_STATE_PREGAME)
			roundstatus = "Story in Lobby."
		if(GAME_STATE_FINISHED)
			roundstatus = "Your fortress has been abandoned."
		else
			roundstatus = "Story has started."
	return "<byond://[world.address]:[world.port]> [n] players online - Round Duration: [round(hours)]h [round(mins)]m - [roundstatus]"