/obj/mecha/working
	internal_damage_threshold = 60

/obj/mecha/working/New()
	..()
	var/turf/T = get_turf(src)
	if(T.z != 2)
		new /obj/item/mecha_parts/mecha_tracking(src)
	return

/*
/obj/mecha/working/melee_action(atom/target as obj|mob|turf)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		target = pick(oview(1,src))
	if(selected_tool)
		selected_tool.action(target)
	return
*/

/obj/mecha/working/range_action(atom/target as obj|mob|turf)
	return

/*
/obj/mecha/working/get_stats_part()
	var/output = ..()
	output += "<b>[src.name] Tools:</b><div style=\"margin-left: 15px;\">"
	if(equipment.len)
		for(var/obj/item/mecha_parts/mecha_equipment/MT in equipment)
			output += "[selected==MT?"<b>":"<a href='byond://?src=\ref[src];select_equip=\ref[MT]'>"][MT.get_equip_info()][selected==MT?"</b>":"</a>"]<br>"
	else
		output += "None"
	output += "</div>"
	return output
*/