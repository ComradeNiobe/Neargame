// Decl-level flags (/decl/var/decl_flags)
#define DECL_FLAG_ALLOW_ABSTRACT_INIT       BITFLAG(0)  // Abstract subtypes without this set will CRASH() if fetched with GET_DECL().
#define DECL_FLAG_MANDATORY_UID             BITFLAG(1)  // Requires uid to be non-null.