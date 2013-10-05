-----------------------------------------------------------------------------------------------
-- Fishing - Mossmanikin's version - Bobber 0.1.6
-- License (code & textures): 	WTFPL
-- Contains code from: 		fishing (original), mobs, throwing, volcano
-- Supports:				3d_armor, animal_clownfish, animal_fish_blue_white, animal_rat, flowers_plus, mobs, seaplants
-----------------------------------------------------------------------------------------------

local PoLeWeaR = (65535/(30-(math.random(15, 29))))
local BooTSWear = (2000*(math.random(20, 29)))
-- Here's what you can catch
local CaTCH = {
--	  MoD 						 iTeM				WeaR		 MeSSaGe ("You caught "..)	GeTBaiTBack		NRMiN  	CHaNCe (../120)
    {"fishing",  				"fish_raw",			0,			"a Fish.",					false,			1,		60},
	{"animal_clownfish",		"clownfish",		0,			"a Clownfish.",				false,			61,		10},
	{"animal_fish_blue_white",	"fish_blue_white",	0,			"a Blue white fish.",		false,			71,		10},
	{"default",					"stick",			0,			"a Twig.",					true,			81,		2},
	{"mobs",					"rat",				0,			"a Rat.",					false,			83,		1},
    {"animal_rat",				"rat",				0,			"a Rat.",					false,			84,		1},
	{"",						"rat",				0,			"a Rat.",					false,			85,		1},
	{"flowers_plus",			"seaweed",			0,			"some Seaweed.",			true,			86,		20},
	{"seaplants",				"leavysnackgreen",	0,			"a Leavy Snack.",			true,			106,	10},
	{"farming",					"string",			0,			"a String.",				true,			116,	2},
	{"fishing",					"pole",				PoLeWeaR,	"an old Fishing Pole.",		true,			118,	2},
	{"3d_armor",				"boots_wood",		BooTSWear,	"some very old Boots.",		true,			120,	1},
}
minetest.register_alias("flowers_plus:seaweed", "flowers:seaweed") -- exception

minetest.register_node("fishing:bobber_box", {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
--			{ left, bottom, front,  right, top ,  back}
			{-8/16, -8/16,     0,  8/16,  8/16,     0}, -- feathers
			{-2/16, -8/16, -2/16,  2/16, -4/16,  2/16},	-- bobber
		}
	},
	tiles = {
		"fishing_bobber_top.png",
		"fishing_bobber_bottom.png",
		"fishing_bobber.png",
		"fishing_bobber.png",
		"fishing_bobber.png",
		"fishing_bobber.png^[transformFX"
	}, -- 
	groups = {not_in_creative_inventory=1},
})

