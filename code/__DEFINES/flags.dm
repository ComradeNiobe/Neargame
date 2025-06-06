// Atom-level flags (/atom/var/atom_flags)
#define ATOM_FLAG_CHECKS_BORDER             BITFLAG(0)  // If a dense atom (potentially) only blocks movements from a given direction, i.e. window panes
#define ATOM_FLAG_CLIMBABLE                 BITFLAG(1)  // This object can be climbed on
#define ATOM_FLAG_NO_BLOOD                  BITFLAG(2)  // Used for items if they don't want to get a blood overlay.
#define ATOM_FLAG_NO_REACT                  BITFLAG(3)  // Reagents don't react inside this container.
#define ATOM_FLAG_OPEN_CONTAINER            BITFLAG(4)  // Is an open container for chemistry purposes.
#define ATOM_FLAG_INITIALIZED               BITFLAG(5)  // Has this atom been initialized
#define ATOM_FLAG_CAN_BE_PAINTED            BITFLAG(6)  // Can be painted using a paint sprayer or similar.
#define ATOM_FLAG_SHIELD_CONTENTS           BITFLAG(7)  // Protects contents from some global effects (Solar storms)
#define ATOM_FLAG_ADJACENT_EXCEPTION        BITFLAG(8)  // Skips adjacent checks for atoms that should always be reachable in window tiles
#define ATOM_FLAG_NO_DISSOLVE               BITFLAG(9)  // Bypasses solvent reactions in the container.
#define ATOM_FLAG_NO_PHASE_CHANGE           BITFLAG(10) // Bypasses heating and cooling product reactions in the container.
#define ATOM_FLAG_BLOCK_DIAGONAL_FACING     BITFLAG(11) // Atom cannot face non-cardinal directions.

#define ATOM_FLAG_NO_CHEM_CHANGE            (ATOM_FLAG_NO_REACT | ATOM_FLAG_NO_DISSOLVE | ATOM_FLAG_NO_PHASE_CHANGE)

#define ATOM_IS_OPEN_CONTAINER(A)           (A.atom_flags & ATOM_FLAG_OPEN_CONTAINER)

// Movable-level flags (/atom/movable/movable_flags)
#define MOVABLE_FLAG_PROXMOVE               BITFLAG(0)  // Does this object require proximity checking in Enter()?
#define MOVABLE_FLAG_Z_INTERACT             BITFLAG(1)  // Should attackby and attack_hand be relayed through ladders and open spaces?
#define MOVABLE_FLAG_ALWAYS_SHUTTLEMOVE     BITFLAG(2)  // Is this an effect that should move?
#define MOVABLE_FLAG_DEL_SHUTTLE            BITFLAG(3)  // Shuttle transistion will delete this.
#define MOVABLE_FLAG_WHEELED                BITFLAG(4)  // Movable has reduced stamina cost/speed reduction when pulled.

// Object-level flags (/obj/obj_flags)
#define OBJ_FLAG_ANCHORABLE                 BITFLAG(0)  // This object can be stuck in place with a tool
#define OBJ_FLAG_CONDUCTIBLE                BITFLAG(1)  // Conducts electricity. (metal etc.)
#define OBJ_FLAG_ROTATABLE                  BITFLAG(2)  // Can be rotated with alt-click
#define OBJ_FLAG_NOFALL                     BITFLAG(3)  // Will prevent mobs from falling
#define OBJ_FLAG_MOVES_UNSUPPORTED          BITFLAG(4)  // Object moves with shuttle transition even if turf below is a background turf.
#define OBJ_FLAG_HOLLOW                     BITFLAG(5)  // Modifies initial matter values to be lower than w_class normally sets.
#define OBJ_FLAG_SUPPORT_MOB                BITFLAG(6)  // Object can be used to prop up a mob with stance damage (broken legs)
#define OBJ_FLAG_INSULATED_HANDLE           BITFLAG(7)  // Object skips burn checks when held by unprotected hands.
#define OBJ_FLAG_NO_STORAGE                 BITFLAG(8)  // Object cannot be placed into storage.

// Item-level flags (/obj/item/item_flags)
#define ITEM_FLAG_NO_BLUDGEON               BITFLAG(0)  // When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define ITEM_FLAG_NO_CONTAMINATION          BITFLAG(1)  // Does not get contaminated.
#define ITEM_FLAG_NO_PRINT                  BITFLAG(2)  // This object does not leave the user's prints/fibres when using it
#define ITEM_FLAG_INVALID_FOR_CHAMELEON     BITFLAG(3)  // Chameleon items cannot mimick this.
#define ITEM_FLAG_THICKMATERIAL             BITFLAG(4)  // Prevents syringes, reagent pens, and hyposprays if equiped to slot_suit or slot_head_str.
#define ITEM_FLAG_AIRTIGHT                  BITFLAG(5)  // Functions with internals.
#define ITEM_FLAG_NOSLIP                    BITFLAG(6)  // Prevents from slipping on wet floors, in space, etc.
#define ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT    BITFLAG(7)  // Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define ITEM_FLAG_FLEXIBLEMATERIAL          BITFLAG(8)  // At the moment, masks with this flag will not prevent eating even if they are covering your face.
#define ITEM_FLAG_IS_BELT                   BITFLAG(9)  // Items that can be worn on the belt slot, even with no undersuit equipped
#define ITEM_FLAG_SILENT                    BITFLAG(10) // sneaky shoes
#define ITEM_FLAG_NOCUFFS                   BITFLAG(11) // Gloves that have this flag prevent cuffs being applied
#define ITEM_FLAG_CAN_HIDE_IN_SHOES         BITFLAG(12) // Items that can be hidden in shoes that permit it
#define ITEM_FLAG_PADDED                    BITFLAG(13) // When set on gloves, will act like pulling punches in unarmed combat.
#define ITEM_FLAG_CAN_TAPE                  BITFLAG(14) // Whether the item can be taped onto something using tape
#define ITEM_FLAG_IS_WEAPON                 BITFLAG(15) // Item is considered a weapon. Currently only used for force-based worth calculation.
#define ITEM_FLAG_MAGNETISED                BITFLAG(16) // When worn on feet and standing on an appropriate spot, will prevent slipping.

// Decl-level flags (/decl/var/decl_flags)
#define DECL_FLAG_ALLOW_ABSTRACT_INIT       BITFLAG(0)  // Abstract subtypes without this set will CRASH() if fetched with GET_DECL().
#define DECL_FLAG_MANDATORY_UID             BITFLAG(1)  // Requires uid to be non-null.