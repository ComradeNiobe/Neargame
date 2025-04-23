// Called if an atom is deleted before it initializes. Only call Destroy in this if you know what you're doing.
/atom/proc/EarlyDestroy(force = FALSE)
	return QDEL_HINT_QUEUE

/atom/movable/EarlyDestroy(force = FALSE)
	loc = null // should NOT use forceMove, in order to avoid events
	return ..()