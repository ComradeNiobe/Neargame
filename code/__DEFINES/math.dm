#define MIDNIGHT_ROLLOVER 864000	//number of deciseconds in a day

// Math constants.
#define M_PI    3.14159265

#define R_IDEAL_GAS_EQUATION       8.31    // kPa*L/(K*mol).
#define ONE_ATMOSPHERE             101.325 // kPa.
#define IDEAL_GAS_ENTROPY_CONSTANT 1164    // (mol^3 * s^3) / (kg^3 * L).

// Radiation constants.
#define STEFAN_BOLTZMANN_CONSTANT    5.6704e-8 // W/(m^2*K^4).
#define COSMIC_RADIATION_TEMPERATURE 3.15      // K.
#define AVERAGE_SOLAR_RADIATION      200       // W/m^2. Kind of arbitrary. Really this should depend on the sun position much like solars.
#define RADIATOR_OPTIMUM_PRESSURE    3771      // kPa at 20 C. This should be higher as gases aren't great conductors until they are dense. Used the critical pressure for air.
#define GAS_CRITICAL_TEMPERATURE     132.65    // K. The critical point temperature for air.

#define RADIATOR_EXPOSED_SURFACE_AREA_RATIO 0.04 // (3 cm + 100 cm * sin(3deg))/(2*(3+100 cm)). Unitless ratio.
#define HUMAN_EXPOSED_SURFACE_AREA          5.2 //m^2, surface area of 1.7m (H) x 0.46m (D) cylinder

#define COLDCAVE  253.15 //    -20.0 degrees celcius
#define COLDDIRT  263.15 //    -10.0 degrees celcius
#define T0C  273.15 //    0.0 degrees celcius
#define T20C 293.15 //   20.0 degrees celcius
#define TCMB 2.7    // -270.3 degrees celcius

#define CLAMP01(x) max(0, min(1, x))
#define CLAMP(CLVALUE,CLMIN,CLMAX) ( max( (CLMIN), min((CLVALUE), (CLMAX)) ) )
#define ATMOS_PRECISION 0.0001
#define QUANTIZE(variable) (round(variable, ATMOS_PRECISION))

#define INFINITY	1.#INF

#define TICKS_IN_DAY 		24*60*60*10
#define TICKS_IN_SECOND 	10

#define SIMPLE_SIGN(X) ((X) < 0 ? -1 : 1)
#define SIGN(X)        ((X) ? SIMPLE_SIGN(X) : 0)

#define MODULUS_FLOAT(X, Y) ( (X) - (Y) * round((X) / (Y)) )

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DEGREES(degrees) (MODULUS_FLOAT((degrees), 360))

// Macro functions.
#define RAND_F(LOW, HIGH) (rand() * ((HIGH) - (LOW)) + (LOW))

// Float-aware floor and ceiling since round() will round upwards when given a second arg.
#define NONUNIT_FLOOR(x, y)    (floor((x) / (y)) * (y))
#define NONUNIT_CEILING(x, y) (ceil((x) / (y)) * (y))

// Special two-step rounding for reagents, to avoid floating point errors.
#define CHEMS_QUANTIZE(x) NONUNIT_FLOOR(round(x, MINIMUM_CHEMICAL_VOLUME * 0.1), MINIMUM_CHEMICAL_VOLUME)

#define MULT_BY_RANDOM_COEF(VAR,LO,HI) VAR =  round((VAR * rand(LO * 100, HI * 100))/100, 0.1)

#define EULER 2.7182818285

#define IS_POWER_OF_TWO(VAL) ((VAL & (VAL-1)) == 0)
#define ROUND_UP_TO_POWER_OF_TWO(VAL) (2 ** ceil(log(2,VAL)))

// turn(0, angle) returns a random dir. This macro will instead do nothing if dir is already 0.
#define SAFE_TURN(DIR, ANGLE) (DIR && turn(DIR, ANGLE))
