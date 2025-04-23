//Qdel helper macros.
#define QDEL_IN(item, time) if(!isnull(item)) {addtimer(CALLBACK(item, TYPE_PROC_REF(/datum, qdel_self)), time)}
#define QDEL_IN_CLIENT_TIME(item, time) if(!isnull(item)) {addtimer(CALLBACK(item, TYPE_PROC_REF(/datum, qdel_self)), time, TIMER_CLIENT_TIME)}
#define QDEL_NULL(item) if(item) {qdel(item); item = null}
#define QDEL_NULL_SCREEN(item) if(client) { client.screen -= item; }; QDEL_NULL(item)
#define QDEL_NULL_LIST(x) if(x) { for(var/y in x) { qdel(y) }}; if(x) {x.Cut(); x = null } // Second x check to handle items that LAZYREMOVE on qdel.
#define QDEL_LIST(L) if(L) { for(var/I in L) qdel(I); L.Cut(); }
#define QDEL_LIST_IN(L, time) addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(______qdel_list_wrapper), L), time)
#define QDEL_LIST_ASSOC(L) if(L) { for(var/I in L) { qdel(L[I]); qdel(I); } L.Cut(); }
#define QDEL_LIST_ASSOC_VAL(L) if(L) { for(var/I in L) qdel(L[I]); L.Cut(); }

/proc/______qdel_list_wrapper(list/L) //the underscores are to encourage people not to use this directly.
	QDEL_LIST(L)
