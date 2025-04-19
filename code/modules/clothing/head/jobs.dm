
//Bartender

/obj/item/clothing/head/furhat
	name = "fur hat"
	desc = ""
	icon_state = "hatfur"
	item_state = "hatfur"
	flags = FPRINT | TABLEPASS
	cold_protection = HEAD

/obj/item/clothing/head/chefhat
	name = "chef's hat"
	desc = "It's a hat used by chefs to keep hair out of your food. Judging by the food in the mess, they don't work."
	icon_state = "chef"
	item_state = "chef"
	flags = FPRINT | TABLEPASS
	siemens_coefficient = 0.9

/obj/item/clothing/head/obard
	name = "noble's hat"
	desc = ""
	icon_state = "obard"
	flags = FPRINT | TABLEPASS
	cold_protection = HEAD

/obj/item/clothing/head/minitophat
	name = "mini tophat"
	desc = ""
	icon_state = "minitop"
	item_state = "minitop"
	flags = FPRINT | TABLEPASS
	cold_protection = HEAD

/obj/item/clothing/head/headband
	name = "headband"
	desc = ""
	icon_state = "headband"
	item_state = "headband"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/sunhat
	name = "sunhat"
	desc = "It's fashionable, but without a sun, that's about all it's good for."
	icon_state = "healerhat"// "sunhat" doesn't seem to exist.
	item_state = "sunhat"
	flags = FPRINT | TABLEPASS
	cold_protection = HEAD

/obj/item/clothing/head/smokingcap
	name = "smoking cap"
	desc = ""
	icon_state = "smokingc"
	item_state = "smokingc"
	flags = FPRINT | TABLEPASS
	cold_protection = HEAD


/obj/item/clothing/head/donor/redvent/tatteredhood
	name = "tattered hood"
	desc = "An black hood with a couple of big-ass holes on the side. It looks like it might originally have been used for target practice.."
	icon_state = "castigation"
	item_state = "castigation"
	flags = FPRINT | TABLEPASS
	cold_protection = HEAD

/obj/item/clothing/head/healer
	name = "healer hat"
	desc = "Commonly worn by wandering healers."
	icon_state = "healerhat"
	item_state = "healerhat"
	flags = FPRINT | TABLEPASS
	cold_protection = HEAD
	item_worth = 0

/obj/item/clothing/head/misero
	name = "dirty hat"
	icon_state = "sny"
	desc = "Yo!"
	flags = FPRINT|TABLEPASS
	item_state = "sny"
	siemens_coefficient = 0.9

/obj/item/rag
	name = "damp rag"
	desc = "For cleaning up messes, you suppose."
	w_class = 1
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"

/obj/item/rag/afterattack(atom/A as turf, mob/living/carbon/human/user as mob, proximity)
	if(!proximity) return
	if(istype(A, /turf) && src in user)
		user.visible_message("<span class='passive'>[user] starts to wipe down [A] with [src]!</span>")
		var/cleancheck
		if(user.my_skills.get_skill(SKILL_CLEAN) >= 1)
			cleancheck = user.my_skills.get_skill(SKILL_CLEAN) * 2
		var/cleanskill = max(0, 18 - cleancheck)
		if(do_after(user,cleanskill))
			user.visible_message("<span class='passive'>[user] finishes wiping off the [A]!</span>")
			A.clean_blood()
			for(var/atom/B in A.contents)
				if(B.cleanable)
					qdel(B)
			return
	return

/obj/item/clothing/head/papakha
	name = "fancy hat"
	icon_state = "papakha"
	desc = "Yo!"
	flags = FPRINT|TABLEPASS
	item_state = "papakha"
	siemens_coefficient = 0.9

/obj/item/clothing/head/inquisihat
	name = "Inquisitor hat"
	icon_state = "inqhat"
	desc = "Nobody expects the inquisition."
	flags = FPRINT|TABLEPASS
	item_state = "inqhat"
	siemens_coefficient = 0.9

/obj/item/clothing/head/inqcap
	name = "Inquisitor Cap"
	icon_state = "inqhat"
	desc = "Nobody expects the inquisition."
	flags = FPRINT|TABLEPASS
	item_state = "inqhat"
	siemens_coefficient = 0.9


/obj/item/clothing/head/witchhunter
	name = "Witch Hunter hat"
	icon_state = "witchhunter"
	desc = "Nobody expects the inquisition."
	flags = FPRINT|TABLEPASS
	item_state = "witchhunter"
	siemens_coefficient = 0.9

/obj/item/clothing/head/inkvdhat
	name = "INKVD hat"
	icon_state = "witchhunter"
	desc = "Nobody expects the inquisition."
	flags = FPRINT|TABLEPASS
	item_state = "witchhunter"
	siemens_coefficient = 0.9

/obj/item/clothing/head/hood
	name = "Hood"
	icon_state = "hood"
	desc = "For protecting your identity in summary executions."
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = HEAD|FACE|MOUTH|THROAT
	item_state = "hood"
	siemens_coefficient = 0.9

/obj/item/clothing/head/sunshinehat
	name = "Solar spiral hat"
	icon_state = "sunshinehat"
	desc = "You are my sunshine, my dear."
	flags = FPRINT|TABLEPASS
	item_state = "sunshinehat"
	siemens_coefficient = 0.9

/obj/item/clothing/head/hunter
	name = "Hunter hat"
	icon_state = "hunterhat"
	desc = "Saint Peter once said, 'You are my sunshine.'."
	flags = FPRINT|TABLEPASS
	item_state = "hunterhat"
	siemens_coefficient = 0.9

