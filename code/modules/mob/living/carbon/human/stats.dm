/datum/stat
	var/name = "Stat"
	var/desc = "Gurps desc"
	var/value = BASE_STAT_VALUE
	var/list/mods = list()
	var/basic = TRUE
	var/show = TRUE

/datum/stat/st
	name = STAT_ST
	desc = "Strength measures physical power and bulk. It is crucial if you are a warrior in a primitive world, as high ST lets you dish out and absorb more damage in hand-to-hand combat. \
				Any adventurer will find ST useful for lifting and throwing things, moving quickly with a load, etc."

/datum/stat/dx
	name = STAT_DX
	desc = "Dexterity measures a combination of agility, coordination, and fine motor ability. \
				It controls your basic ability at most athletic, fighting, and vehicle-operation skills, and at craft skills that call for a delicate touch."
/datum/stat/ht
	name = STAT_HT
	desc = "Health measures energy and vitality. It represents stamina, resistance (to poison, disease, radiation, etc.), and basic “grit”."

/datum/stat/iq
	name = STAT_IN
	desc = "Intelligence broadly measures brainpower, including creativity, intuition, memory, perception, reason, sanity, and willpower. \
				It rules your basic ability with all “mental” skills – sciences, social interaction, magic, etc."

/datum/stat/pr
	name = STAT_PR
	desc = "Perception represents your general alertness. \
				The GM makes a “Sense roll” against your Per to determine whether you notice something (see Sense Rolls, p. 358). \
				By default, Per equals IQ, but you can increase it for 5 points per +1, or reduce it for -5 points per -1."
	basic = FALSE

/datum/stat/wp
	name = STAT_WP
	desc = "We don't talk about willpower."
	basic = FALSE

/datum/stat/im
	name = STAT_IM
	desc = "IM = HT, but it can be modified."
	basic = FALSE

/datum/stat/spd
	name = STAT_SPD
	desc = "Your Basic Speed is a measure of your reflexes and general physical quickness. \
				It helps determine your running speed (see Basic Move, below), your chance of dodging an attack, \
				and the order in which you act in combat (a high Basic Speed will let you “out-react” your foes)."
	basic = FALSE
	show = FALSE

/datum/stat/proc/ADD_MOD(var/mod_time, var/mod_value, var/mod_id, var/add_value)
	if(mod_id in mods)
		var/datum/stat_mod/M = mods[mod_id]

		if(mod_time == INFINITY)
			M.time = -1
		else
			M.time = world.time + mod_time

		if(add_value)
			M.value += mod_value

		return FALSE
	mods[mod_id] = new /datum/stat_mod(mod_time, mod_value, mod_id)
	return TRUE

/datum/stat/proc/REMOVE_MOD(var/mod_id)
	if(mod_id in mods)
		mods.Remove(mod_id)
		return TRUE
	return FALSE

/datum/stat/proc/GET_MOD(var/mod_id)
	if(mod_id in mods)
		var/datum/stat_mod/M = mods[mod_id]
		return M
	return FALSE

/datum/stat/proc/CHANGE_VALUE(var/mod_value)
	value += mod_value
	return value

/datum/stat/proc/GET_VALUE(var/pure = FALSE)
	var/ret_value = value
	if(!pure)
		for(var/mod_id in mods)
			var/datum/stat_mod/M = mods[mod_id]
			if(M.time != -1 && M.time < world.time)
				mods.Remove(mod_id)
				qdel(M)
				continue
			ret_value += M.value
	return ret_value

/datum/stat/proc/SET_VALUE(var/new_value)
	value = new_value
	return value

/datum/stat/proc/update_mods()
	for(var/mod_id in mods)
		var/datum/stat_mod/M = mods[mod_id]
		if(M.time != -1 && M.time < world.time)
			mods.Remove(mod_id)
			qdel(M)
			continue

/datum/stat_mod
	var/time = 0
	var/value = 0
	var/id

/datum/stat_mod/New(var/mod_time, var/mod_value, var/mod_id)
	if(mod_time == INFINITY)
		time = -1
	else
		time = world.time + mod_time
	value = mod_value
	id = mod_id