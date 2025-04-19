/datum/controller/process/light/setup()
	name = "light"
	schedule_interval = 1 // every 0.1 seconds
	start_delay = 32

/datum/controller/process/light/doWork()
	lighting_controller.process()