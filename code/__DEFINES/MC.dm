#define MC_TICK_CHECK ( ( world.tick_usage > CURRENT_TICKLIMIT || src.state != SS_RUNNING ) ? pause() : 0 )
// Used to smooth out costs to try and avoid oscillation.
#define MC_AVERAGE_FAST(average, current) (0.7 * (average) + 0.3 * (current))
#define MC_AVERAGE(average, current) (0.8 * (average) + 0.2 * (current))
#define MC_AVERAGE_SLOW(average, current) (0.9 * (average) + 0.1 * (current))
#define NEW_SS_GLOBAL(varname) if(varname != src){if(istype(varname)){Recover();qdel(varname);}varname = src;}

#define START_PROCESSING(Processor, Datum) if (!Datum.isprocessing) {Datum.isprocessing = 1;Processor.processing += Datum}
#define STOP_PROCESSING(Processor, Datum) Datum.isprocessing = 0;Processor.processing -= Datum

//SubSystem flags (Please design any new flags so that the default is off, to make adding flags to subsystems easier)

//subsystem should fire during pre-game lobby.
#define SS_FIRE_IN_LOBBY 1

//subsystem does not initialize.
#define SS_NO_INIT 2

//subsystem does not fire.
//	(like can_fire = 0, but keeps it from getting added to the processing subsystems list)
//	(Requires a MC restart to change)
#define SS_NO_FIRE 4

//subsystem only runs on spare cpu (after all non-background subsystems have ran that tick)
//	SS_BACKGROUND has its own priority bracket
#define SS_BACKGROUND 8

//subsystem does not tick check, and should not run unless there is enough time (or its running behind (unless background))
#define SS_NO_TICK_CHECK 16

//Treat wait as a tick count, not DS, run every wait ticks.
//	(also forces it to run first in the tick, above even SS_NO_TICK_CHECK subsystems)
//	(implies SS_FIRE_IN_LOBBY because of how it works)
//	(overrides SS_BACKGROUND)
//	This is designed for basically anything that works as a mini-mc (like SStimer)
#define SS_TICKER 32

//keep the subsystem's timing on point by firing early if it fired late last fire because of lag
//	ie: if a 20ds subsystem fires say 5 ds late due to lag or what not, its next fire would be in 15ds, not 20ds.
#define SS_KEEP_TIMING 64

//Calculate its next fire after its fired.
//	(IE: if a 5ds wait SS takes 2ds to run, its next fire should be 5ds away, not 3ds like it normally would be)
//	This flag overrides SS_KEEP_TIMING
#define SS_POST_FIRE_TIMING 128

// -- SStimer stuff --

#define TIMER_UNIQUE       BITFLAG(0) // Don't run if there is an identical unique timer active.
#define TIMER_OVERRIDE     BITFLAG(1) // For unique timers: Replace the old timer rather than not start this one.
#define TIMER_CLIENT_TIME  BITFLAG(2) // Timing should be based on how timing progresses on clients, not the server - this is more expensive, so should only be used with things that need to progress client-side (like animate or sound).
#define TIMER_STOPPABLE    BITFLAG(3) // Timer can be stopped using deltimer().
#define TIMER_NO_HASH_WAIT BITFLAG(4) // For unique timers: don't distinguish timers by wait.
#define TIMER_LOOP         BITFLAG(5) // Repeat the timer until it's deleted or the parent is destroyed.

// TIMER_OVERRIDE is impossible to support because we don't track that for DPC queued calls, and adding a third list for that would be a lot of overhead for no real benefit
// TIMER_STOPPABLE can't work because it uses timer IDs instead of hashes, and DPC queued calls don't have IDs.
// TIMER_LOOP doesn't work because it needs to be a timer that can re-insert in the list, and a zero-wait looping timer should really be a ticker subsystem instead.
// Update these defines if any of those change.
/// These are the flags forbidden when putting zero-wait timers on SSdpc instead of SStimer.
#define DPC_FORBID_FLAGS   TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE | TIMER_LOOP
/// These are the flags forbidden when putting zero-wait TIMER_UNIQUE timers on SSdpc instead of SStimer.
#define UDPC_FORBID_FLAGS  TIMER_OVERRIDE | TIMER_STOPPABLE | TIMER_LOOP

#define TIMER_ID_NULL -1

/**
	Create a new timer and add it to the queue.
	* Arguments:
	* * callback the callback to call on timer finish
	* * wait deciseconds to run the timer for
	* * flags flags for this timer, see: code\__DEFINES\subsystems.dm
*/
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)

//SUBSYSTEM STATES
#define SS_IDLE 0		//aint doing shit.
#define SS_QUEUED 1		//queued to run
#define SS_RUNNING 2	//actively running
#define SS_PAUSED 3		//paused by mc_tick_check
#define SS_SLEEPING 4	//fire() slept.
#define SS_PAUSING 5 	//in the middle of pausing

// Standard way to define a global subsystem, keep boilerplate organized here!
#define SUBSYSTEM_DEF(X) var/datum/controller/subsystem/##X/SS##X;\
/datum/controller/subsystem/##X/New(){\
    NEW_SS_GLOBAL(SS##X);\
    PreInit();\
}\
/datum/controller/subsystem/##X