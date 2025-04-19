//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

var/list/all_supply_groups = list("Weapons", "Clothing", "Ammo","Hospitality","Engineering","Medical / Science","Food")

/datum/supply_packs
	var/name = null
	var/list/contains = list()
	var/manifest = ""
	var/amount = null
	var/cost = null
	var/containertype = null
	var/containername = null
	var/access = null
	var/hidden = 0
	var/contraband = 0
	var/is_weapon = FALSE
	var/group = "Operations"

/datum/supply_packs/New()
	manifest += "<ul>"
	if(!access)
		access = "[merchant]"
	for(var/path in contains)
		if(!path)	continue
		var/atom/movable/AM = new path()
		manifest += "<li>[AM.name]</li>"
		AM.loc = null	//just to make sure they're deleted by the garbage collector
	manifest += "</ul>"


// FOOD
/datum/supply_packs/spices
	name = "Exotic Spices"
	contains = list(/obj/item/reagent_containers/food/snacks/lw/exotic,
					/obj/item/reagent_containers/food/snacks/lw/exotic,
					/obj/item/reagent_containers/food/snacks/lw/exotic,
					/obj/item/reagent_containers/food/snacks/lw/exotic,
					/obj/item/reagent_containers/food/snacks/lw/exotic)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Food crate"
	group = "Food"


/datum/supply_packs/salt
	name = "Salt Block"
	contains = list(/obj/item/reagent_containers/food/snacks/lw/salt,
					/obj/item/reagent_containers/food/snacks/lw/salt,
					/obj/item/reagent_containers/food/snacks/lw/salt,
					/obj/item/reagent_containers/food/snacks/lw/salt,
					/obj/item/reagent_containers/food/snacks/lw/salt)
	cost = 14
	containertype = /obj/structure/closet/crate/secure
	containername = "Food crate"
	group = "Food"


/datum/supply_packs/food
	name = "Imported Meat"
	contains = list(/obj/item/reagent_containers/food/snacks/meat,
	/obj/item/reagent_containers/food/snacks/meat,
	/obj/item/reagent_containers/food/snacks/meat,
	/obj/item/reagent_containers/food/snacks/meat,
	/obj/item/reagent_containers/food/snacks/meat)
	cost = 64
	containertype = /obj/structure/closet/crate/secure
	containername = "Meat crate"
	group = "Food"

/datum/supply_packs/beer
	name = "Salar Wheat (3)"
	contains = list(/obj/item/reagent_containers/glass/bottle/beer,/obj/item/reagent_containers/glass/bottle/beer,/obj/item/reagent_containers/glass/bottle/beer)
	cost = 8
	containertype = /obj/structure/closet/crate/secure
	containername = "Beer crate"
	group = "Food"

/datum/supply_packs/bitterbeer
	name = "Bitter Old Bastard (3)"
	contains = list(/obj/item/reagent_containers/glass/bottle/bitterbastard,/obj/item/reagent_containers/glass/bottle/bitterbastard,/obj/item/reagent_containers/glass/bottle/bitterbastard)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Bitter Old Bastard crate"
	group = "Food"

/datum/supply_packs/rahalbeer
	name = "Rahallian Kriek (3)"
	contains = list(/obj/item/reagent_containers/glass/bottle/bitterbastard,/obj/item/reagent_containers/glass/bottle/bitterbastard,/obj/item/reagent_containers/glass/bottle/bitterbastard)
	cost = 14
	containertype = /obj/structure/closet/crate/secure
	containername = "Rahallian Kriek crate"
	group = "Food"

// CLOTHING
/datum/supply_packs/satchels
	name = "Satchels (3)"
	contains = list(/obj/item/storage/backpack/satchel,/obj/item/storage/backpack/satchel,/obj/item/storage/backpack/satchel)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "Satchels crate"
	group = "Clothing"
/*
/datum/supply_packs/fancyhats
	name = "Fancy Hats"
	contains = list(/obj/item/clothing/head/chaperon, /obj/item/clothing/head/cargohat, /obj/item/clothing/head/pillbox, /obj/item/clothing/head/fedora, /obj/item/clothing/head/flatcap, /obj/item/clothing/head/ushanka, /obj/item/clothing/head/that)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "Fancy Hats crate"
	group = "Clothing"

/datum/supply_packs/fancyhats
	name = "Noble Hats"
	contains = list(/obj/item/clothing/head/tarphat, /obj/item/clothing/head/noblehat, /obj/item/clothing/head/greentricorn, /obj/item/clothing/head/leathertricorn, /obj/item/clothing/head/escoffion1, /obj/item/clothing/head/escoffion2)
	cost = 80
	containertype = /obj/structure/closet/crate/secure
	containername = "Noble Hats crate"
	group = "Clothing"
*/
// On ice until fixed.

