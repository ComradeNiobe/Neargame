// The purpose of this file is to store the world definition. For world setup, see code/game/world.dm

/world
	mob = /mob/new_player
	turf = /turf/simulated/wall/r_wall/cave
	area = /area/dunwell/surface
	view = "15x15"
	cache_lifespan = 7	// Set this to 0 if you allow player uploaded music... which you shouldn't.
	sleep_offline = FALSE
	fps = 20
