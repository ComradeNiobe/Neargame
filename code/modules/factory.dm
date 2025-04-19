/obj/item/line
	name = "line"
	desc = "A fabric to put on reels."
	icon = 'icons/obj/objects.dmi'
	icon_state = "line"

/obj/item/reel
	name = "reel"
	var/obj/item/line/L = null
	icon = 'icons/obj/objects.dmi'
	icon_state = "reel"

/obj/item/reel/New()
	L = new()

/obj/item/fabric
	var/Stitching = 10
	icon = 'icons/obj/objects.dmi'
	icon_state = "fabric"
	var/list/possibles = list(
	list(name = "Common Clothing", type=/obj/item/clothing/under/ordinator, amount=3),
	list(name = "Noble Clothing", type=/obj/item/clothing/under/ordinatorLT, amount=1)
	)
	var/toBecome = null
	var/amountsToBecome = null

/obj/structure/sewing_machine
	name = "Sewing Machine"
	desc = "sewing machine used to confect clothing."
	icon = 'icons/obj/objects.dmi'
	icon_state = "maquina"
	var/obj/item/reel/R = new() // carretel nao inserido
	var/obj/item/fabric/C = new() //nao tem tecido base ainda mas � debug bro
	var/on = 0
	var/jammed = 0
	var/isWorking = 0

/obj/item/paintube
	name = "paint tube"
	icon = 'icons/obj/objects.dmi'
	icon_state = "paintube"
	var/hasPaint = 1

/obj/structure/painting_machine
	name = "Painting Machine"
	desc = "Paints!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "painter"
	var/obj/item/clothing/under/C = null
	var/obj/item/paintube/P = null

/obj/structure/painting_machine/New()
	..()
	processing_objects.Add(src)

/obj/item/clothing/under
	var/tickToPAINT = 4

/obj/structure/painting_machine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = W
		user.drop_from_inventory(U)
		U.loc = src
		C = U
		visible_message("[user] puts the clothing into the painter!")
	if(istype(W, /obj/item/paintube))
		var/obj/item/paintube/PP = W
		user.drop_from_inventory(PP)
		PP.loc = src
		P = PP
		visible_message("[usr] puts the painting tube into the painter [src]!")

/obj/structure/painting_machine/process()
	if(C)
		C.tickToPAINT = max(0, C.tickToPAINT-1)
		if(C.tickToPAINT == 0)
			C.color = null //back to normal color
			C.diffcolor = null
			//I.value = initial(I.value) no value cuz white
			C.loc = loc
			C = null

/obj/structure/sewing_machine/attackby(obj/item/A as obj, mob/user as mob) //colocar as coisas nela no frwb
	if(istype(A, /obj/item/reel) && R == null)
		var/obj/item/reel/RR = A
		user.drop_from_inventory(RR)
		RR.loc = src
		R = RR
		visible_message("[user] puts a reel onto the [src]!")
	if(istype(A, /obj/item/fabric) && C == null)
		var/obj/item/fabric/F = A
		user.drop_from_inventory(F)
		F.loc = src
		C = F
		visible_message("[user] puts a fabric onto the [src]!")
	if(R && R.L == null && istype(A, /obj/item/line))
		var/obj/item/line/L = A
		user.drop_from_inventory(L)
		L.loc = R
		R.L = L
		visible_message("[usr] puts the line onto the reel in the [src]!")

/obj/structure/sewing_machine/MiddleClick(mob/living/carbon/human/user as mob)
	if(!on)
		on = 1
		visible_message("[usr] turns [src] on!")
		//playsound(nicesound)
		return
	else
		on = 0
		visible_message("[usr] turns [src] off!")
		//playsound(nicesound)
		return

/obj/structure/sewing_machine/attack_hand(mob/living/carbon/human/user as mob)
	if(!R || !R.L || !C || jammed || !on) return
	//No SS13 - Click com m�o vazia fazer funcionar

	if(C.Stitching == initial(C.Stitching) && C.toBecome == null && C.amountsToBecome == null)
		var/list/inputlist = list()
		var/list/tobecomelist = list()
		for(var/i = 1, i <= C.possibles.len, i++)
			var/coisas = C.possibles[i]
			var/nome = coisas["name"]
			var/tobecome = coisas["type"]
			tobecomelist += tobecome
			inputlist += nome
		inputlist += "(CANCEL)"
		var/inputch = input("What do you wish to make?", "Choose an object") in inputlist
		if(inputch != "(CANCEL)")
			for(var/i = 1, i <= C.possibles.len, i++)
				var/coisas = C.possibles[i]
				var/nome = coisas["name"]
				var/tobecome = coisas["type"]
				var/amountstobecome = coisas["amount"]
				if(inputch == nome)
					C.toBecome = tobecome
					C.amountsToBecome = amountstobecome
					return

	playsound(src.loc, 'sound/effects/sewing_action.ogg', 100, 1)
	isWorking = 1 // just for you know
	if(do_after(user,55))
		C.Stitching -= min(0, C.Stitching-=1)

		if(C.Stitching == 0)
			for(var/i = 1, i <= C.amountsToBecome, i++)
				var/obj/item/clothing/under/I = new C.toBecome(loc)
				I.item_worth = 0 //no value cuz white
				I.color = "#00ff00" // no color yet
				I.diffcolor = "#00ff00"
				if(i <= C.amountsToBecome+1)
					qdel(C)
					C = null
					var/obj/item/fabric/F = new
					C = F
					break