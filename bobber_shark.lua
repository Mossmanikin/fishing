-----------------------------------------------------------------------------------------------
-- Fishing - Mossmanikin's version - Bobber Shark 0.0.4
-- License (code & textures): 	WTFPL
-----------------------------------------------------------------------------------------------

-- Here's what you can catch if you use a fish as bait
local CaTCH_BiG = {
--	  MoD 						 iTeM				WeaR		 MeSSaGe ("You caught "..)	GeTBaiTBack		NRMiN  	CHaNCe (../120)
    {"fishing",  				"shark",			0,			"a small Shark.",			false,			1,		2},
	{"fishing",  				"pike",				0,			"a Northern Pike.",			false,			3,		3}
}

local FISHING_BOBBER_ENTITY_SHARK={
	hp_max = 605,
	water_damage = 1,
	physical = true,
	timer = 0,
	env_damage_timer = 0,
	visual = "wielditem",
	visual_size = {x=1/3, y=1/3, z=1/3},
	textures = {"fishing:bobber_box"},
	--			   {left ,bottom, front, right,  top ,  back}
	collisionbox = {-2/16, -4/16, -2/16,  2/16, 0/16,  2/16},
	view_range = 7,
--	DESTROY BOBBER WHEN PUNCHING IT
	on_punch = function (self, puncher, time_from_last_punch, tool_capabilities, dir)
		local player = puncher:get_player_name()
		if MESSAGES == true then minetest.chat_send_player(player, "Your fish escaped.", false) end -- fish escaped
		minetest.sound_play("fishing_bobber1", {
			pos = self.object:getpos(),
			gain = 0.5,
		})
		self.object:remove()
	end,
--	WHEN RIGHTCLICKING THE BOBBER THE FOLLOWING HAPPENS	(CLICK AT THE RIGHT TIME WHILE HOLDING A FISHING POLE)	
	on_rightclick = function (self, clicker)
		local item = clicker:get_wielded_item()
		local player = clicker:get_player_name()
		local say = minetest.chat_send_player
		if item:get_name() == "fishing:pole" then
			local inv = clicker:get_inventory()
			local pos = self.object:getpos()
			if minetest.env:get_node(pos).name == "flowers:waterlily"
			or minetest.env:get_node(pos).name == "flowers:waterlily_225"
			or minetest.env:get_node(pos).name == "flowers:waterlily_45"
			or minetest.env:get_node(pos).name == "flowers:waterlily_675" then
				minetest.env:add_node({x=pos.x, y=pos.y, z=pos.z}, {name="air"})
				if inv:room_for_item("main", {name="flowers:waterlily", count=1, wear=WeaR, metadata=""}) then
					inv:add_item("main", {name="flowers:waterlily", count=1, wear=WeaR, metadata=""})
					if MESSAGES == true then say(player, "You caught a Waterlily", false) end -- caught Waterlily					
				end
				if inv:room_for_item("main", {name="fishing:fish_raw", count=1, wear=0, metadata=""}) then
					inv:add_item("main", {name="fishing:fish_raw", count=1, wear=0, metadata=""})
					if MESSAGES == true then say(player, "The bait is still there.", false) end -- bait still there
				end	
			elseif self.object:get_hp() <= 300 then
				if math.random(1, 100) < SHARK_CHANCE then
					local 	chance = 		math.random(1, 6) -- ><((((º>
					for i in pairs(CaTCH_BiG) do
						local 	MoD = 			CaTCH_BiG[i][1]
						local 	iTeM = 			CaTCH_BiG[i][2]
						local 	WeaR = 			CaTCH_BiG[i][3]
						local 	MeSSaGe = 		CaTCH_BiG[i][4]
						local 	GeTBaiTBack = 	CaTCH_BiG[i][5]
						local 	NRMiN = 		CaTCH_BiG[i][6]
						local 	CHaNCe = 		CaTCH_BiG[i][7]
						local 	NRMaX = 		NRMiN + CHaNCe - 1
						if chance <= NRMaX and chance >= NRMiN then
							if minetest.get_modpath(MoD) ~= nil then
								if inv:room_for_item("main", {name=MoD..":"..iTeM, count=1, wear=WeaR, metadata=""}) then
									inv:add_item("main", {name=MoD..":"..iTeM, count=1, wear=WeaR, metadata=""})
									if MESSAGES == true then say(player, "You caught "..MeSSaGe, false) end -- caught somethin'					
								end
								if GeTBaiTBack == true then
									if inv:room_for_item("main", {name="fishing:fish_raw", count=1, wear=0, metadata=""}) then
										inv:add_item("main", {name="fishing:fish_raw", count=1, wear=0, metadata=""})
										if MESSAGES == true then say(player, "The bait is still there.", false) end -- bait still there?
									end
								end
							end
						end
					end
				else --if math.random(1, 100) > FISH_CHANCE then
					if MESSAGES == true then say(player, "Your fish escaped.", false) end -- fish escaped
				end
			else 
				if MESSAGES == true then say(player, "You didn't catch anything.", false) end -- fish escaped
				if math.random(1, 3) == 1 then
					if inv:room_for_item("main", {name="fishing:fish_raw", count=1, wear=0, metadata=""}) then
						inv:add_item("main", {name="fishing:fish_raw", count=1, wear=0, metadata=""})
						if MESSAGES == true then say(player, "The bait is still there.", false) end -- bait still there
					end	
				end
			end
		else 
			if MESSAGES == true then say(player, "Your fish escaped.", false) end -- fish escaped		
		end
		minetest.sound_play("fishing_bobber1", {
			pos = self.object:getpos(),
			gain = 0.5,
		})
		self.object:remove()
	end,
-- AS SOON AS THE BOBBER IS PLACED IT WILL ACT LIKE
	on_step = function(self, dtime)
		local pos = self.object:getpos()
		if BOBBER_CHECK_RADIUS > 0 then
			local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, BOBBER_CHECK_RADIUS)
			for k, obj in pairs(objs) do
				if obj:get_luaentity() ~= nil then
					if obj:get_luaentity().name == "fishing:bobber_entity_shark" then
						if obj:get_luaentity() ~= self then
							self.object:remove()
						end
					end
				end
			end
		end
		if math.random(1, 4) == 1 then
			self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/2880*math.pi))
		end
		for _,player in pairs(minetest.get_connected_players()) do
			local s = self.object:getpos()
			local p = player:getpos()
			local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
			if dist > self.view_range then
				minetest.sound_play("fishing_bobber1", {
					pos = self.object:getpos(),
					gain = 0.5,
				})
				self.object:remove()
			end
		end	
		local do_env_damage = function(self)
			self.object:set_hp(self.object:get_hp()-self.water_damage)
			if self.object:get_hp() == 600 then
				self.object:moveto({x=pos.x,y=pos.y-0.015625,z=pos.z})
			elseif self.object:get_hp() == 595 then
				self.object:moveto({x=pos.x,y=pos.y+0.015625,z=pos.z})
			elseif self.object:get_hp() == 590 then
				self.object:moveto({x=pos.x,y=pos.y+0.015625,z=pos.z})
			elseif self.object:get_hp() == 585 then
				self.object:moveto({x=pos.x,y=pos.y-0.015625,z=pos.z})
				self.object:set_hp(self.object:get_hp()-(math.random(1, 200)))
			elseif self.object:get_hp() == 300 then
				minetest.sound_play("fishing_bobber1", {
					pos = self.object:getpos(),
					gain = 0.7,
				})
				minetest.add_particlespawner(40, 0.5,   -- for how long (?)             -- Particles on splash
					{x=pos.x,y=pos.y-0.0625,z=pos.z}, {x=pos.x,y=pos.y-0.2,z=pos.z}, -- position min, pos max
					{x=-3,y=-0.0625,z=-3}, {x=3,y=5,z=3}, -- velocity min, vel max
					{x=0,y=-9.8,z=0}, {x=0,y=-9.8,z=0},
					0.3, 2.4,
					0.25, 0.5,  -- min size, max size
					false, "default_snow.png")
				self.object:moveto({x=pos.x,y=pos.y-0.625,z=pos.z})
			elseif self.object:get_hp() == 295 then
				self.object:moveto({x=pos.x,y=pos.y+0.425,z=pos.z})
			elseif self.object:get_hp() == 290 then
				self.object:moveto({x=pos.x,y=pos.y+0.0625,z=pos.z})
			elseif self.object:get_hp() == 285 then
				self.object:moveto({x=pos.x,y=pos.y-0.0625,z=pos.z})
			elseif self.object:get_hp() < 284 then	
				self.object:moveto({x=pos.x+(0.001*(math.random(-8, 8))),y=pos.y,z=pos.z+(0.001*(math.random(-8, 8)))})
				self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/720*math.pi))
			elseif self.object:get_hp() == 0 then
				minetest.sound_play("fishing_bobber1", {
					pos = self.object:getpos(),
					gain = 0.5,
				})
				self.object:remove()
			end
		end
		do_env_damage(self)
	end,
}

minetest.register_entity("fishing:bobber_entity_shark", FISHING_BOBBER_ENTITY_SHARK)