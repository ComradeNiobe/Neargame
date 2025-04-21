/*
	This state checks that the src_object is in view of the user.
*/
var/global/datum/topic_state/view/view_topic_state = new

/datum/topic_state/view/can_use_topic(src_object, mob/user)
	return user.view_can_use_topic(src_object)

/mob/proc/view_can_use_topic(src_object)
	if(!client)
		return STATUS_CLOSE
	if(src_object in view(client.view, src))
		return shared_nano_interaction(src_object)
	return STATUS_CLOSE

/mob/observer/ghost/view_can_use_topic(var/src_object)
	if(can_admin_interact())
		return STATUS_INTERACTIVE
	return ..()
