particles/fireplace
	width = 100
	height = 200
	count = 100
	spawning = 1
	lifespan = 14
	fade = 0
	grow = -0.01
	velocity = list(0, 0)
	position = generator("circle", 0, 0, NORMAL_RAND)
	gravity = list(0, 0.15)
	icon = 'icons/obj/particles.dmi'
	scale       =   generator("vector", list(0.3, 0.3), list(1,1), NORMAL_RAND)
	rotation    =   30
	spin        =   generator("num", -5, 5)
	color = "yellow"


particles/fireplace2
	width = 100
	height = 200
	count = 100
	spawning = 1
	lifespan = 14
	fade = 0
	grow = -0.01
	velocity = list(0, 0)
	position = generator("circle", 0, 0, NORMAL_RAND)
	gravity = list(0, 0.15)
	icon = 'icons/obj/particles_alt.dmi'
	scale       =   generator("vector", list(0.2, 0.2), list(0.8,0.8), NORMAL_RAND)
	rotation    =   30
	spin        =   generator("num", -5, 5)
	color = "yellow"