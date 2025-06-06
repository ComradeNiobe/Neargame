/obj/structure/girder
	icon_state = "girder"
	anchored = 1
	density = 1
	layer = 2
	var/state = 0
	var/health = 200


	bullet_act(var/obj/item/projectile/Proj)
		if(istype(Proj, /obj/item/projectile/beam))
			health -= Proj.damage
			..()
			if(health <= 0)
				new /obj/item/stack/sheet/metal(get_turf(src))
				qdel(src)

			return

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/wrench) && state == 0)
			if(anchored && !istype(src,/obj/structure/girder/displaced))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "\blue Now disassembling the girder"
				if(do_after(user,40))
					if(!src) return
					user << "\blue You dissasembled the girder!"
					new /obj/item/stack/sheet/metal(get_turf(src))
					qdel(src)
			else if(!anchored)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "\blue Now securing the girder"
				if(do_after(user, 40))
					user << "\blue You secured the girder!"
					new/obj/structure/girder( src.loc )
					qdel(src)

		else if(istype(W, /obj/item/pickaxe/diamonddrill))
			user << "\blue You drill through the girder!"
			new /obj/item/stack/sheet/metal(get_turf(src))
			qdel(src)

		else if(istype(W, /obj/item/screwdriver) && state == 2 && istype(src,/obj/structure/girder/reinforced))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			user << "\blue Now unsecuring support struts"
			if(do_after(user,40))
				if(!src) return
				user << "\blue You unsecured the support struts!"
				state = 1

		else if(istype(W, /obj/item/wirecutters) && istype(src,/obj/structure/girder/reinforced) && state == 1)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			user << "\blue Now removing support struts"
			if(do_after(user,40))
				if(!src) return
				user << "\blue You removed the support struts!"
				new/obj/structure/girder( src.loc )
				qdel(src)

		else if(istype(W, /obj/item/crowbar) && state == 0 && anchored )
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			user << "\blue Now dislodging the girder"
			if(do_after(user, 40))
				if(!src) return
				user << "\blue You dislodged the girder!"
				new/obj/structure/girder/displaced( src.loc )
				qdel(src)

		else if(istype(W, /obj/item/stack/sheet))

			var/obj/item/stack/sheet/S = W
			switch(S.type)

				if(/obj/item/stack/sheet/metal, /obj/item/stack/sheet/metal/cyborg)
					if(!anchored)
						if(S.amount < 2) return
						S.use(2)
						user << "\blue You create a false wall! Push on it to open or close the passage."
						new /obj/structure/falsewall (src.loc)
						qdel(src)
					else
						if(S.amount < 2) return ..()
						user << "\blue Now adding plating..."
						if (do_after(user,40))
							if(!src || !S || S.amount < 2) return
							S.use(2)
							user << "\blue You added the plating!"
							var/turf/Tsrc = get_turf(src)
							Tsrc.ChangeTurf(/turf/simulated/wall)
							for(var/turf/simulated/wall/X in Tsrc.loc)
								if(X)	X.add_hiddenprint(usr)
							qdel(src)
						return

				if(/obj/item/stack/sheet/plasteel)
					if(!anchored)
						if(S.amount < 2) return
						S.use(2)
						user << "\blue You create a false wall! Push on it to open or close the passage."
						new /obj/structure/falserwall (src.loc)
						qdel(src)
					else
						if (src.icon_state == "reinforced") //I cant believe someone would actually write this line of code...
							if(S.amount < 1) return ..()
							user << "\blue Now finalising reinforced wall."
							if(do_after(user, 50))
								if(!src || !S || S.amount < 1) return
								S.use(1)
								user << "\blue Wall fully reinforced!"
								var/turf/Tsrc = get_turf(src)
								Tsrc.ChangeTurf(/turf/simulated/wall/r_wall)
								for(var/turf/simulated/wall/r_wall/X in Tsrc.loc)
									if(X)	X.add_hiddenprint(usr)
								qdel(src)
							return
						else
							if(S.amount < 1) return ..()
							user << "\blue Now reinforcing girders"
							if (do_after(user,60))
								if(!src || !S || S.amount < 1) return
								S.use(1)
								user << "\blue Girders reinforced!"
								new/obj/structure/girder/reinforced( src.loc )
								qdel(src)
							return

			if(S.sheettype)
				var/M = S.sheettype
				if(!anchored)
					if(S.amount < 2) return
					S.use(2)
					user << "\blue You create a false wall! Push on it to open or close the passage."
					var/F = text2path("/obj/structure/falsewall/[M]")
					new F (src.loc)
					qdel(src)
				else
					if(S.amount < 2) return ..()
					user << "\blue Now adding plating..."
					if (do_after(user,40))
						if(!src || !S || S.amount < 2) return
						S.use(2)
						user << "\blue You added the plating!"
						var/turf/Tsrc = get_turf(src)
						Tsrc.ChangeTurf(text2path("/turf/simulated/wall/mineral/[M]"))
						for(var/turf/simulated/wall/mineral/X in Tsrc.loc)
							if(X)	X.add_hiddenprint(usr)
						qdel(src)
					return

			add_hiddenprint(usr)

		else if(istype(W, /obj/item/pipe))
			var/obj/item/pipe/P = W
			if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
				user.drop_item()
				P.loc = src.loc
				user << "\blue You fit the pipe into the [src]!"
		else
			..()

	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(30))
					var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
					new remains(loc)
					qdel(src)
				return
			if(3.0)
				if (prob(5))
					var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
					new remains(loc)
					qdel(src)
				return
			else
		return

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = 0
	health = 50

/obj/structure/girder/reinforced
	icon_state = "reinforced"
	state = 2
	health = 500