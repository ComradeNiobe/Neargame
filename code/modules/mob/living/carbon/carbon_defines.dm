/mob/living/carbon/
	gender = MALE
	var/datum/species/species //Contains icon generation and language information, set during New().
	//var/list/stomach_contents = list()
	var/list/datum/disease2/disease/virus2 = list()
	var/list/datum/happiness_event/events = list()
	var/antibodies = 0
	var/last_eating = 0 	//Not sure what this does... I found it hidden in food.dm

	var/life_tick = 0      // The amount of life ticks that have processed on this mob.
	var/analgesic = 0 // when this is set, the mob isn't affected by shock or pain
					  // life should decrease this by 1 every tick
	// total amount of wounds on mob, used to spread out healing and the like over all wounds
	var/number_wounds = 0
	//Surgery info
	var/datum/surgery_status/op_stage = new/datum/surgery_status
	//Active emote/pose
	var/pose = null

	var/pulse = PULSE_NORM	//current pulse level

	var/zombie = 0

	var/happiness = 0
	var/hygiene = 250
	var/size_multiplier = 1
	throw_range = 3
	var/glindcooldown = 0
	var/dom_hand = RIGHT_HAND