/datum/supply_packs/coldpack
	name = "Coldpack Backpack"
	contains = list(/obj/item/storage/backpack/coldpack)
	cost = 32
	containertype = /obj/structure/closet/crate/secure
	containername = "Cold Pack crate"
	group = "Clothing"

/datum/supply_packs/beltsatchel
	name = "Belt Satchels crate (4)"
	contains = list(/obj/item/storage/backpack/beltsatchel,/obj/item/storage/backpack/beltsatchel,/obj/item/storage/backpack/beltsatchel,/obj/item/storage/backpack/beltsatchel)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Belt Satchels crate"
	group = "Clothing"

/datum/supply_packs/clothing
	name = "Imported Clothes (5)"
	contains = list(/obj/item/clothing/under/rank/security, /obj/item/clothing/under/common/smith,/obj/item/clothing/under/common,/obj/item/clothing/under/rank/hydroponics,/obj/item/clothing/under/rank/hydroponics)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Clothing Crate"
	group = "Clothing"

/datum/supply_packs/armor
	name = "Munition-Grade Armor"
	contains = list(/obj/item/clothing/suit/armor/vest/iron_cuirass, /obj/item/clothing/shoes/lw/iron, /obj/item/clothing/gloves/combat/gauntlet/steel, /obj/item/clothing/head/helmet/lw/openskulliron)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Armor Crate"
	group = "Clothing"

/datum/supply_packs/flak
	name = "Tribunal Reservist Gear"
	contains = list(/obj/item/clothing/suit/storage/vest/flakjacket/old, /obj/item/clothing/shoes/lw/iron, /obj/item/clothing/head/helmet/lw/ordinator/old)
	cost = 70
	containertype = /obj/structure/closet/crate/secure
	containername = "Armor Crate"
	group = "Clothing"

/*
/datum/supply_packs/hound
	name = "Old Hound Armor"
	contains = list(/obj/item/clothing/suit/armor/vest/security/cerberus, /obj/item/clothing/shoes/lw/iron, /obj/item/clothing/head/helmet/sechelm/cerbhelm)
	cost = 100
	containertype = /obj/structure/closet/crate/secure
	containername = "Armor Crate"
	group = "Clothing"
*/ // Disabled until fixed

/datum/supply_packs/alchemy
	name = "All-Enviroment Biosuit"
	contains = list(/obj/item/clothing/suit/bio_suit,
					/obj/item/clothing/head/bio_hood,
					/obj/item/clothing/mask/bee
					)
	cost = 128
	containertype = /obj/structure/closet/crate/secure
	containername = "Pcheloved suit"
	group = "Clothing"

/datum/supply_packs/coin_bags
	name = "Coin Bags (3)"
	contains = list(/obj/item/storage/backpack/coinbag, /obj/item/storage/backpack/coinbag, /obj/item/storage/backpack/coinbag)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "coin bags crate"
	group = "Clothing"

/datum/supply_packs/sheath
	name = "sheath crate"
	contains = list(/obj/item/sheath, /obj/item/sheath, /obj/item/sheath, /obj/item/sheath)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "sheath crate"
	group = "Clothing"

/datum/supply_packs/bracelets
	name = "Bracelets (x3)"
	contains = list(/obj/item/device/radio/headset/bracelet,/obj/item/device/radio/headset/bracelet,/obj/item/device/radio/headset/bracelet)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "Bracelets (x3)"
	group = "Clothing"

// Hospitality
/datum/supply_packs/cigar
	name = "Imported Smokes (3)"
	contains = list(/obj/item/storage/fancy/cigarettes,/obj/item/storage/fancy/cigarettes,/obj/item/storage/fancy/cigarettes)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "Cigarretes crate"
	group = "Hospitality"

/datum/supply_packs/boombosta
	name = "Boombox (1)"
	contains = list(/obj/item/ghettobox)
	cost = 100
	containertype = /obj/structure/closet/crate/secure
	containername = "Ghettobox crate"
	group = "Hospitality"

/datum/supply_packs/lighter
	name = "Disposable Lighters (6)"
	contains = list(/obj/item/flame/lighter,/obj/item/flame/lighter,/obj/item/flame/lighter,/obj/item/flame/lighter,/obj/item/flame/lighter,/obj/item/flame/lighter)
	cost = 12
	containertype = /obj/structure/closet/crate/secure
	containername = "Lighter crate"
	group = "Hospitality"

