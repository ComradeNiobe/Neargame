/datum/job/LordPusher
    title = "German"
    titlebr = "Alemao"
    flag = SMUGGLER
    department_flag = CIVILIAN
    faction = "Station"
    total_positions = 1
    spawn_positions = 1
    supervisors = "The loan sharks and your luck."
    selection_color = "#ae00ff"
    access = list(brothel)
    minimal_access = list(brothel)
    idtype = /obj/item/card/id/ltgrey
    money = 450
    thanati_chance = 75
    jobdesc = "Enoch's Gate is one of the few places on the planet where even heavy drugs and prostitution are legal. You've had to struggle to get into this sweet place, leaving your dead competitors behind you, and ended up deep in debt. Isn't that a beginning of something beautiful?"
    equip(var/mob/living/carbon/human/H)
        if(!H)
            return 0
        ..()
        H.age = rand(45, 65)

        H.r_hair = 95
        H.g_hair = 95
        H.b_hair = 95

        H.r_facial = 95
        H.g_hair = 95
        H.b_hair = 95

        H.voicetype = "sketchy"
        H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
        H.equip_to_slot_or_del(new /obj/item/clothing/under/common(H), slot_w_uniform)
        H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
        H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/pusher(H), slot_wear_suit)
        H.mind.time_to_pay = rand(15, 40)
        H.terriblethings = TRUE
        return 1