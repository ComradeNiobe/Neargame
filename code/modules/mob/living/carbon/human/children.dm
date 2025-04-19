/datum/species/human/child //Oh lord here we go.
	name = "Child"
	name_plural = "Children"
	total_health = 80 //Kids are weaker than adults.
	min_age = 10
	max_age = 14
	icobase = 'icons/mob/flesh/old/human_child_old.dmi'
	deform = 'icons/mob/human_races/child/r_def_child.dmi'
	genitals = FALSE

/datum/species/human/child/handle_post_spawn(var/mob/living/carbon/human/H)
	H.mutations.Cut()
	H.pixel_y = -4
	H.age = rand(min_age,max_age)//Random age for kiddos.
	if(H.has_vice("Sexoholic") || H.has_vice("Necrophile") || H.has_vice("Voyeur"))//Kids ain't having sex vices please, thank you.
		H.vice = "Kleptomaniac"
	if(H.f_style)//Children don't get beards.
		H.f_style = "Shaved"
	to_chat(H, "<span class='info'><big>I'm [H.age] years old! Hooray!</big></span>")
	return ..()

/mob/living/carbon/human/child
	name = "Child"

/mob/living/carbon/human/child/New()
	set_species("Child")
	..()

/obj/item/clothing/under/child_jumpsuit
	name = "scullion's uniform"
	desc = "Fitted just for kids."
	icon_state = "grey"
	item_color = "child_grey"
	species_restricted = list("Child")
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/under/urchin
	name = "urchin's uniform"
	desc = "Fitted just for kids."
	icon_state = "urchin"
	item_color = "urchin"
	species_restricted = list("Child")
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/eye
	name = "children's coat"
	desc = "Consiglieri's Eye coat."
	icon_state = "kidcoat"
	item_color = "kidcoat"
	species_restricted = list("Child")

/obj/item/clothing/suit/scuff
	name = "scuff's coat"
	desc = "jew"
	icon_state = "rugged"
	item_color = "rugged"
	species_restricted = list("Child")
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/fackid
	name = "child worker's coat"
	desc = "jew"
	icon_state = "rugged"
	item_color = "rugged"
	species_restricted = list("Child")
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/yapron
	name = "child apron"
	desc = "The regular apprentice attire."
	icon_state = "yapron"
	item_color = "yapron"
	species_restricted = list("Child")

/obj/item/clothing/suit/disciple
	name = "meister's disciple garments"
	desc = "The regular disciple attire."
	icon_state = "disciple"
	item_color = "disciple"
	species_restricted = list("Child")

/obj/item/clothing/suit/armor/vest/squire
	name = "squire's armor"
	desc = ""
	icon_state = "squire"
	item_color = "squire"
	species_restricted = list("Child")
	armor = list(melee = 35, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	weight = 12
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	armor_type = ARMOR_METAL

/obj/item/clothing/suit/armor/vest/ytriton
	name = "child triton armor"
	desc = "An armored coat of armor worn by members of the Triton Guard."
	icon_state = "tritonc"
	item_state = "triton"
	species_restricted = list("Child")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS|LEGS_TOGETHER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 31
	weight = 45
	armor_type = ARMOR_METAL


/obj/item/clothing/suit/armor/vest/ycensor
	name = "child kraken armor"
	desc = ""
	icon_state = "ycensor"
	item_color = "ycensor"
	species_restricted = list("Child")
	armor = list(melee = 70, bullet = 45, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	weight = 28
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	armor_type = ARMOR_METAL