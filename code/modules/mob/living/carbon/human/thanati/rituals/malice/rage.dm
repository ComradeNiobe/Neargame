/proc/rage(var/text = null, var/mob = null, var/turf/C)
    var/list/humanDirs = list(EAST, WEST, C)

    for(var/direction in humanDirs)
        var/turf/T = get_step(C, direction)
        var/list/humanList = list()

        for(var/mob/living/carbon/human/H in T)
            if(!H.raged)
                humanList += H
                continue
            return

        for(var/mob/living/carbon/human/H in humanList)
            H.my_stats.change_stat(STAT_ST , 6)
            H.my_stats.change_stat(STAT_DX , 2)
            H.my_stats.change_stat(STAT_IN , -5)
            H.updateStatPanel()
            H.raged = 1
            to_chat(H, "<span class='passiveglow'> You feel your muscles itching, and your head getting lighter </span>")

/atom/examine()
    if(ishuman(usr))
        var/mob/living/carbon/human/H = usr
        if(H.raged)
            to_chat(H, "<span class='combatglow'>Uh?</span>")
            return
    ..()
