/obj/random
	name = "Random Object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything


// creates a new object and deletes itself
/obj/random/New()
	..()
	if (!prob(spawn_nothing_percentage))
		spawn_item()
	del src


// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0


// creates the random item
/obj/random/proc/spawn_item()
	var/build_path = item_to_spawn()
	return (new build_path(src.loc))


/obj/random/tool
	name = "Random Tool"
	desc = "This is a random tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	item_to_spawn()
		return pick(/obj/item/screwdriver,\
					/obj/item/wirecutters,\
					/obj/item/weldingtool,\
					/obj/item/crowbar,\
					/obj/item/wrench,\
					/obj/item/device/flashlight)


/obj/random/technology_scanner
	name = "Random Scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_to_spawn()
		return pick(prob(5);/obj/item/device/t_scanner,\
					prob(2);/obj/item/device/radio/intercom,\
					prob(5);/obj/item/device/analyzer)

/obj/random/ruins_bad
	name = "Ruins loot"
	desc = "This is a random ruins loot table."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_to_spawn()
		return pick(prob(2);/obj/item/claymore/rusty,\
					prob(2);/obj/item/claymore/rusty/rapier,\
					prob(2);/obj/item/sheath,\
					prob(3);/obj/item/reagent_containers/spray/cleaner,\
					prob(3);/obj/item/reagent_containers/glass/wood,\
					prob(3);/obj/item/newspaper,\
					prob(2);/obj/item/legcuffs/bola,\
					prob(1);/obj/item/horn,\
					prob(3);/obj/item/ghettobox/special,\
					prob(3);/obj/item/flame/lighter,\
					prob(3);/obj/item/scissors,\
					prob(2);/obj/item/reagent_containers/syringe/heroin,\
					prob(3);/obj/item/reagent_containers/glass/wood,\
					prob(5);/obj/item/reagent_containers/glass/bottle/wine,\
					prob(3);/obj/item/reagent_containers/glass/beaker/stewpan,\
					prob(2);/obj/item/melee/classic_baton/club,\
					prob(3);/obj/item/kitchenknife,\
					prob(2);/obj/item/hatchet/rusty,\
					prob(1);/obj/item/melee/classic_baton/club,\
					prob(3);/obj/item/skull,\
					prob(4);/obj/item/spacecash/c1,\
					prob(2);/obj/item/claymore/copper,\
					prob(2);/obj/item/claymore/wspear,\
					prob(2);/obj/item/claymore/rusty/sabre)

/obj/random/ruins_good
	name = "Ruins loot"
	desc = "This is a random ruins loot table."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_to_spawn()
		return pick(prob(2);/obj/item/grenade/smokebomb/church,\
					prob(3);/obj/item/clothing/shoes/lw/bastard,\
					prob(2);/obj/item/clothing/head/sunhat,\
					prob(3);/obj/item/claymore/siege,\
					prob(5);/obj/item/claymore/scimitar,\
					prob(3);/obj/item/claymore/falchion,\
					prob(2);/obj/item/medal,\
					prob(5);/obj/item/spacecash/gold/c20,\
					prob(2);/obj/item/spacecash/silver/c20)

/obj/random/ruins_TNC
	name = "TNC Ruins loot"
	desc = "This is a random ruins loot table."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_to_spawn()
		return pick(prob(2);/obj/item/reagent_containers/glass/bottle/whiskey,\
					prob(2);/obj/item/folder,\
					prob(3);/obj/item/flame/lighter/zippo,\
					prob(2);/obj/item/dnainjector/hulkmut,\
					prob(3);/obj/item/desfibrilador,\
					prob(5);/obj/item/crowbar,\
					prob(3);/obj/item/storage/fancy/cigarettes,\
					prob(5);/obj/item/cell/crap/leet/noctis,\
					prob(3);/obj/item/clothing/suit/storage/vest/flakjacket,\
					prob(2);/obj/item/coupon/food,\
					prob(2);/obj/item/gun/energy/taser/leet/laser,\
					prob(2);/obj/item/gun/energy/taser/leet/legax,\
					prob(2);/obj/item/gun/projectile/automatic/pistol/magnum66,\
					prob(5);/obj/item/stack/medical/advanced/bruise_pack,\
					prob(2);/obj/item/screwdriver)


/obj/random/powercell
	name = "Random Powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_to_spawn()
		return pick(prob(10);/obj/item/cell/crap,\
					prob(40);/obj/item/cell,\
					prob(40);/obj/item/cell/high,\
					prob(9);/obj/item/cell/super,\
					prob(1);/obj/item/cell/hyper)


/obj/random/bomb_supply
	name = "Bomb Supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"
	item_to_spawn()
		return pick(/obj/item/device/assembly/igniter,\
					/obj/item/device/assembly/prox_sensor,\
					/obj/item/device/assembly/signaler)


/obj/random/toolbox
	name = "Random Toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_to_spawn()
		return pick(prob(3);/obj/item/storage/toolbox/mechanical,\
					prob(2);/obj/item/storage/toolbox/electrical,\
					prob(1);/obj/item/storage/toolbox/emergency)


/obj/random/tech_supply
	name = "Random Tech Supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(3);/obj/random/powercell,\
					prob(2);/obj/random/technology_scanner,\
					prob(1);/obj/item/stack/packageWrap,\
					prob(2);/obj/random/bomb_supply,\
					prob(1);/obj/item/extinguisher,\
					prob(1);/obj/item/clothing/gloves/fyellow,\
					prob(3);/obj/item/stack/cable_coil,\
					prob(2);/obj/random/toolbox,\
					prob(2);/obj/item/storage/belt/utility,\
					prob(5);/obj/random/tool)