var/global/datum/topic_state/default/default_topic_state = new

/datum/topic_state/default/can_use_topic(var/src_object, var/mob/user)
	return user.default_can_use_topic(src_object)

/mob/proc/default_can_use_topic(var/src_object)
	return STATUS_CLOSE // By default no mob can do anything with NanoUI

/mob/observer/ghost/default_can_use_topic(var/src_object)
	if(can_admin_interact())
		return STATUS_INTERACTIVE							// Admins are more equal
	if(!client || get_dist(src_object, src)	> get_effective_view(client))	// Preventing ghosts from having a million windows open by limiting to objects in range
		return STATUS_CLOSE
	return STATUS_UPDATE									// Ghosts can view updates

//Some atoms such as vehicles might have special rules for how mobs inside them interact with NanoUI.
/atom/proc/contents_nano_distance(var/src_object, var/mob/living/user)
	return user.shared_living_nano_distance(src_object)

/mob/living/proc/shared_living_nano_distance(var/atom/movable/src_object)
	if (!(src_object in view(4, src))) 	// If the src object is not visable, disable updates
		return STATUS_CLOSE

	var/dist = get_dist_bounds(src_object, src)
	if (dist <= 1 || (src_object.loc == src)) // interactive (green visibility)
		// Checking adjacency even when distance is 0 because get_dist() doesn't include Z-level differences and
		// the client might have its eye shifted up/down thus putting src_object in view.
		return Adjacent(src_object) ? STATUS_INTERACTIVE : STATUS_UPDATE
	else if (dist <= 2)
		return STATUS_UPDATE 		// update only (orange visibility)
	else if (dist <= 4)
		return STATUS_DISABLED 		// no updates, completely disabled (red visibility)
	return STATUS_CLOSE

/mob/living/default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != STATUS_CLOSE)
		if(loc)
			. = min(., loc.contents_nano_distance(src_object, src))
	if(. == STATUS_INTERACTIVE)
		return STATUS_UPDATE

/mob/living/human/default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != STATUS_CLOSE)
		if(loc)
			. = min(., loc.contents_nano_distance(src_object, src))
		else
			. = min(., shared_living_nano_distance(src_object))
		//if(. == STATUS_UPDATE && is_telekinetic())
		//	return STATUS_INTERACTIVE
