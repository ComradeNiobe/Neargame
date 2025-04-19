#define FOR_DVIEW(type, range, center, invis_flags) \
	global.dview_mob.loc = center; \
	global.dview_mob.see_invisible = invis_flags; \
	for(type in view(range, dview_mob))

#define END_FOR_DVIEW dview_mob.loc = null

#define DVIEW(output, range, center, invis_flags) \
	global.dview_mob.loc = center; \
	global.dview_mob.see_invisible = invis_flags; \
	output = view(range, dview_mob); \
	global.dview_mob.loc = null;

//This is for later use in my lighting update but holy fuck I need to code a lot of shit in.