/datum/supply_packs/flashlight
	name = "Flashlight"
	contains = list(/obj/item/device/flashlight)
	cost = 16
	containertype = /obj/structure/closet/crate/secure
	containername = "flashlight crate"
	group = "Hospitality"

/datum/supply_packs/paper
	name = "paper crate"
	contains = list(/obj/item/paper,/obj/item/paper,/obj/item/paper,/obj/item/paper,/obj/item/paper,/obj/item/paper,/obj/item/paper)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "paper crate"
	group = "Hospitality"

/datum/supply_packs/sleepingbag
	name = "Sleeping Bags (x2)"
	contains = list(/obj/item/sleepingbag,/obj/item/sleepingbag)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Sleeping Bags"
	group = "Hospitality"

/datum/supply_packs/adultmagazines
	name = "Adult Magazines (x3)"
	contains = list(/obj/item/adultmag/one,/obj/item/adultmag/two,/obj/item/adultmag/three)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "Adult Magazines"
	group = "Hospitality"

/datum/supply_packs/ticket
	name = "Ticket to the Vinfort"
	contains = list(/obj/item/clothing/head/amulet/ticket)
	cost = 100
	containertype = /obj/structure/closet/crate/secure
	containername = "Ticket crate"
	group = "Hospitality"


// Engineering

