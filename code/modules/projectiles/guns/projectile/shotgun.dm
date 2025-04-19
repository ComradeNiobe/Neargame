/obj/item/gun/projectile/shotgun
	name = "shotgun"
	desc = "Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	wielded_icon = TRUE
	wielded_underlay = TRUE
	w_class = 4.0
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_magazine/internal/shot
	stacktype = /obj/item/stack/bullets/buckshot
	spenttype = /obj/item/ammo_casing/spent/shotgun
	recoil = 1
	item_worth = 160
	jam_chance = 8
	load_shell_sound = 'sound/weapons/guns/interact/shell_insert1.ogg'
	fire_sound = 'sound/weapons/Shotgun.ogg'
	weight = 8
	var/casing_sound = 'sound/weapons/shotgunshell.ogg'
	var/recentpump = 0 // to prevent spammage
	var/pumped = 0
	var/pumpsound = 'sound/weapons/shotgunpump.ogg'

/obj/item/gun/projectile/shotgun/process_chambered()
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(isnull(AC) || !istype(AC))
		return 0

	AC.on_fired()

	if(AC.BB)
		in_chamber = AC.BB //Load projectile into chamber.
		AC.BB.loc = src //Set projectile loc to gun.
		AC.BB = null
		AC.update_icon()
		return 1
	return 0


/obj/item/gun/projectile/shotgun/attack_self(mob/living/user as mob)
	if(is_jammed)
		unjam(user)
		return
	if(recentpump)	return
	pump()
	recentpump = 1
	spawn(5)
		recentpump = 0
	return


/obj/item/gun/projectile/shotgun/proc/pump(mob/M as mob)
	if(is_jammed)
		unjam(M)
		return
	playsound(src.loc, pumpsound, 60, 1)
	pumped = 0
	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered.update_icon()
		playsound(src, casing_sound, 100, 1)
		chambered = null
		if(in_chamber)
			in_chamber = null
	if(!magazine.ammo_count())	return 0
	var/obj/item/ammo_casing/AC = magazine.get_round() //load next casing.
	chambered = AC
	update_icon()	//I.E. fix the desc
	return 1

/obj/item/gun/projectile/shotgun/examine()
	..()
	if (chambered)
		usr << "A [chambered.BB ? "live" : "spent"] one is in the chamber."

/obj/item/gun/projectile/shotgun/combat
	name = "combat shotgun"
	icon_state = "cshotgun"
	origin_tech = "combat=5;materials=2"
	mag_type = /obj/item/ammo_magazine/internal/shot/com
	w_class = 5


/obj/item/gun/projectile/revolver/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon_state = "dshotgun"
	item_state = "shotgun"
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "combat=3;materials=1"
	mag_type = /obj/item/ammo_magazine/internal/dualshot
	var/sawn_desc = "Omar's coming!"
	var/sawn = 0

/obj/item/gun/projectile/revolver/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	if(istype(A, /obj/item/surgery_tool/circular_saw) || istype(A, /obj/item/melee/energy))
		if(sawn)
			user << "<span class='notice'>\The [src] is already sawn!</span>"
		user << "<span class='notice'>You begin to shorten the barrel of \the [src].</span>"
		if(get_ammo())
			afterattack(user, user)	//will this work?
			afterattack(user, user)	//it will. we call it twice, for twice the FUN
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "[icon_state]-sawn"
			w_class = 3
			item_state = "gun"
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= SLOT_BELT		//but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
			user << "<span class='warning'>You shorten the barrel of \the [src]!</span>"
			name = "sawn-off [src.name]"
			desc = sawn_desc
			sawn = 1

/obj/item/gun/projectile/revolver/doublebarrel/attack_self(mob/living/user as mob)
	var/num_unloaded = 0
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		chambered = null
		if(CB && !istype(CB, /obj/item/ammo_casing/none))
			CB.loc = get_turf(src.loc)
			CB.update_icon()
			num_unloaded++
		magazine.on_empty()
	if (num_unloaded)
		user << "<span class = 'notice'>You break open \the [src] and unload [num_unloaded] shell\s.</span>"
	else
		user << "<span class='notice'>[src] is empty.</span>"

