//simplified MC that is designed to fail when procs 'break'. When it fails it's just replaced with a new one.
//It ensures master_controller.process() is never doubled up by killing the MC (hence terminating any of its sleeping procs)
//WIP, needs lots of work still

//
// TODO - This will be completely replaced by master.dm in time.
//

var/global/datum/controller/game_controller/master_controller //Set in world.New()

var/global/controller_iteration = 0
var/global/last_tick_timeofday = world.timeofday
var/global/last_tick_duration = 0

var/global/air_processing_killed = 0
var/global/pipe_processing_killed = 0

/datum/controller
	var/processing = 0
	var/iteration = 0
	var/processing_interval = 0

/datum/controller/game_controller
	processing = 0
	var/breather_ticks = 2		//a somewhat crude attempt to iron over the 'bumps' caused by high-cpu use by letting the MC have a breather for this many ticks after every loop
	var/minimum_ticks = 20		//The minimum length of time between MC ticks

	var/air_cost 		= 0
	var/sun_cost		= 0
	var/mobs_cost		= 0
	var/diseases_cost	= 0
	var/machines_cost	= 0
	var/objects_cost	= 0
	var/networks_cost	= 0
	var/powernets_cost	= 0
	var/nano_cost		= 0
	var/sleep_delta		= 1
	var/events_cost		= 0
	var/ticker_cost		= 0
	var/garbageCollectorCost = 0
	var/total_cost		= 0

	var/last_thing_processed
	var/rebuild_active_areas = 0
	var/start_time = 0

	var/global/datum/garbage_collector/garbageCollector

/datum/controller/game_controller/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(master_controller != src)
		if(istype(master_controller))
			Recover()
			qdel(master_controller)
		master_controller = src

	if(!job_master)
		job_master = new /datum/controller/occupations()
		job_master.SetupOccupations()
		job_master.LoadJobs("config/jobs.txt")
		set_donation_locks()
		loadFateLocks()
	if(!radio_controller)
		radio_controller = new /datum/controller/radio()

	if(!emergency_shuttle)
		emergency_shuttle = new /datum/shuttle_controller/emergency_shuttle()

	if(currentmaprotation == "Stoneburrow (Map 4)")
		TRAIN_STOP = 119

/datum/controller/game_controller/proc/setup()
	start_time = world.timeofday
	if(!ticker)
		ticker = new /datum/controller/gameticker()
	setup_objects()
	MushroomGen()
	transfer_controller = new
	spawn(0)
		if(ticker)
			ticker.pregame()
	lighting_controller.Initialize()
	var/turf/controllerlocation = locate(1, 1, 1)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(!controller.initialized)
			controller.initialized = 1
			controller.calc(global.global_openspace)
// TODO: remove this abomination
#define CHECK_SLEEP_MASTER if(++initialized_objects > 50) { initialized_objects=0;sleep(world.tick_lag); }

/datum/controller/game_controller/proc/setup_objects()
	var/initialized_objects = 0
	to_chat(world, "<span class = 'messages'>1. Generating objects...</span>")
	world.log << "Generating Objects"

	for(var/atom/movable/object in global.init_obj)
		if(!QDELETED(object))
			object.initialize()
		CHECK_SLEEP_MASTER

	to_chat(world, "<span class = 'messages'>2. Initializing tunnel network...</span>")
	world.log << "Initializing tunnel network"

	for(var/obj/machinery/atmospherics/machine in global.machines)
		machine.build_network()
		CHECK_SLEEP_MASTER

	to_chat(world, "<span class = 'messages'>3. Initializing the lifeweb...</span>")
	world.log << "Initalizing Atmos Objects"

	for(var/obj/machinery/atmospherics/unary/U in global.machines)
		CHECK_SLEEP_MASTER
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

	to_chat(world, "<span class = 'messages'>4. Letting there be light...</span>")

	to_chat(world, "<span class = 'messages'>5. Dirtying the fortress...")

	var/evergreenGen = world.timeofday
	to_chat(world, "<span class='adminlobby'>God made Evergreen in <b>[(evergreenGen - start_time)/10]</b> seconds.</span>")
	CHECK_SLEEP_MASTER