/obj/item/clothing/head/magistrate
	name = "Magistrates hat"
	icon_state = "hunterhat"
	desc = "The herald of justice."
	flags = FPRINT|TABLEPASS
	item_state = "hunterhat"
	siemens_coefficient = 0.9

/obj/item/clothing/head/blackbag
	name = "blackbag"
	icon_state = "bag"
	desc = "Nobody expects the black bag."
	flags = FPRINT|TABLEPASS|HIDEFACE|BLOCKHAIR|HEADCOVERSEYES|HEADCOVERSMOUTH
	item_state = "kbag"
	siemens_coefficient = 0.9
	wrist_use = TRUE

/obj/item/clothing/head/blackbag/afterattack(atom/A as turf, mob/living/carbon/human/user as mob, proximity)
	if(!proximity) return
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.head)
			var/obj/item/HAT = H.head
			if(istype(HAT, /obj/item/clothing/head/helmet))
				return
			else
				H.drop_from_inventory(HAT)
		user.drop_from_inventory(user.get_active_hand())
		H.equip_to_slot_or_del(src, slot_head)
		H.update_icons()
		H.emote("torturescream",1, null, 0)
		H.handle_regular_hud_updates()
	return


/obj/item/clothing/head/blackbag/equipped(mob/M,var/slot)
	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M
	if(slot == slot_head)
		H.eye_closed = TRUE
		H.blinded = 100
		H.client?.screen += global_hud?.blind
		H.handle_regular_hud_updates()

	else
		H.client?.screen -= global_hud?.blind
		H.eye_closed = FALSE
		H.blinded = initial(H.blinded)
		H.handle_regular_hud_updates()


/obj/item/clothing/head/misero/afterattack(atom/A as turf, mob/living/carbon/human/user as mob, proximity)
	if(!proximity) return
	if(istype(A, /turf) && src in user)
		user.visible_message("[user] starts to wipe down [A] with [src]!")
		var/cleancheck
		if(user.my_skills.get_skill(SKILL_CLEAN) >= 1)
			cleancheck = user.my_skills.get_skill(SKILL_CLEAN) * 2
		var/cleanskill = max(0, 18 - cleancheck)
		if(do_after(user,cleanskill))
			user.visible_message("[user] finishes wiping off the [A]!")
			A.clean_blood()
			for(var/atom/B in A.contents)
				if(B.cleanable)
					qdel(B)
	return

var/obj/item/fortCrown = null
//Captain: This probably shouldn't be space-worthy
/obj/item/clothing/head/caphat
	name = "crown of the oath"
	icon_state = "cavecrown"
	desc = "An ancient crown originally given to the Baron by Enoch himself."
	flags = FPRINT|TABLEPASS
	item_state = "cavecrown"
	siemens_coefficient = 0.9
	item_worth = 640

/obj/item/clothing/head/lordcrown
	name = "cave crown"
	icon_state = "crown"
	desc = "A crown of teeth and bone."
	flags = FPRINT|TABLEPASS
	item_state = "crown"
	siemens_coefficient = 0.9
	item_worth = 128

/obj/item/clothing/head/caphat/New()
	fortCrown = src
	..()
/obj/item/clothing/head/expedleader
	name = "Expedition Leader hat"
	icon_state = "captain"
	desc = "It's good being the leader."
	flags = FPRINT|TABLEPASS
	item_state = "captain"
	siemens_coefficient = 0.9
	item_worth = 16

//Chaplain
/obj/item/clothing/head/chaplain_hood
	name = "chaplain's hood"
	desc = "It's hood that covers the head. It keeps you warm during the space winters."
	icon_state = "chaplain_hood"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR
	siemens_coefficient = 0.9

/obj/item/clothing/head/nun_hood
	name = "nun hood"
	desc = ""
	icon_state = "nun"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR
	siemens_coefficient = 0.9

/obj/item/clothing/head/plebhood
	name = "neck guard"
	desc = "Leather neck guard."
	icon_state = "plebhood"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	armor = list(melee = 10, bullet = 2, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	item_worth = 12

/obj/item/clothing/head/eunuch
	name = "eunuch hat"
	icon_state = "tjubeteika"
	flags = FPRINT|TABLEPASS
	siemens_coefficient = 0.9
	item_worth = 4

/obj/item/clothing/head/chaperon
	name = "chaperon"
	desc = "Leather chaperon."
	icon_state = "chaperon"
	flags = FPRINT|TABLEPASS
	siemens_coefficient = 0.9
	armor = list(melee = 12, bullet = 2, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	item_worth = 6

/obj/item/clothing/head/peasant
	name = "peasant hood"
	desc = "A simple hood worn by peasants"
	icon_state = "pea1sant"
	item_state = "pea1sant"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/armingcap
	name = "arming cap"
	desc = "A leather arming cap."
	icon_state = "armingcap"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	siemens_coefficient = 0.9
	armor = list(melee = 18, bullet = 2, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	item_worth = 5

/obj/item/clothing/head/fisherhat
	name = "fisher hat"
	icon_state = "fisherhat"
	desc = "Nice night for fishin', innit?"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	siemens_coefficient = 0.9
	item_worth = 5


/obj/item/clothing/head/plebhood/leper
	icon_state = "leper"


/obj/item/clothing/head/cap
	name = "flat cap"
	desc = "A flat cap."
	icon_state = "johngrey"
	flags = FPRINT | TABLEPASS
	siemens_coefficient = 0.9
	body_parts_covered = HEAD

/obj/item/clothing/head/jester_hat
	name = "jester hat"
	icon_state = "jester"
	item_color = "jester"
	species_restricted = list("Midget")

/obj/item/clothing/head/jester_court
	name = "jester hat"
	icon_state = "ojester"
	item_color = "jester_court"
	flags = FPRINT | TABLEPASS | BLOCKHAIR