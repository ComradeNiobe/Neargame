/mob
	var/doubleVisioned = 0
	var/blurred = 0


/mob/proc/CU(var/firstVal = -15, var/secondVal = 15, var/firstSpeed = 14, var/secondSpeed = 14)
	set waitfor = 0
	if(!client) return
	if(doubleVisioned) return

	var/obj/render_controller/R1 = new
	R1.alpha = 128
	R1.render_source = "all-1"
	R1.plane = -9

	var/obj/render_controller/R2 = new
	R2.alpha = 65
	R2.render_source = "all-1"
	R2.plane = -8

	var/obj/render_controller/R3 = new
	R3.alpha = 128
	R3.render_source = "all"
	R3.plane = 1

	var/obj/render_controller/R4 = new
	R4.alpha = 65
	R4.render_source = "all"
	R4.plane = 2

	var/obj/render_controller/R5 = new
	R5.alpha = 128
	R5.render_source = "mob"
	R5.plane = 11

	var/obj/render_controller/R6 = new
	R6.alpha = 65
	R6.render_source = "mob"
	R6.plane = 12

	var/obj/render_controller/R7 = new
	R7.alpha = 128
	R7.render_source = "all2"
	R7.plane = 16

	var/obj/render_controller/R8 = new
	R8.alpha = 65
	R8.render_source = "all2"
	R8.plane = 17

	var/obj/render_controller/R9 = new
	R9.alpha = 128
	R9.render_source = "all2"
	R9.plane = 16

	var/obj/render_controller/R10 = new
	R10.alpha = 65
	R10.render_source = "all2"
	R10.plane = 17



	src.client.screen.Add(R1)
	src.client.screen.Add(R2)
	src.client.screen.Add(R3)
	src.client.screen.Add(R4)
	src.client.screen.Add(R5)
	src.client.screen.Add(R6)
	src.client.screen.Add(R7)
	src.client.screen.Add(R8)
	src.client.screen.Add(R9)
	src.client.screen.Add(R10)


	var/list/SCV = list(rand(firstVal, secondVal), rand(firstVal, secondVal))
	var/matrix/MR1 = matrix()
	var/matrix/MR2 = matrix()
	var/matrix/MR3 = matrix()
	var/matrix/MR4 = matrix()
	var/matrix/MR5 = matrix()
	var/matrix/MR6 = matrix()
	var/matrix/MR7 = matrix()
	var/matrix/MR8 = matrix()
	var/matrix/MR9 = matrix()
	var/matrix/MR10 = matrix()

	var/list/SClist = list(SCV[1], SCV[2])
	var/list/SC2list = list((-1 * SCV[1]), (-1 * SCV[2]))
	doubleVisioned = 1
	animate(R1, transform = MR1.Translate(SC2list[1], SC2list[2]), time = (rand(40,140)/10), easing = CIRCULAR_EASING)
	animate(R2, transform = MR2.Translate(SClist[1], SClist[2]), time = (rand(40,140)/10), easing = CIRCULAR_EASING)
	animate(R3, transform = MR3.Translate(SC2list[1], SC2list[2]), time = (rand(40,140)/10), easing = CIRCULAR_EASING)
	animate(R4, transform = MR4.Translate(SClist[1], SClist[2]), time = (rand(40,140)/10), easing = CIRCULAR_EASING)
	animate(R5, transform = MR5.Translate(SC2list[1], SC2list[2]), time = (rand(40,140)/10), easing = CIRCULAR_EASING)
	animate(R6, transform = MR6.Translate(SClist[1], SClist[2]), time = (rand(40,140)/10), easing = CIRCULAR_EASING)
	animate(R7, transform = MR7.Translate(SC2list[1], SC2list[2]), time = (rand(40,140)/10), easing = CIRCULAR_EASING)
	animate(R8, transform = MR8.Translate(SClist[1], SClist[2]), time = (rand(40,140)/10), easing = CIRCULAR_EASING)
	animate(R9, transform = MR9.Translate(SC2list[1], SC2list[2]), time = (rand(40,140)/10), easing = CIRCULAR_EASING)
	animate(R10, transform = MR10.Translate(SClist[1], SClist[2]), time = (rand(40,140)/10), easing = CIRCULAR_EASING)

	sleep(firstSpeed)
	animate(R1, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R2, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R3, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R4, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R5, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R6, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R7, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R8, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R9, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R10, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)

	sleep(secondSpeed)

    //remove
	client.screen.Remove(R1)
	client.screen.Remove(R2)
	client.screen.Remove(R3)
	client.screen.Remove(R4)
	client.screen.Remove(R5)
	client.screen.Remove(R6)
	client.screen.Remove(R7)
	client.screen.Remove(R8)
	client.screen.Remove(R9)
	client.screen.Remove(R10)

	doubleVisioned = 0

/mob/proc/CU2(var/number = 10)
	if(!client) return
	for(var/x = 0, x <= number, x++)
		CU()