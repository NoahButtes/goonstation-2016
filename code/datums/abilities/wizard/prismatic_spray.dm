/datum/targetable/spell/prismatic_spray
	name = "Prismatic Spray"
	desc = "Launches a spray of colorful projectiles in outwards in a cone aimed roughly at the target."
	icon_state = "prismspray" //credit to Kubius for the new icons
	targeted = 1
	target_anything = 1
	cooldown = 250 //10 seconds shorter than the cooldown for fireball in modern code
	requires_robes = 1
	offensive = 1
	sticky = 1
	//set spread equal to half of the desired angle of effect in degrees. 90 becomes 180, 180 becomes 360, etc.
	var/spread = 26.565 //approximately equivalent to half the angle of a dnd 5e cone AoE spell
	//the number of projectiles we want to fire in a single cast
	var/num_projectiles = 12
	//what projectiles do we *NOT* want to add to the pool of random projectiles?
	var/list/blacklist = list(/datum/projectile,/datum/projectile/slam,/datum/projectile/artifact,/datum/projectile/artifact/prismatic_projectile)
	//If random == 0, use the special prismatic projectile datum. Else, pick from the pool of all projectiles minus the blacklisted ones
	var/random = 0
	//the list of projectile types to pick from if random is set to 1
	var/list/proj_types = list()
	//instance projectile datum for non-random usage, randomise() is called on this
	var/datum/projectile/artifact/prismatic_projectile/ps_proj = new

	New()
		..()
		for (var/X in typesof(/datum/projectile) - src.blacklist)
			var/datum/projectile/A = new X
			proj_types += A

	cast(atom/target)
		if (holder.owner.wizard_spellpower())
			holder.owner.say("PROJEHK TUL IHNFERNUS") //incantation credit to Grifflez
			var/mob/living/carbon/human/O = holder.owner
			if(O && istype(O.wear_suit, /obj/item/clothing/suit/wizrobe/necro) && istype(O.head, /obj/item/clothing/head/wizard/necro))
				playsound(holder.owner.loc, "sound/voice/wizard/PandemoniumLoud.ogg", 50, 0, -1) //replace with proper necro version
			else if(holder.owner.gender == "female")
				playsound(holder.owner.loc, "sound/voice/wizard/PandemoniumLoud.ogg", 50, 0, -1) //replace with proper female version
			else
				playsound(holder.owner.loc, "sound/voice/wizard/PandemoniumLoud.ogg", 50, 0, -1) //replace with proper generic male version
			if(src.random == 0)
				for(var/i=0, i<num_projectiles, i++)
					var/turf/S = get_turf(O)
					ps_proj.randomise()
					if (get_turf(target) == S)
						var/obj/projectile/P = shoot_projectile_XY(S, ps_proj, cos(rand(0,360)), sin(rand(0,360)))
						if (P)
							P.mob_shooter = O
							sleep(1)
					else
						var/obj/projectile/P = initialize_projectile_ST(O, ps_proj, target )
						if (P)
							P.mob_shooter = O
							var/angle = (rand(spread * -1000, spread * 1000))/1000
							P.rotateDirection(angle)
							P.launch()
							sleep(1)
			else
				for(var/i=0, i<num_projectiles, i++)
					var/turf/S = get_turf(O)
					ps_proj.randomise()
					if (get_turf(target) == S)
						var/obj/projectile/P = shoot_projectile_XY(S, pick(proj_types), cos(rand(0,360)), sin(rand(0,360)))
						if (P)
							P.mob_shooter = O
							sleep(1)
					else
						var/obj/projectile/P = initialize_projectile_ST(O, pick(proj_types), target )
						if (P)
							P.mob_shooter = O
							var/angle = (rand(spread * -1000, spread * 1000))/1000
							P.rotateDirection(angle)
							P.launch()
							sleep(1)
		else
			boutput(holder.owner, "<span style=\"color:red\">Your spell doesn't work without a staff to refract the light!</span>")
			return 1

/datum/targetable/spell/prismatic_spray/admin
	random = 1

/datum/targetable/spell/prismatic_spray/admin/bullet_hell
	spread = 180.0
	num_projectiles = 120

/datum/targetable/spell/prismatic_spray/bullet_hell
	spread = 180.0
	num_projectiles = 120
