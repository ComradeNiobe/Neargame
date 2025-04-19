//DEFINES DO GURPS
#define GP_CRITSUCCESS 2
#define GP_CRITFAIL -2
#define GP_SUCCESS 1
#define GP_FAIL -1

#define GP_RESULT 1
#define GP_MARGIN 2
#define GP_DICE 3
#define GP_CHANCE 4

#define STAT_ST  1
#define STAT_DX  2
#define STAT_HT  3
#define STAT_IN  4
#define STAT_PR  5
#define STAT_WP  6
#define STAT_IM  7
#define STAT_SPD 8
#define TOTAL_STATS 8

#define BASE_STAT_VALUE 10
#define BASE_STAT_CHANGE rand(-1, 0)

#define SKILL_NONE	 0
#define SKILL_MELEE  1
#define SKILL_RANGE  2
#define SKILL_THROW  3
#define SKILL_FARM	 4
#define SKILL_COOK	 5
#define SKILL_ENGINE 6
#define SKILL_SURG	 7 //actually a spec but whatever
#define SKILL_MEDIC	 8
#define SKILL_CLEAN  9
#define SKILL_SMITH	 10
#define SKILL_CLIMB  11
#define SKILL_MASON	 12
#define SKILL_STEAL	 13
#define SKILL_SWIM	 14
#define SKILL_PARTY  15
#define SKILL_MINE	 16
#define SKILL_TAN	 17
#define SKILL_CUT	 18
#define SKILL_ALCH	 19
#define SKILL_SURVIV 20
#define SKILL_FISH	 21
#define SKILL_LOCK	 22
#define SKILL_SNEAK  23
#define SKILL_RIDE	 24
#define SKILL_MUSIC  25
#define SKILL_TRAP   26
#define SKILL_CRAFT  27
#define SKILL_BOAT	 28
#define SKILL_OBSERV 29
//specs
#define SKILL_SWORD	 30
#define SKILL_STAFF  31 //spears, staffs and polearms
#define	SKILL_KNIFE	 32
#define SKILL_UNARM	 33
#define SKILL_SWING	 34 // Axes and clubs
#define SKILL_FLAIL  35
#define SKILL_CBOW	 36
#define SKILL_BOW	 37

#define SKILL_SIZE 	 37 //Set to the newest skills value

#define WEIGHT_NONE "None"
#define WEIGHT_LIGHT "Light"
#define WEIGHT_MEDIUM "Medium"
#define WEIGHT_HEAVY "HEAVY"

#define get_skill_value(x,skills) (skills.skills_holder[x]["value"])
#define get_skill_data(x,skills) (skills.skills_holder[x]["data"])

#define ATTK_SWI   1
#define ATTK_THR   2
#define DAM_BURN   1 // burning
#define DAM_COR    2 //corrosion
#define DAM_CR     3 // crushing
#define DAM_CUT    4 //cutting
#define DAM_FAT    5 //fatigue
#define DAM_IMP    6 // impaling
#define DAM_SPI    7 //small piercing
#define DAM_PI     8 // piercing
#define DAM_LPI    9 //large piercing
#define DAM_HPI   10 //huge piercing

var/list/dt_str  = list( //Because enums don't exist
	"DAM_BURN",
	"DAM_COR",
	"DAM_CR",
	"DAM_CUT",
	"DAM_FAT",
	"DAM_IMP",
	"DAM_SPI",
	"DAM_PI",
	"DAM_LPI",
	"DAM_HPI",
)

proc/damtype2text(var/dam_type)
	return dt_str[dam_type]

#define SHARP_DAM DAM_CUT, DAM_IMP, DAM_SPI, DAM_PI, DAM_LPI, DAM_HPI //used for checking things like artery cuts.

#define PAIN_NONE   0
#define PAIN_SMALL -1
#define PAIN_MOD   -2
#define PAIN_SEV   -4
#define PAIN_TERR  -6
#define PAIN_AGON  -8

#define DR_CRUSHING  1//use split DR if attack is crushing. Normal if not.
#define DR_CUT_PI 2 //use the first DR against piercing and cutting attacks; use the second,lower DR against all other damage types