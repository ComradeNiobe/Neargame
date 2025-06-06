#include "core\_definitions.dm"
#include "core\byond_world_export.dm"
#include "core\core.dm"
#include "core\datum.dm"
#include "core\tgs_version.dm"

#ifdef TGS_V3_API
#include "v3210\api.dm"
#include "v3210\commands.dm"
#endif

#include "v4\api.dm"
#include "v4\commands.dm"

#include "v5\_defines.dm"
#include "v5\api.dm"
#include "v5\bridge.dm"
#include "v5\chunking.dm"
#include "v5\commands.dm"
#include "v5\serializers.dm"
#include "v5\topic.dm"
#include "v5\undefs.dm"

#include "chatcommands.dm"