/datum/supply_packs/wood
	name = "Imported Wood (6)"
	contains = list(/obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "wood crate"
	group = "Hospitality"

/datum/supply_packs/iron_crate
	name = "Iron Ore (3)"
	contains = list(/obj/item/ore/lw/ironlw, /obj/item/ore/lw/ironlw, /obj/item/ore/lw/ironlw)
	cost = 24
	containertype = /obj/structure/closet/crate/secure
	containername = "iron ore crate"
	group = "Engineering"

/datum/supply_packs/copper_crate
	name = "Copper Ore (3)"
	contains = list(/obj/item/ore/lw/copperlw, /obj/item/ore/lw/copperlw, /obj/item/ore/lw/copperlw)
	cost = 6
	containertype = /obj/structure/closet/crate/secure
	containername = "cppper ore crate"
	group = "Engineering"

/datum/supply_packs/coal_crate
	name = "coal crate (3)"
	contains = list(/obj/item/ore/lw/coal, /obj/item/ore/lw/coal, /obj/item/ore/lw/coal)
	cost = 18
	containertype = /obj/structure/closet/crate/secure
	containername = "coal crate"
	group = "Engineering"

/datum/supply_packs/silver_crate
	name = "silver Ore <2>"
	contains = list(/obj/item/ore/lw/silverlw, /obj/item/ore/lw/silverlw)
	cost = 32
	containertype = /obj/structure/closet/crate/secure
	containername = "silver ore crate"
	group = "Engineering"

/datum/supply_packs/batteries
	name = "Empty Lifeweb Energy-cell <3x>"
	contains = list(/obj/item/cell/web/empty,/obj/item/cell/web/empty,/obj/item/cell/web/empty)
	cost = 300
	containertype = /obj/structure/closet/crate/secure
	containername = "Batteries crate"
	group = "Engineering"

/datum/supply_packs/internals
	name = "Gas-Attack Surival Kit"
	contains = list(/obj/item/clothing/mask/gas, /obj/item/tank/air)
	cost = 32
	containertype = /obj/structure/closet/crate/secure
	containername = "Internals crate"
	group = "Engineering"


// Ammo

/datum/supply_packs/shotgunammo
	name = "Buckshot <8>"
	contains = list(/obj/item/stack/bullets/buckshot/eight)
	cost = 16
	containertype = /obj/structure/closet/crate/secure
	containername = "Buckshot shells"
	group = "Ammo"

/datum/supply_packs/princessammo
	name = "7.62mm (8)"
	contains = list(/obj/item/stack/bullets/rifle,/obj/item/stack/bullets/rifle,/obj/item/stack/bullets/rifle,
	/obj/item/stack/bullets/rifle,/obj/item/stack/bullets/rifle,/obj/item/stack/bullets/rifle,/obj/item/stack/bullets/rifle
	,/obj/item/stack/bullets/rifle)
	cost = 64
	containertype = /obj/structure/closet/crate/secure
	containername = "7.62 rounds"
	group = "Ammo"

/datum/supply_packs/duelistafive
	name = ".357 (5)"
	contains = list(/obj/item/stack/bullets/Newduelista/five)
	cost = 16
	containertype = /obj/structure/closet/crate/secure
	containername = "357 rounds"
	group = "Ammo"

/datum/supply_packs/haratseven
	name = ".380 (7)"
	contains = list(/obj/item/stack/bullets/Harat/seven)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "380 rounds"
	group = "Ammo"

/datum/supply_packs/speedloaderneoclassicx3
	name = ".38 Speedloader"
	contains = list(/obj/item/ammo_magazine/box/c38)
	cost = 16
	containertype = /obj/structure/closet/crate/secure
	containername = ".38 Rounds (x3)"
	group = "Ammo"

/datum/supply_packs/mag556
	name = "magazine 5.56 (x3)"
	contains = list(/obj/item/ammo_magazine/external/mag556, /obj/item/ammo_magazine/external/mag556, /obj/item/ammo_magazine/external/mag556)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "magazine 5.56 (x3) crate"
	group = "Ammo"

/datum/supply_packs/batterycell
	name = "Battery Cells (x3)"
	contains = list(/obj/item/cell/crap,/obj/item/cell/crap,/obj/item/cell/crap)
	cost = 45
	containertype = /obj/structure/closet/crate/secure
	containername = "Battery Cells"
	group = "Ammo"

/datum/supply_packs/pistolshooty
	name = "ML-23 Magazine"
	contains = list(/obj/item/ammo_magazine/external/mc9mm)
	cost = 16
	containertype = /obj/structure/closet/crate/secure
	containername = "9mm"
	group = "Ammo"

// Weapons

/datum/supply_packs/plastique
	name = "C-4 Explosives (x2)"
	contains = list(/obj/item/plastique,/obj/item/plastique)
	cost = 128
	containertype = /obj/structure/closet/crate/secure
	containername = "C-4 Explosive"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/stunner
	name = "Stunner Pistol"
	contains = list(/obj/item/gun/energy/taser/MERCY/pistol)
	cost = 135
	containertype = /obj/structure/closet/crate/secure
	containername = "Stunner crate"
	group = "Weapons"

/datum/supply_packs/shotgun
	name = "Pump-Action Shotgun"
	contains = list(/obj/item/gun/projectile/shotgun)
	cost = 250
	containertype = /obj/structure/closet/crate/secure
	containername = "Shotgun crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/double
	name = "Double Barrel Shotgun"
	contains = list(/obj/item/gun/projectile/newRevolver/duelista/doublebarrel)
	cost = 100
	containertype = /obj/structure/closet/crate/secure
	containername = "Shotgun crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/legax
	name = "Legax Gravpulser"
	contains = list(/obj/item/gun/energy/taser/leet/legax)
	cost = 300
	containertype = /obj/structure/closet/crate/secure
	containername = "Legax Gravpulser crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/princess
	name = "Princess MKII"
	contains = list(/obj/item/gun/projectile/shotgun/princess)
	cost = 250
	containertype = /obj/structure/closet/crate/secure
	containername = "Princess MKII crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/princessmk1
	name = "Princess MKI"
	contains = list(/obj/item/gun/projectile/shotgun/princessm1)
	cost = 120
	containertype = /obj/structure/closet/crate/secure
	containername = "Princess MKI crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/maulet
	name = "Maulet P2R"
	contains = list(/obj/item/gun/energy/taser/leet/maulet)
	cost = 64
	containertype = /obj/structure/closet/crate/secure
	containername = "Maulet P2R crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/talon
	name = "Talon M12A4"
	contains = list(/obj/item/gun/projectile/automatic/carbine)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	containername = "Talon SMG crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/duelista
	name = "Duelista"
	contains = list(/obj/item/gun/projectile/newRevolver/duelista)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Duelista crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/sparqbeams
	name = "Sparq Beam"
	contains = list(/obj/item/gun/energy/taser/leet/sparq)
	cost = 125
	containertype = /obj/structure/closet/crate/secure
	containername = "Sparq Beams crate"
	group = "Weapons"

/datum/supply_packs/neoclassicrevolver
	name = "Neoclassic R&W10 (x1)"
	contains = list(/obj/item/gun/projectile/newRevolver/duelista/neoclassic)
	cost = 285
	containertype = /obj/structure/closet/crate/secure
	containername = "Neoclassic RW crate (x1)"
	is_weapon = TRUE
	group = "Weapons"



// Medical
/datum/supply_packs/medical
	name = "Medical crate"
	contains = list(/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/fire,
					/obj/item/storage/firstaid/toxin,
					/obj/item/storage/firstaid/o2,
					/obj/item/storage/firstaid/adv,
					/obj/item/storage/pill_bottle/charcoal,
					/obj/item/reagent_containers/glass/bottle/epinephrine,
					/obj/item/reagent_containers/glass/bottle/stoxin,
					/obj/item/storage/box/syringes)
	cost = 32
	containertype = /obj/structure/closet/crate/secure
	containername = "Medical crate"
	group = "Medical / Science"

/datum/supply_packs/medicalkalocin
	name = "Kalocin"
	contains = list(/obj/item/reagent_containers/glass/bottle/lifeweb/kalocin)
	cost = 128
	containertype = /obj/structure/closet/crate/secure
	containername = "Kalocin crate"
	group = "Medical / Science"

/datum/supply_packs/medicalchems
	name = "CHEM-GaCeThCaReTaTeMo"
	contains = list(/obj/item/reagent_containers/glass/bottle/lifeweb/gallium,/obj/item/reagent_containers/glass/bottle/lifeweb/gallium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/cesium,/obj/item/reagent_containers/glass/bottle/lifeweb/cesium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/thorium,/obj/item/reagent_containers/glass/bottle/lifeweb/thorium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/californium,/obj/item/reagent_containers/glass/bottle/lifeweb/californium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/rellurium,/obj/item/reagent_containers/glass/bottle/lifeweb/rellurium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/tantalum,/obj/item/reagent_containers/glass/bottle/lifeweb/tantalum,
	/obj/item/reagent_containers/glass/bottle/lifeweb/technetium,/obj/item/reagent_containers/glass/bottle/lifeweb/technetium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/molybdenum,/obj/item/reagent_containers/glass/bottle/lifeweb/molybdenum)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Chemistry crate"
	group = "Medical / Science"

/datum/supply_packs/medicalchems2
	name = "CHEM-LiMoIrThSeEuHaLuBa"
	contains = list(	/obj/item/reagent_containers/glass/bottle/lifeweb/lithium,/obj/item/reagent_containers/glass/bottle/lifeweb/lithium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/morphite,/obj/item/reagent_containers/glass/bottle/lifeweb/morphite,
	/obj/item/reagent_containers/glass/bottle/lifeweb/iridium,/obj/item/reagent_containers/glass/bottle/lifeweb/iridium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/thaesium,/obj/item/reagent_containers/glass/bottle/lifeweb/thaesium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/selenium,/obj/item/reagent_containers/glass/bottle/lifeweb/selenium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/europium,/obj/item/reagent_containers/glass/bottle/lifeweb/europium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/hassium,/obj/item/reagent_containers/glass/bottle/lifeweb/hassium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/lutetium,/obj/item/reagent_containers/glass/bottle/lifeweb/lutetium,
	/obj/item/reagent_containers/glass/bottle/lifeweb/barium,/obj/item/reagent_containers/glass/bottle/lifeweb/barium)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Chemistry crate"
	group = "Medical / Science"

/datum/supply_packs/camogen
	name = "Camouflage Generator (x3)"
	contains = list(/obj/item/cloaking_device,/obj/item/cloaking_device,/obj/item/cloaking_device)
	cost = 200
	containertype = /obj/structure/closet/crate/secure
	containername = "Camouflage Generator (x3)"
	group = "Clothing"

/datum/supply_packs/surgery
	name = "Surgical Tools"
	contains = list(/obj/item/surgery_tool/cautery,
					/obj/item/surgery_tool/surgicaldrill,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/tank/anesthetic,
					/obj/item/surgery_tool/FixOVein,
					/obj/item/surgery_tool/hemostat,
					/obj/item/surgery_tool/scalpel,
					/obj/item/surgery_tool/bonegel,
					/obj/item/surgery_tool/retractor,
					/obj/item/surgery_tool/bonesetter,
					/obj/item/surgery_tool/circular_saw)
	cost = 100
	containertype = /obj/structure/closet/crate/secure
	containername = "Surgical Tools"
	group = "Medical / Science"

/datum/supply_packs/alchemykit
	name = "Alchemy Kit"
	contains = list(/obj/item/retort,
					/obj/item/mortar,
					/obj/item/pestle,
					/obj/item/flame/lighter,
					/obj/item/reagent_containers/glass/beaker/vial,
					/obj/item/reagent_containers/glass/beaker/vial,
					/obj/item/reagent_containers/glass/beaker/vial
					)
	cost = 64
	containertype = /obj/structure/closet/crate/secure
	containername = "Alchemy Kit"
	group = "Medical / Science"


/datum/supply_packs/randomised
	var/num_contained = 3 //number of items picked to be contained in a randomised crate
/datum/supply_packs/randomised/New()
	manifest += "Contains any [num_contained] of:"
	..()