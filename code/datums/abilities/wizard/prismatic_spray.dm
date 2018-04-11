/datum/targetable/spell/prismatic_spray
	name = "Prismatic Spray"
	desc = "Launches a spray of colorful projectiles in outwards in a cone aimed roughly at the target."
	icon_state = "fireball" //PLACEHOLDER, NEEDS NEW ICON
	targeted = 1
	target_anything = 1
	cooldown = 350 //in line with current fireball code 
	requires_robes = 1
	offensive = 1
	sticky = 1
	// half the number of degrees for the type of cone we want
	var/spread = 26.565 //half of a dnd 5e cone, we will effectively double this later on
	//the number of projectiles we want to fire in a single cast
	var/num_projectiles = 12
	//what projectiles do we *NOT* want to add for the admin version?
	var/list/blacklist = list(/datum/projectile,/datum/projectile/slam,/datum/projectile/artifact,/datum/projectile/artifact/prismatic_projectile)
	//do we recruit from the pool of ALL projectiles?
	var/random = 0
	//what projectiles do we use, assuming we do use a large number of them
	var/list/proj_types = list()

	New()
		..()
		if(src.random == 1)
			for (var/X in typesof(/datum/projectile) - src.blacklist)
				var/datum/projectile/A = new X
				proj_types += A
		else
			var/datum/projectile/A = new /datum/projectile/artifact/prismatic_projectile
			proj_types += A

	cast(atom/target)
		holder.owner.say("WATT LEHFUQUE") //placeholder because I can't do voice acting to give it a custom incantation
		var/mob/living/carbon/human/O = holder.owner
		if(O && istype(O.wear_suit, /obj/item/clothing/suit/wizrobe/necro) && istype(O.head, /obj/item/clothing/head/wizard/necro))
			playsound(holder.owner.loc, "sound/voice/wizard/PandemoniumLoud.ogg", 50, 0, -1) //replace with proper necro version
		else if(holder.owner.gender == "female")
			playsound(holder.owner.loc, "sound/voice/wizard/PandemoniumLoud.ogg", 50, 0, -1) //replace with proper female version
		else
			playsound(holder.owner.loc, "sound/voice/wizard/PandemoniumLoud.ogg", 50, 0, -1) //replace with proper generic male version

		for(var/i=0, i<num_projectiles, i++)
			var/datum/projectile/artifact/prismatic_projectile/pt
			if(src.random == 0)
				pt = new /datum/projectile/artifact/prismatic_projectile
				pt.randomise()
				var/obj/projectile/P = initialize_projectile_ST( holder.owner, pt, target )
				if (P)
					P.mob_shooter = holder.owner
					var/angle = pick(-1,1)*((rand(0,spread*1000)/1000))
					P.rotateDirection(angle)
					P.launch()
					sleep(1)
			else
				var/obj/projectile/P = initialize_projectile_ST( holder.owner, pick(proj_types), target )
				if (P)
					P.mob_shooter = holder.owner
					var/angle = pick(-1,1)*((rand(0,spread*1000)/1000))
					P.rotateDirection(angle)
					P.launch()
					sleep(1)

/datum/targetable/spell/prismatic_spray/admin
	random = 1

/datum/targetable/spell/prismatic_spray/admin/bullet_hell
	spread = 180.0
	num_projectiles = 120

/datum/targetable/spell/prismatic_spray/bullet_hell
	spread = 180.0
	num_projectiles = 120
