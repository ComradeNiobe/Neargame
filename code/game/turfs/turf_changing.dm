/turf/proc/transport_properties_from(turf/other, transport_air)
	if(transport_air && can_inherit_air && (other.zone || other.air))
		if(!air)
			make_air()
		air.copy_from(other.zone ? other.zone.air : other.air)
		other.zone?.remove(other)
	if(!istype(other, src.type))
		return 0
	src.set_dir(other.dir)
	src.icon_state = other.icon_state
	src.icon = other.icon
	src.overlays = other.overlays.Copy()
	src.underlays = other.underlays.Copy()
	if(other.decals)
		src.decals = other.decals.Copy()
		//src.update_icon()
	return 1

/turf/simulated/floor/transport_properties_from(turf/simulated/floor/other)
	if(!..())
		return FALSE

	// Unlint this to copy the actual raw vars.
	return TRUE

/turf/simulated/wall/transport_properties_from(turf/simulated/wall/other)
	if(!..())
		return FALSE

	damage = other.damage

	return TRUE
