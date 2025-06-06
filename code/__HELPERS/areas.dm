/*
	List generation helpers
*/
/proc/get_filtered_areas(var/list/predicates = list(/proc/is_area_with_turf))
	. = list()
	if(!predicates)
		return
	if(!islist(predicates))
		predicates = list(predicates)
	for(var/area/A)
		if(all_predicates_true(list(A), predicates))
			. += A

/proc/get_area_turfs(var/area/A, var/list/predicates)
	. = new/list()
	A = istype(A) ? A : locate(A)
	if(!A)
		return
	for(var/turf/T in A.contents)
		if(!predicates || all_predicates_true(list(T), predicates))
			. += T

/proc/group_areas_by_name(var/list/predicates)
	. = list()
	for(var/area/A in get_filtered_areas(predicates))
		group_by(., A.proper_name, A)

/proc/group_areas_by_z_level(var/list/predicates)
	. = list()
	var/enough_digits_to_contain_all_zlevels = 3
	for(var/area/A in get_filtered_areas(predicates))
		group_by(., add_zero(num2text(A.z), enough_digits_to_contain_all_zlevels), A)

/*
	Pick helpers
*/
/proc/pick_area_turf_by_flag(var/area_flags, var/list/predicates)
	var/list/turfs
	var/list/valid_areas = list()
	for(var/area/candidate_area as anything in global.areas)
		if(!(candidate_area.area_flags & area_flags))
			continue
		valid_areas[candidate_area] = TRUE
	if(!length(valid_areas)) // no turfs at all have that flag
		return FALSE
	// Each area contents loop is an in-world loop, so we just do one here.
	for(var/turf/turf_candidate in world)
		var/area/candidate_area = get_area(turf_candidate)
		if(!valid_areas[candidate_area])
			continue
		if(!predicates || all_predicates_true(list(turf_candidate), predicates))
			LAZYADD(turfs, turf_candidate)
	if(LAZYLEN(turfs))
		return pick(turfs)

/proc/pick_area_turf(var/areatype, var/list/predicates)
	var/list/turfs = get_area_turfs(areatype, predicates)
	return SAFEPICK(turfs)

/proc/pick_area(var/list/predicates)
	var/list/areas = get_filtered_areas(predicates)
	return SAFEPICK(areas)

/proc/pick_area_and_turf(var/list/area_predicates, var/list/turf_predicates)
	var/list/areas = get_filtered_areas(area_predicates)
	// We loop over all area candidates, until we finally get a valid turf or run out of areas
	while(!. && length(areas))
		var/area/A = pick_n_take(areas)
		. = pick_area_turf(A, turf_predicates)

/*
	Predicate Helpers
*/
/proc/area_belongs_to_zlevels(var/area/A, var/list/z_levels)
	. = (A.z in z_levels)

/proc/is_area_with_turf(var/area/A)
	if(istype(A))
		. = isnum(A.x)

/proc/is_area_without_turf(var/area/A)
	. = !is_area_with_turf(A)

/*
	Misc Helpers
*/
//#define teleportlocs area_repository.get_areas_by_name_and_coords(global.is_player_but_not_space_or_shuttle_area)
#define stationlocs area_repository.get_areas_by_name(global.is_player_but_not_space_or_shuttle_area)
#define wizteleportlocs area_repository.get_areas_by_name(global.is_station_area)
#define maintlocs area_repository.get_areas_by_name(global.is_station_and_maint_area)
#define wizportallocs area_repository.get_areas_by_name(global.is_station_but_not_space_or_shuttle_area)
