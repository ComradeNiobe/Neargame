/obj/item/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A heavy-duty, pulse-based energy weapon, preferred by front-line combat personnel."
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.
	force = 10
	fire_sound = 'sound/weapons/pulse.ogg'
	charge_cost = 200
	projectile_type = "/obj/item/projectile/beam/pulse"
	cell_type = "/obj/item/cell/super"
	var/mode = 2
	fire_delay = 25

	attack_self(mob/living/user as mob)
		switch(mode)
			if(2)
				mode = 0
				charge_cost = 100
				fire_sound = 'sound/weapons/Taser.ogg'
				user << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/beam/stun"
			if(0)
				mode = 1
				charge_cost = 100
				fire_sound = 'sound/weapons/Laser.ogg'
				user << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam"
			if(1)
				mode = 2
				charge_cost = 200
				fire_sound = 'sound/weapons/pulse.ogg'
				user << "\red [src.name] is now set to DESTROY."
				projectile_type = "/obj/item/projectile/beam/pulse"
		return

	isHandgun()
		return 0

/obj/item/gun/energy/pulse_rifle/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon."
	cell_type = "/obj/item/cell/infinite"

	attack_self(mob/living/user as mob)
		user << "\red [src.name] has three settings, and they are all DESTROY."



/obj/item/gun/energy/pulse_rifle/M1911
	name = "m1911-P"
	desc = "It's not the size of the gun, it's the size of the hole it puts through people."
	icon_state = "m1911-p"
	cell_type = "/obj/item/cell/infinite"

	isHandgun()
		return 1