// IMPROVISED SHOTGUN //

/obj/item/gun/projectile/revolver/doublebarrel/improvised
	name = "improvised shotgun"
	desc = "Essentially a tube that aims shotgun shells."
	icon_state = "ishotgun"
	item_state = "shotgun"
	w_class = 4.0
	force = 10
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_magazine/internal/improvised
	sawn_desc = "I'm just here for the gasoline."

/obj/item/gun/projectile/revolver/doublebarrel/improvised/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	if(istype(A, /obj/item/stack/cable_coil) && !sawn)
		var/obj/item/stack/cable_coil/C = A
		if(C.use(10))
			flags =  CONDUCT
			slot_flags = SLOT_BACK
			icon_state = "ishotgunsling"
			user << "<span class='notice'>You tie the lengths of cable to the shotgun, making a sling.</span>"
			update_icon()
		else
			user << "<span class='warning'>You need at least ten lengths of cable if you want to make a sling.</span>"
			return

/obj/item/gun/projectile/revolver/doublebarrel/spin()
	set invisibility = 101

/obj/item/granade_launcher_canopy
	name = "Grenade launcher canope"
	icon = 'icons/obj/gun.dmi'
	icon_state = "riotgun"
	w_class = 1.0
	force = 3.0

/obj/item/ion_emitter
	name = "ion emitter"
	icon = 'icons/obj/gun.dmi'
	icon_state = "riotgun"
	w_class = 1.0
	force = 3.0

/obj/item/breaker_device
	name = "breaker device"
	icon = 'icons/obj/gun.dmi'
	icon_state = "riotgun"
	w_class = 1.0
	force = 3.0

/obj/item/reagent_containers/spray/chemsprayer/canopy
	name = "spray canopy"
	icon = 'icons/obj/gun.dmi'
	icon_state = "riotgun"
	w_class = 1.0
	force = 3.0

	New()
		..()
		reagents.add_reagent("condensedcapsaicin", 120)

	afterattack()
		return

/obj/item/gun/projectile/shotgun/princess
	name = "\improper Princess MKII"
	desc = "A powerful bolt action rifle with an internal magazine. Extremely potent."
	icon_state = "princess"
	item_state = "princess"
	load_shell_sound = 'sound/weapons/boltaction_load.ogg'
	wielded_icon = "princess_wielded"
	item_worth = 200
	caliber = ".762"
	recoil = 0.5
	jam_chance = 5
	pumpsound = 'sound/weapons/boltpump.ogg'
	mag_type = /obj/item/ammo_magazine/internal/princ
	fire_sound = 'sound/weapons/princess_fire.ogg'
	casing_sound = 'sound/weapons/guns/misc/casingfall1.ogg'
	stacktype = /obj/item/stack/bullets/rifle
	spenttype = /obj/item/ammo_casing/spent/rifle
	weight = 7

/obj/item/gun/projectile/shotgun/princessm1
	name = "\improper Princess MKI"
	desc = "A powerful bolt action rifle produced to arm rifleman milita. It's low price-tag and powerful round make it a staple of fortress defence!"
	icon_state = "princess"
	item_state = "princess"
	load_shell_sound = 'sound/weapons/boltaction_load.ogg'
	wielded_icon = "princess_wielded"
	item_worth = 80
	caliber = ".762"
	recoil = 0.7
	jam_chance = 1 // Extremely rare given its nature.
	pumpsound = 'sound/weapons/boltpump.ogg'
	mag_type = /obj/item/ammo_magazine/internal/princmk1
	fire_sound = 'sound/weapons/princess_fire.ogg'
	casing_sound = 'sound/weapons/guns/misc/casingfall1.ogg'
	stacktype = /obj/item/stack/bullets/rifle
	spenttype = /obj/item/ammo_casing/spent/rifle
	weight = 12


/obj/item/gun/projectile/shotgun/princess/nevermiss
	name = "dummy"