/datum/controller/game_controller/proc/MushroomGen()		//Mostly a placeholder for now.
	set background = 1
	var/initialized_objects = 0
	//var/list/prohibitedDirs = list(list(EAST, WEST), list(EAST, SOUTHWEST), list(WEST, SOUTHEAST), list(NORTH, SOUTH), list(SOUTHWEST, SOUTHEAST), list(NORTHEAST, SOUTHWEST))
	for(var/turf/simulated/floor/plating/dirt/D in dirt_gen_list)
		if(prob(50))
			continue
		for(var/turf/T in range(1, D))
			if(T?.density)
				D.allowedExist = FALSE
				break;
		/*for(var/list/L in prohibitedDirs)
			CHECK_SLEEP_MASTER
			var/turf/firstDir = get_step(D, L[1])
			var/turf/secondDir = get_step(D, L[2])

			if(firstDir && secondDir)
				if(firstDir.density && secondDir.density)
					allowedExist = 0
					break;
				for(var/obj/A in firstDir.contents)
					if(A.density)
						allowedExist = 0
						break;
				for(var/obj/A in secondDir.contents)
					if(A.density)
						allowedExist = 0
						break;*/

		if(prob(65))
			var/go = 1
			for(var/obj/O in D)
				if(O.density)
					go = 0
			if(go)
				var/selectedMushroomType2 = pick(/obj/item/reagent_containers/food/snacks/grown/mushroom/zheleznyak ,/obj/item/reagent_containers/food/snacks/grown/mushroom/ovrajnik, /obj/item/reagent_containers/food/snacks/grown/mushroom/zelegreeb, /obj/item/reagent_containers/food/snacks/grown/mushroom/bezglaznik,/obj/item/reagent_containers/food/snacks/grown/mushroom/barhovik ,/obj/item/reagent_containers/food/snacks/grown/mushroom/krovnik, /obj/item/reagent_containers/food/snacks/grown/mushroom/corniy, /obj/item/reagent_containers/food/snacks/grown/mushroom/gryab,/obj/item/reagent_containers/food/snacks/grown/mushroom/morfiannik, /obj/item/reagent_containers/food/snacks/grown/mushroom/podgnylnik, /obj/item/reagent_containers/food/snacks/grown/mushroom/ljutogreeb, /obj/item/reagent_containers/food/snacks/grown/mushroom/otorvyannik, /obj/item/reagent_containers/food/snacks/grown/mushroom/plumphelmet)
				new selectedMushroomType2(D)
		if(prob(18))
			new /obj/item/stone(D)
		if(prob(20))
			var/selectedGrassType = /obj/structure/lifeweb/grass
			new selectedGrassType(D)
		if(prob(3))
			if(prob(1))
				if(prob(1))
					var/selectedItem = /obj/item/hatchet/rusty
					new selectedItem(D)
			else if(prob(3))
				var/selectedItem = /obj/item/hatchet/stone
				new selectedItem(D)
			else if(prob(5))
				var/selectedItem = /obj/item/kitchen/utensil/knife/combat
				new selectedItem(D)
		if(prob(2))
			var/selectedItem = /obj/item/reagent_containers/food/snacks/worms
			new selectedItem(D)
		if(D.allowedExist)
			for(var/turf/simulated/floor/plating/dirt/DT in range(1, D))
				DT.allowedExist = FALSE
			if(prob(48))
				var/selectedMushroomType
				if(prob(4))
					selectedMushroomType = pick(/obj/structure/lifeweb/mushroom/sandshroom,/obj/structure/lifeweb/mushroom/stinkshroom)
					new selectedMushroomType(D)
				else
					if(prob(80))
						selectedMushroomType = pick(/obj/structure/lifeweb/mushroom/redcap,/obj/structure/lifeweb/mushroom/sandshroom,/obj/structure/lifeweb/mushroom/meatshroom1,/obj/structure/lifeweb/mushroom/meatshroom2, /obj/structure/lifeweb/mushroom/meatshroom3, /obj/structure/lifeweb/mushroom/poisonous1, /obj/structure/lifeweb/mushroom/poisonous2,/obj/structure/lifeweb/mushroom/dlolont2, /obj/structure/lifeweb/mushroom/sadshroom1, /obj/structure/lifeweb/mushroom/sadshroom2, /obj/structure/lifeweb/mushroom/sadshroom3, /obj/structure/lifeweb/mushroom/glorbmushroom)
						var/obj/O = new selectedMushroomType(D)
						if(prob(50))
							if(prob(50))
								var/matrix/M = matrix()
								M.Scale(1, 1.25)
								O.transform = M
							else
								var/matrix/M = matrix()
								M.Scale(1.25, 1)
								O.transform = M
						if(prob(35))
							O.color = pick("#7cc47c", "#c47c7c", "brown")
					else
						if(prob(65) && (D.z < 7))
							var/selectedRegurgitator = pick(/obj/effect/regurgitator, /obj/effect/trap)
							new selectedRegurgitator(D)
						else
							new /obj/structure/lifeweb/tallshroom(D)
				continue
			if(prob(20))
				var/selectedStoneType = pick(/obj/structure/rack/lwtable/stone/s1,/obj/structure/rack/lwtable/stone/s2,/obj/structure/rack/lwtable/stone/s3,/obj/structure/rack/lwtable/stone/s4,/obj/structure/rack/lwtable/stone/s5,/obj/structure/rack/lwtable/stone/s6,/obj/structure/rack/lwtable/stone/s7)
				new selectedStoneType(D)
				continue
			if(prob(20))
				var/firepool = /obj/structure/campfire/firepool
				new firepool(D)
			if(prob(1) && (D.z < 7))
				var/hive = /obj/item/storage/bee_hive
				new hive(D)
			if(prob(2))
				var/selectedSarcophagus = /obj/structure/closet/crate/sarcophagus
				new selectedSarcophagus(D)
			if(prob(1) && (D.z < 7))
				var/selectedOW = /obj/structure/oldways/xom
				new selectedOW(D)
		CHECK_SLEEP_MASTER