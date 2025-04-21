/**
	This state checks if src_object is held in the user's hands (or a cyborg gripper),
	as well as the default NanoUI interaction.
**/
/// ! This currently doesn't work until we update how inventory slots are handled.
var/global/datum/topic_state/hands/hands_topic_state = new

/datum/topic_state/hands/can_use_topic(src_object, mob/user)
	. = user.shared_nano_interaction(src_object)
	if(. > STATUS_CLOSE)
		. = min(., user.hands_can_use_topic(src_object))

/mob/proc/hands_can_use_topic(src_object)
	return STATUS_CLOSE

/mob/living/hands_can_use_topic(src_object)
	if(src_object in get_held_items())
		return STATUS_INTERACTIVE
	return STATUS_CLOSE