local FISHING_BOBBER_ENTITY={
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
		local inv = puncher:get_inventory()
		if MESSAGES == true then minetest.chat_send_player(player, "You didn't catch anything.", false) end -- fish escaped
		if inv:room_for_item("main", {name="fishing:bait_worm", count=1, wear=0, metadata=""}) then
			inv:add_item("main", {name="fishing:bait_worm", count=1, wear=0, metadata=""})
			if MESSAGES == true then minetest.chat_send_player(player, "The bait is still there.", false) end -- bait still there
		end	
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
		if item:get_name() == "fishing:pole" then
			local inv = clicker:get_inventory()
			--local room_fish = inv:room_for_item("main", {name="fishing:fish_raw", count=1, wear=0, metadata=""})
			local say = minetest.chat_send_player
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
				if inv:room_for_item("main", {name="fishing:bait_worm", count=1, wear=0, metadata=""}) then
					inv:add_item("main", {name="fishing:bait_worm", count=1, wear=0, metadata=""})
					if MESSAGES == true then say(player, "The bait is still there.", false) end -- bait still there
				end	
			elseif self.object:get_hp() <= 300 then
				if math.random(1, 100) < FISH_CHANCE then
					local 	chance = 		math.random(1, 120) -- ><((((º>
					for i in pairs(CaTCH) do
					local 	MoD = 			CaTCH[i][1]
					local 	iTeM = 			CaTCH[i][2]
					local 	WeaR = 			CaTCH[i][3]
					local 	MeSSaGe = 		CaTCH[i][4]
					local 	GeTBaiTBack = 	CaTCH[i][5]
					local 	NRMiN = 		CaTCH[i][6]
					local 	CHaNCe = 		CaTCH[i][7]
					local 	NRMaX = 		NRMiN + CHaNCe - 1
					if chance <= NRMaX and chance >= NRMiN then
						if minetest.get_modpath(MoD) ~= nil then
							if inv:room_for_item("main", {name=MoD..":"..iTeM, count=1, wear=WeaR, metadata=""}) then
								inv:add_item("main", {name=MoD..":"..iTeM, count=1, wear=WeaR, metadata=""})
								if MESSAGES == true then say(player, "You caught "..MeSSaGe, false) end -- caught somethin'					
							end
							if GeTBaiTBack == true then
								if inv:room_for_item("main", {name="fishing:bait_worm", count=1, wear=0, metadata=""}) then
									inv:add_item("main", {name="fishing:bait_worm", count=1, wear=0, metadata=""})
									if MESSAGES == true then say(player, "The bait is still there.", false) end -- bait still there?
								end
							end
						else
							if inv:room_for_item("main", {name="fishing:fish_raw", count=1, wear=0, metadata=""}) then
								inv:add_item("main", {name="fishing:fish_raw", count=1, wear=0, metadata=""})
								if MESSAGES == true then say(player, "You caught a Fish.", false) end -- caught Fish
							end
						end
					end
					end
				else --if math.random(1, 100) > FISH_CHANCE then
					if MESSAGES == true then say(player, "Your fish escaped.", false) end -- fish escaped
				end
			else -- if self.object:get_hp() > 300 then
				if MESSAGES == true then say(player, "You didn't catch anything.", false) end -- fish escaped
				if math.random(1, 2) == 1 then
					if inv:room_for_item("main", {name="fishing:bait_worm", count=1, wear=0, metadata=""}) then
						inv:add_item("main", {name="fishing:bait_worm", count=1, wear=0, metadata=""})
						if MESSAGES == true then say(player, "The bait is still there.", false) end -- bait still there
					end	
				end
			end
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
					if obj:get_luaentity().name == "fishing:bobber_entity" then
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
				self.object:set_hp(self.object:get_hp()-(math.random(1, 275)))
			elseif self.object:get_hp() == 300 then
				minetest.sound_play("fishing_bobber1", {
					pos = self.object:getpos(),
					gain = 0.5,
				})
				minetest.add_particlespawner(30, 0.5,   -- for how long (?)             -- Particles on splash
					{x=pos.x,y=pos.y-0.0625,z=pos.z}, {x=pos.x,y=pos.y,z=pos.z}, -- position min, pos max
					{x=-2,y=-0.0625,z=-2}, {x=2,y=3,z=2}, -- velocity min, vel max
					{x=0,y=-9.8,z=0}, {x=0,y=-9.8,z=0},
					0.3, 1.2,
					0.25, 0.5,  -- min size, max size
					false, "default_snow.png")
				self.object:moveto({x=pos.x,y=pos.y-0.0625,z=pos.z})
			elseif self.object:get_hp() == 295 then
				self.object:moveto({x=pos.x,y=pos.y+0.0625,z=pos.z})
			elseif self.object:get_hp() == 290 then
				self.object:moveto({x=pos.x,y=pos.y+0.0625,z=pos.z})
			elseif self.object:get_hp() == 285 then
				self.object:moveto({x=pos.x,y=pos.y-0.1,z=pos.z})
			elseif self.object:get_hp() < 284 then	
				self.object:moveto({x=pos.x+(0.001*(math.random(-8, 8))),y=pos.y,z=pos.z+(0.001*(math.random(-8, 8)))})
				self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/1440*math.pi))
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

minetest.register_entity("fishing:bobber_entity", FISHING_BOBBER_ENTITY)