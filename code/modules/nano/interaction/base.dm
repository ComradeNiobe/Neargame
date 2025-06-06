/datum/proc/nano_host()
	return src

/datum/proc/nano_container()
	return src

/datum/proc/CanUseTopic(var/mob/user, var/datum/topic_state/state = global.default_topic_state)
	var/datum/src_object = nano_host()
	return state.can_use_topic(src_object, user)

/mob/CanUseTopic(mob/user, datum/topic_state/state, href_list)
	if(href_list && href_list["flavor_more"])
		return STATUS_INTERACTIVE
	return ..()

/datum/proc/CanUseTopicPhysical(mob/user)
	return CanUseTopic(user, global.physical_topic_state)

/datum/topic_state
	var/check_access = TRUE // Whether this topic state should bypass access checks or not.

/datum/topic_state/proc/can_use_topic(var/src_object, var/mob/user)
	return STATUS_CLOSE

/mob/proc/shared_nano_interaction()
	if (src.stat || !client)
		return STATUS_CLOSE						// no updates, close the interface
	else if (incapacitated())
		return STATUS_UPDATE					// update only (orange visibility)
	return STATUS_INTERACTIVE