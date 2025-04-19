/obj/proc/cocainum(var/filter)
	set waitfor = 0
	var/static/list/col_filter_brancaco = list(6,0,0,0, 0,6,0,0, 0,0,6,0, 0,0,0,1, 0.000,0,0,0)
	var/static/list/col_filter_brancaco2 = list(1.5,0,0,0, 0,1.5,0,0, 0,0,1.5,0, 0,0,0,1, 0.000,0,0,0)
	animate(filter, color = col_filter_brancaco, time = 10)
	sleep(10)
	animate(filter, color = null, time = 10)
	sleep(10)
	animate(filter, color = col_filter_brancaco2, time = 10)

/mob/proc/COCAINA()
	set waitfor = 0
	if(!client) return
	for(var/obj/screen_controller/S in client?.screen)
		S.add_filter("cor", 20, list("type" = "color", "color" = list(1.8,0,0,0, 0,1.8,0,0, 0,0,1.8,0, 0,0,0,1, 0.000,0,0,0)))
		var/filter = S.get_filter("cor")
		S.cocainum(filter)