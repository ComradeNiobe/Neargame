/* Stat mods can be used if you wish to make temp changes to a players stats,
or you wish to keep track of your changes and modify them as needed.
*/
datum/stat_mod
	var/list/stats = list(
	STAT_ST  = 0,
	STAT_DX  = 0,
	STAT_HT  = 0,
	STAT_IN  = 0,
	STAT_PR  = 0,
	STAT_WP  = 0,
	STAT_IM  = 0,
	STAT_SPD = 0)
	var/timeout  	= 0
	var/changed_num = 0 //Changed_num is checked when a mod timer expires. if changed_num hasn't changed, the mod is cleared.
	var/id 				//Used to check if we're not replacing a stat with an exact copy


datum/stat_mod/New(var/list/new_stats,var/time=0)
	stats = new_stats
	src.timeout = time
	make_id()

datum/stat_mod/proc/make_id()
	id = stats[STAT_ST] | stats[STAT_HT] | stats[STAT_DX] | stats[STAT_IN] | stats[STAT_WP] | stats[STAT_PR] | stats[STAT_IM]

//Applies the stat mods.
/datum/stat_holder/proc/apply_mod(var/datum/stat_mod/mod,negative = FALSE)
	if(negative)
		for(var/i in 1 to TOTAL_STATS)
			stats[i] -= mod.stats[i]
		return
	for(var/i in 1 to TOTAL_STATS)
		stats[i] += mod.stats[i]

//Creates a new stat mod, (this works like the mood system)
//Example: M.my_stats.add_mod("id", new(DX = -3))
/datum/stat_holder/proc/add_mod(category, var/list/new_stats, var/time=0, var/override = TRUE, var/override_timer = TRUE)
	var/datum/stat_mod/the_mod = new(new_stats, time)
	var/inital = TRUE
	if(stat_mods[category]) //If there's already a stat in the category.
		inital = FALSE
		if(override)
			if(stat_mods[category].id == the_mod.id)
				if(override_timer)
					the_mod.changed_num = stat_mods[category].changed_num++
				return
			if(override_timer)
				the_mod.changed_num = stat_mods[category].changed_num++
			apply_mod(stat_mods[category],TRUE) //Clear the old stat mod changes.
			stat_mods[category] = the_mod
		else if(!override) //If the stat is not being overriden, increase its values by the new mod.
			apply_mod(stat_mods[category],TRUE)
			for(var/i in 1 to TOTAL_STATS)
				stat_mods[category].stats[i] += the_mod.stats[i]
			stat_mods[category].make_id()
			if(override_timer)
				stat_mods[category].timeout = the_mod.timeout
				stat_mods[category].changed_num++ //So the old timer won't remove the event.
			else if(the_mod.timeout > 0)
				stat_mods[category].timeout += the_mod.timeout
				stat_mods[category].changed_num++ //So the old timer won't remove the event.

	else
		stat_mods[category] = the_mod

	apply_mod(stat_mods[category]) //Applies the stat mod.

	if(the_mod.timeout && (override_timer || inital))
		var/mod_changed = stat_mods[category].changed_num
		spawn(the_mod.timeout)
			if(stat_mods[category] != null)
				if(mod_changed == stat_mods[category].changed_num)
					clear_mod(category)

//Clears the stat mod under the given category.
/datum/stat_holder/proc/clear_mod(category)
	if(!stat_mods[category])
		return
	apply_mod(stat_mods[category],TRUE)
	stat_mods -= category

//helper for one line stat mods.
/proc/stat_list(var/ST = 0, var/DX = 0, var/HT = 0, var/IN = 0, var/PR = 0, var/IM = 0, var/WP = 0, var/SPD = 0)
	var/list/stats = list(
	STAT_ST  = ST,
	STAT_DX  = DX,
	STAT_HT  = HT,
	STAT_IN  = IN,
	STAT_PR  = PR,
	STAT_WP  = IM,
	STAT_IM  = WP,
	STAT_SPD = SPD)
	return stats