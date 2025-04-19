#define SOLID 1
#define LIQUID 2
#define GAS 3

// How many units of reagent are consumed per tick, by default.
#define REAGENTS_METABOLISM 0.3

// By defining the effect multiplier this way, it'll exactly adjust
// all effects according to how they originally were with the 0.4 metabolism
#define REAGENTS_EFFECT_MULTIPLIER REAGENTS_METABOLISM / 0.4

#define REM REAGENTS_EFFECT_MULTIPLIER
