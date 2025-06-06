#define LIGHTING_INTERVAL 5 // frequency, in 1/10ths of a second, of the lighting process

#define LIGHTING_FALLOFF 1 // type of falloff to use for lighting; 1 for circular, 2 for square
#define LIGHTING_LAMBERTIAN 1 // use lambertian shading for light sources
#define LIGHTING_HEIGHT 1 // height off the ground of light sources on the pseudo-z-axis, you should probably leave this alone
#define LIGHTING_ROUND_VALUE (1 / 128) //Value used to round lumcounts, values smaller than 1/255 don't matter (if they do, thanks sinking points), greater values will make lighting less precise, but in turn increase performance, VERY SLIGHTLY.

#define LIGHTING_ICON 'icons/effects/lighting_overlay.dmi' // icon used for lighting shading effects
#define FOR_DVIEW(type, range, center, invis_flags) \
	dview_mob.loc = center; \
	dview_mob.see_invisible = invis_flags; \
	for(type in view(range, dview_mob))

#define END_FOR_DVIEW dview_mob.loc = null

// mostly identical to below, but doesn't make sure T is valid first. Should only be used by lighting code.
#define TURF_IS_DYNAMICALLY_LIT_UNSAFE(T) ((T:dynamic_lighting && T:loc:dynamic_lighting))
#define TURF_IS_DYNAMICALLY_LIT(T) (isturf(T) && TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
