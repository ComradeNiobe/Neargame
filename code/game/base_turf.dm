/*
//An area can override the z-level base turf, so our solar array areas etc. can be space-based.
/proc/get_base_turf_by_area(var/turf/T)
	if(!istype(T))
		return
	var/area/A = get_area(T)
	if(HasBelow(T.z))
		if(istype(A) && A.open_turf)
			return A.open_turf

		// Find the first non-open turf below and use its open_turf_type.
		var/z_stack_type = get_open_turf_type(T)
		if(z_stack_type)
			return z_stack_type

		// Otherwise, default to the open turf type set on the turf being removed.
		if(T.open_turf_type)
			return T.open_turf_type
	if(istype(A) && A.base_turf)
		return A.base_turf
	return get_base_turf(T.z)

// Returns the open turf of a Z-stack by finding the nearest non-open turf below.
/proc/get_open_turf_type(var/turf/T)
	if(!HasBelow(T.z))
		return
	var/turf/below = T
	while ((below = GetBelow(below)))
		if(!below.is_open() || !HasBelow(below.z))
			if(below.open_turf_type)
				return below.open_turf_type
			return
*/