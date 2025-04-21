#define DEBUG
// Turf-only flags.
#define TURF_FLAG_NOJAUNT               BITFLAG(0) // This is used in literally one place, turf.dm, to block ethereal jaunt.
#define TURF_FLAG_NO_POINTS_OF_INTEREST BITFLAG(1) // Used by the level subtemplate generator to skip placing loaded templates on this turf.
#define TURF_FLAG_BACKGROUND            BITFLAG(2) // Used by shuttle movement to determine if it should be ignored by turf translation.
#define TURF_FLAG_HOLY                  BITFLAG(3)
#define TURF_FLAG_ABSORB_LIQUID         BITFLAG(4)
#define TURF_IS_HOLOMAP_OBSTACLE        BITFLAG(5)
#define TURF_IS_HOLOMAP_PATH            BITFLAG(6)
#define TURF_IS_HOLOMAP_ROCK            BITFLAG(7)

//Error handler defines
#define ERROR_USEFUL_LEN 2

#define TYPE_IS_ABSTRACT(D) (initial(D.abstract_type) == D)
#define TYPE_IS_SPAWNABLE(D) (!TYPE_IS_ABSTRACT(D) && initial(D.is_spawnable_type))
#define INSTANCE_IS_ABSTRACT(D) (D.abstract_type == D.type)

#define EXCEPTION_TEXT(E) "'[E.name]' ('[E.type]'): '[E.file]':[E.line]:\n'[E.desc]'"

//Area flags, possibly more to come
#define AREA_FLAG_RAD_SHIELDED         BITFLAG(1)  // Shielded from radiation, clearly.
#define AREA_FLAG_EXTERNAL             BITFLAG(2)  // External as in exposed to space, not outside in a nice, green, forest.
#define AREA_FLAG_ION_SHIELDED         BITFLAG(3)  // Shielded from ionospheric anomalies.
#define AREA_FLAG_IS_NOT_PERSISTENT    BITFLAG(4)  // SSpersistence will not track values from this area.
#define AREA_FLAG_IS_BACKGROUND        BITFLAG(5)  // Blueprints can create areas on top of these areas. Cannot edit the name of or delete these areas.
#define AREA_FLAG_MAINTENANCE          BITFLAG(6)  // Area is a maintenance area.
#define AREA_FLAG_SHUTTLE              BITFLAG(7)  // Area is a shuttle area.
#define AREA_FLAG_HALLWAY              BITFLAG(8)  // Area is a public hallway suitable for event selection
#define AREA_FLAG_PRISON               BITFLAG(9)  // Area is a prison for the purposes of brigging objectives.
#define AREA_FLAG_HOLY                 BITFLAG(10) // Area is holy for the purposes of marking turfs as cult-resistant.
#define AREA_FLAG_SECURITY             BITFLAG(11) // Area is security for the purposes of newscaster init.
#define AREA_FLAG_HIDE_FROM_HOLOMAP    BITFLAG(12) // if we shouldn't be drawn on station holomaps

// Literacy check constants.
#define WRITTEN_SKIP     0
#define WRITTEN_PHYSICAL 1
#define WRITTEN_DIGITAL  2