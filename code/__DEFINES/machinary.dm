// NanoUI flags
#define STATUS_INTERACTIVE 2 // GREEN Visability
#define STATUS_UPDATE 1 // ORANGE Visability
#define STATUS_DISABLED 0 // RED Visability
#define STATUS_CLOSE -1 // Close the interface

// Bitflags for machine stat variable.
#define BROKEN   BITFLAG(0)
#define NOPOWER  BITFLAG(1)
#define MAINT    BITFLAG(2) // Under maintenance.
#define EMPED    BITFLAG(3) // Temporary broken by EMP.
#define NOSCREEN BITFLAG(4) // No UI shown via direct interaction
#define NOINPUT  BITFLAG(5) // No input taken from direct interaction