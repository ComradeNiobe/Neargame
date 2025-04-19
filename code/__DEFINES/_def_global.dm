//See controllers/globals.dm
#define GLOBAL_MANAGED(X, InitValue)\
/datum/controller/global_vars/proc/InitGlobal##X(){\
	##X = ##InitValue;\
	gvars_datum_init_order += #X;\
}
#define GLOBAL_UNMANAGED(X, InitValue) /datum/controller/global_vars/proc/InitGlobal##X()

#ifndef TESTING
#define GLOBAL_PROTECT(X)\
/datum/controller/global_vars/InitGlobal##X(){\
	..();\
	gvars_datum_protected_varlist += #X;\
}
#else
#define GLOBAL_PROTECT(X)
#endif

#define GLOBAL_REAL_VAR(X) var/global/##X
#define GLOBAL_REAL(X, Typepath) var/global##Typepath/##X

#define GLOBAL_RAW(X) /datum/controller/global_vars/var/global##X

#define GLOBAL_VAR_INIT(X, InitValue) GLOBAL_RAW(/##X); GLOBAL_MANAGED(X, InitValue)

#define GLOBAL_VAR_CONST(X, InitValue) GLOBAL_RAW(/const/##X) = InitValue; GLOBAL_UNMANAGED(X, InitValue)

#define GLOBAL_LIST_INIT(X, InitValue) GLOBAL_RAW(/list/##X); GLOBAL_MANAGED(X, InitValue)

#define GLOBAL_LIST_EMPTY(X) GLOBAL_LIST_INIT(X, list())

#define GLOBAL_DATUM_INIT(X, Typepath, InitValue) GLOBAL_RAW(Typepath/##X); GLOBAL_MANAGED(X, InitValue)

#define GLOBAL_VAR(X) GLOBAL_RAW(/##X); GLOBAL_MANAGED(X, null)

#define GLOBAL_LIST(X) GLOBAL_RAW(/list/##X); GLOBAL_MANAGED(X, null)

#define GLOBAL_DATUM(X, Typepath) GLOBAL_RAW(Typepath/##X); GLOBAL_MANAGED(X, null)

#define isvirtualmob(A) istype(A, /mob/observer/virtual)
#define listequal(A, B) (A.len == B.len && !length(A^B))

/proc/trange(rad = 0, turf/centre = null) //alternative to range (ONLY processes turfs and thus less intensive)
	if(!centre)
		return

	var/turf/x1y1 = locate(((centre.x-rad)<1 ? 1 : centre.x-rad),((centre.y-rad)<1 ? 1 : centre.y-rad),centre.z)
	var/turf/x2y2 = locate(((centre.x+rad)>world.maxx ? world.maxx : centre.x+rad),((centre.y+rad)>world.maxy ? world.maxy : centre.y+rad),centre.z)
	return block(x1y1,x2y2)

#define TimeOfGame (get_game_time())
#define TimeOfTick (world.tick_usage*0.01*world.tick_lag)
/proc/get_game_time()
	var/global/time_offset = 0
	var/global/last_time = 0
	var/global/last_usage = 0

	var/wtime = world.time
	var/wusage = world.tick_usage * 0.01

	if(last_time < wtime && last_usage > 1)
		time_offset += last_usage - 1

	last_time = wtime
	last_usage = wusage

	return wtime + (time_offset + wusage) * world.tick_lag

// Process status defines
#define PROCESS_STATUS_IDLE 1
#define PROCESS_STATUS_QUEUED 2
#define PROCESS_STATUS_RUNNING 3
#define PROCESS_STATUS_MAYBE_HUNG 4
#define PROCESS_STATUS_PROBABLY_HUNG 5
#define PROCESS_STATUS_HUNG 6

// Process time thresholds
#define PROCESS_DEFAULT_HANG_WARNING_TIME 	300 // 30 seconds
#define PROCESS_DEFAULT_HANG_ALERT_TIME 	600 // 60 seconds
#define PROCESS_DEFAULT_HANG_RESTART_TIME 	900 // 90 seconds
#define PROCESS_DEFAULT_SCHEDULE_INTERVAL 	50  // 50 ticks
#define PROCESS_DEFAULT_SLEEP_INTERVAL		2	// 2 ticks
#define PROCESS_DEFAULT_CPU_THRESHOLD		90  // 90%

// SCHECK macros
// This references src directly to work around a weird bug with try/catch
#define SCHECK_EVERY(this_many_calls) if(++src.calls_since_last_scheck >= this_many_calls) sleepCheck()
#define SCHECK SCHECK_EVERY(50)