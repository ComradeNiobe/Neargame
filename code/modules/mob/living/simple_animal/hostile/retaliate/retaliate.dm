/mob/living/simple_animal/hostile/retaliate
	var/list/enemies = list()

/mob/living/simple_animal/hostile/retaliate/Found(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat)
			stance = HOSTILE_STANCE_ATTACK
			return L
		else
			enemies -= L
	else if(istype(A, /obj/mecha))
		var/obj/mecha/M = A
		if(M.occupant)
			stance = HOSTILE_STANCE_ATTACK
			return A

/mob/living/simple_animal/hostile/retaliate/ListTargets()
	if(!enemies.len)
		return list()
	var/list/see = ..()
	see &= enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/hostile/retaliate/proc/Retaliate()
	return
	
/mob/living/simple_animal/hostile/retaliate/adjustBruteLoss(var/damage)
	..(damage)
	Retaliate()
