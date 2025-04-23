/datum/controller/process/ticker/setup()
	name = "ticker"
	schedule_interval = 20 // every 2 seconds
	start_delay = 24

/datum/controller/process/ticker/doWork()
	ticker.process()

/datum/controller/process/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration

// Use these preferentially to directly examining ticker.current_state to help prepare for transition to ticker as subsystem!
/datum/controller/process/ticker/proc/HasRoundStarted()
	return (ticker && ticker.current_state >= GAME_STATE_PLAYING)

/datum/controller/process/ticker/proc/IsRoundInProgress()
	return (ticker && ticker.current_state == GAME_STATE_PLAYING)
