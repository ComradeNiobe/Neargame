/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. filters harmful gases from the air."
	icon_state = "gas_alt"
	flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	w_class = 3.0
	neck_use = TRUE
	item_state = "gas_mask"
	blocks_vision = TRUE
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	var/gas_d_filter_strength = 1			//For gas mask d_filters
	var/list/d_filtered_gases = list("plasma", "sleeping_agent")

/obj/item/clothing/mask/gas/d_filter_air(datum/gas_mixture/air)
	var/datum/gas_mixture/d_filtered = new

	for(var/g in d_filtered_gases)
		if(air.gas[g])
			d_filtered.gas[g] = air.gas[g] * gas_d_filter_strength
			air.gas[g] -= d_filtered.gas[g]

	air.update_values()
	d_filtered.update_values()

	return d_filtered

//Plague Dr suit can be found in clothing/suits/bio.dm
/obj/item/clothing/mask/plaguedoctor
	name = "plague doctor mask"
	desc = "A modernised version of the classic design, this mask will not only d_filter out toxins but it can also be connected to an air supply."
	icon_state = "plaguedoctor"
	item_state = "gas_mask"
	armor = list(melee = 0, bullet = 0, laser = 2,energy = 2, bomb = 0, bio = 75, rad = 0)

/obj/item/clothing/mask/gas/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7
	blocks_vision = FALSE

/obj/item/clothing/mask/gas/miltec
	name = "MILTEC mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "miltec"
	siemens_coefficient = 0.7
	blocks_vision = FALSE

/obj/item/clothing/mask/gas/church
	name = "practicus mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "hgasmask0"
	var/on_state = "hgasmask1"
	var/off_state = "hgasmask0"
	siemens_coefficient = 0.7
	wrist_use = TRUE
	flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS | BLOCKHAIR

/obj/item/clothing/mask/gas/church/veteran
	name = "veteran practicus mask"
	icon_state = "vchurch0"
	on_state = "vchurch1"
	off_state = "vchurch0"

/obj/item/clothing/mask/gas/syndicate
	name = "syndicate mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7

/obj/item/clothing/mask/gas/voice
	name = "gas mask"
	//desc = "A face-covering mask that can be connected to an air supply. It seems to house some odd electronics."
	var/mode = 0// 0==Scouter | 1==Night Vision | 2==Thermal | 3==Meson
	var/voice = "Unknown"
	var/vchange = 0//This didn't do anything before. It now checks if the mask has special functions/N
	origin_tech = "syndicate=4"

/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without his wig and mask."
	icon_state = "clown"
	item_state = "clown"

/obj/item/clothing/mask/gas/monkeymask
	name = "monkey mask"
	desc = "A mask used when acting as a monkey."
	icon_state = "monkeymask"
	item_state = "monkeymask"

/obj/item/clothing/mask/gas/owl_mask
	name = "owl mask"
	desc = "Twoooo!"
	icon_state = "owl"

/obj/item/clothing/mask/gas/jackal
	name = "jackal mask"
	desc = "Twoooo!"
	icon_state = "jackal"