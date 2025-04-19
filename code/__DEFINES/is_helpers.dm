// simple is_type and similar inline helpers

/// Within given range, but not counting z-levels
#define IN_GIVEN_RANGE(source, other, given_range) (get_dist(source, other) <= given_range && (get_step(source, 0)?:z) == (get_step(other, 0)?:z))

#define isatom(A) (isloc(A))

#define isdatum(thing) (istype(thing, /datum))

#define isimage(thing) (istype(thing, /image))

#define isweakref(A) istype(A, /weakref)

#define get_turf(A) get_step(A,0)

#define get_area(A) (get_step(A, 0)?.loc)

#define get_x(A) (get_step(A, 0)?.x || 0)

#define get_y(A) (get_step(A, 0)?.y || 0)

#define get_z(A) (get_step(A, 0)?.z || 0)

// simple check whether or not a player is a guest using their key
#define IS_GUEST_KEY(key)	(findtextEx(key, "Guest-", 1, 7))

//Turfs
//#define isturf(A) (istype(A, /turf)) This is actually a byond built-in. Added here for completeness sake.

#define isopenturf(A) (istype(A, /turf/open))

#define istransitturf(A) (istype(A, /turf/open/space/transit))

#define isindestructiblefloor(A) (istype(A, /turf/open/indestructible))

#define isspaceturf(A) (istype(A, /turf/open/space))

#define isfloorturf(A) (istype(A, /turf/open/floor))

#define isanyfloor(A) (isfloorturf(A) || isindestructiblefloor(A))

#define isclosedturf(A) (istype(A, /turf/closed))

#define isindestructiblewall(A) (istype(A, /turf/closed/indestructible))

#define iswallturf(A) (istype(A, /turf/closed/wall))

#define ismineralturf(A) (istype(A, /turf/closed/mineral))

#define islava(A) (istype(A, /turf/open/lava))

#define ischasm(A) (istype(A, /turf/open/chasm))

#define isplatingturf(A) (istype(A, /turf/open/floor/plating))

#define isopenspace(A) (istype(A, /turf/open/openspace))

//Mobs
#define isliving(A) (istype(A, /mob/living))

#define isbrain(A) (istype(A, /mob/living/carbon/brain))

//Carbon mobs
#define iscarbon(A) (istype(A, /mob/living/carbon))

#define ishuman(A) (istype(A, /mob/living/carbon/human))

//more carbon mobs
#define ismonkey(A) (istype(A, /mob/living/carbon/monkey))

#define isxeno(A) (istype(A, /mob/living/carbon/xenomorph))

#define isalien(A) (istype(A, /mob/living/carbon/alien))

#define islarva(A) (istype(A, /mob/living/carbon/alien/larva))

#define isalienadult(A) (istype(A, /mob/living/carbon/alien/humanoid) || istype(A, /mob/living/simple_animal/hostile/alien))

#define isalienhunter(A) (istype(A, /mob/living/carbon/alien/humanoid/hunter))

#define isaliensentinel(A) (istype(A, /mob/living/carbon/alien/humanoid/sentinel))

#define isalienroyal(A) (istype(A, /mob/living/carbon/alien/humanoid/royal))

#define isalienqueen(A) (istype(A, /mob/living/carbon/alien/humanoid/royal/queen))

//Silicon mobs
#define issilicon(A) (istype(A, /mob/living/silicon))

#define issiliconoradminghost(A) (istype(A, /mob/living/silicon) || IsAdminGhost(A))

#define iscyborg(A) (istype(A, /mob/living/silicon/robot))

#define isAI(A) (istype(A, /mob/living/silicon/ai))

#define ispAI(A) (istype(A, /mob/living/silicon/pai))

//Simple animals
#define isanimal(A) (istype(A, /mob/living/simple_animal))

//Misc mobs
#define isobserver(A) (istype(A, /mob/dead/observer))

#define isdead(A) (istype(A, /mob/dead))

#define isnewplayer(A) (istype(A, /mob/dead/new_player))

#define isovermind(A) (istype(A, /mob/camera/blob))

#define iscameramob(A) (istype(A, /mob/camera))

#define isaicamera(A) (istype(A, /mob/camera/ai_eye))

//Objects
#define isobj(A) istype(A, /obj) //override the byond proc because it returns true on children of /atom/movable that aren't objs

#define isitem(A) (istype(A, /obj/item))

#define isstack(A) (istype(A, /obj/item/stack))

#define isgrenade(A) (istype(A, /obj/item/grenade))

#define islandmine(A) (istype(A, /obj/effect/mine))

#define isammocasing(A) (istype(A, /obj/item/ammo_casing))

#define isidcard(I) (istype(I, /obj/item/card/id))

#define isstructure(A) (istype(A, /obj/structure))

#define ismachinery(A) (istype(A, /obj/machinery))

#define isorgan(A) (istype(A, /datum/organ/external))

#define isclothing(A) (istype(A, /obj/item/clothing))

#define isbodypart(A) (istype(A, /datum/item/bodypart))

#define isprojectile(A) (istype(A, /obj/projectile))

#define isgun(A) (istype(A, /obj/item/gun))

#define is_reagent_container(O) (istype(O, /obj/item/reagent_containers))

#define iseffect(O) (istype(O, /obj/effect))

/// isnum() returns TRUE for NaN. Also, NaN != NaN. Checkmate, BYOND.
#define isnan(x) ( (x) != (x) )

#define SYSTEM_TYPE_INFINITY 1.#INF //only for isinf check

#define isinf(x) (isnum((x)) && (((x) == SYSTEM_TYPE_INFINITY) || ((x) == -SYSTEM_TYPE_INFINITY)))

#define isProbablyWallMounted(O) (O.pixel_x > 20 || O.pixel_x < -20 || O.pixel_y > 20 || O.pixel_y < -20)

/// NaN isn't a number, damn it. Infinity is a problem too.
#define isnum_safe(x) ( isnum((x)) && !isnan((x)) && !isinf((x)) )