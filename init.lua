--[[
badprivs

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

--------------------------------------------------------------------------------
local title = "Priveleges groups mod"
local version = "0.0.1"
local mname = "badprivs"
local MP = core.get_modpath("badprivs")
local S = core.get_translator("badprivs")
--------------------------------------------------------------------------------
--dofile(core.get_modpath("badprivs").."/settings.txt")
--------------------------------------------------------------------------------
local storage = core.get_mod_storage()
badprivs = {}
badprivs.adminPrivs = {badprivs=true}
core.register_privilege("badprivs", {
	description = S("Can manage groups and users."),
	give_to_singleplayer = false
})

function badprivs.set(key, value)
    storage:set_string(key, core.serialize(value))
end

function badprivs.get(key)
    return core.deserialize(storage:get_string(key))
end

function badprivs.initdb()
	local groups = {"default", "basic", "regular", "ranger", "hobbit", "builder", "moder", "admin", "developer", "designer"}
	badprivs.set("groups", groups)
	for key, value in pairs(groups) do
		badprivs.set(value, "")
	end
	return "OK"
end

if not storage:get_string("groups") then
badprivs.initdb()
end


function badprivs.get_groups()
	return badprivs.get("groups")
end


function badprivs.check_group(group)
	groups = badprivs.get("groups")
	if groups.group then return true end
end

function badprivs.check_user(user)
	users = badprivs.get("users")
	if users.user then return true end
end

function badprivs.add_group(group)
	if not badprivs.check_group(group) then
		groups = badprivs.get("groups")
		table.insert(groups, group)
		badprivs.set("groups", groups)
		return true
	end
end


function badprivs.list_groups()
	local groups = badprivs.get_groups()
	local list = ""
	for key, value in pairs(groups) do
		list = list .. " " .. value
	end
	return list
end

function badprivs.add_user(user, group)
	if badprivs.check_group(group) and badprivs.check_user(user) then
		group = badprivs.get(group)
		table.insert(group, user)
		badprivs.set(user, group)
		return true
	end
end

function badprivs.members(group)
	local group = badprivs.get(group)
	local list = ""
	for key, value in pairs(group) do
		list = list .. " " .. value
	end
	return list
end

core.register_chatcommand("groups", {
	description = "List priveleges groups",
	privs = badprivs.adminPrivs,
	func = function()
		if badprivs.check_group(group) then
			return true, "Current groups: ".. badprivs.list_groups()
		else
			return true, "Group not found!"
		end
	end
})

core.register_chatcommand("members", {
	description = "List group member",
	privs = badprivs.adminPrivs,
	func = function(group)
		return true, "Members of "..group..": ".. badprivs.members(group)
	end
})


core.register_chatcommand("badprivs_initdb", {
	description = "Init storage",
	privs = badprivs.adminPrivs,
	func = function()
		return true, "Init storage is " .. badprivs.initdb()
	end
})

core.register_chatcommand("groupadd", {
	description = "Add priveleges group",
	privs = badprivs.adminPrivs,
	func = function(group)
		local status
		if badprivs.add_group(group) then
			status = "succesfully"
		else
			status = "unsuccesfully"
		end
		return true, "Priveleges group is added" .. status
	end
})

core.register_chatcommand("useradd", {
	description = "Add user to group",
	privs = badprivs.adminPrivs,
	func = function(user, group)
		local status
		if badprivs.add_user(user, group) then
			status = "succesfully"
		elseif core.player_exists(user) then
			status = "not exests"
		else
			status = "unsuccefully"
		end
		return true, "User "..user.." added to group " ..group.." ".. status
	end
})



--[[
basic_privs  = shout, home, tp
regular_privs = tp, debug, interact, shout, home, tp
ranger_privs = atlatc, interlocking, itm, minecart, powerline, tp_tpc, ui_full, tp, debug, interact, shout, home, tp
hobbit_privs = atlatc, interlocking, itm, minecart, powerline, tp_tpc, ui_full, tp, debug, interact, shout, home, tp, teleport
builder_privs= areas_high_limit,builder,creative,fly,fast,areas,noclip,train_admin,worldedit,track_builder,train_operator,railway_operator,smartshop_admin,teleport,give, atlatc, interlocking, itm, minecart, powerline, tp_tpc, ui_full, tp, debug, interact, shout, home, tp
older_moder  = ban,bring,kick, areas_high_limit,builder,creative,fly,fast,areas,noclip,train_admin,worldedit,track_builder,train_operator,railway_operator,smartshop_admin,teleport,give, atlatc, interlocking, itm, minecart, powerline, tp_tpc, ui_full, tp, debug, interact, shout, home, tp
moder_privs  = ban, bring, fast, kick, teleport, noclip, fly, areas
admin_privs  = all
tech_admin   = all
developer_privs = all
disigner_privs = all


]]--





















if (minetest.settings:get("debug_log_level") == nil)
or (minetest.settings:get("debug_log_level") == "action")
or	(minetest.settings:get("debug_log_level") == "info")
or (minetest.settings:get("debug_log_level") == "verbose")
then

	minetest.log("action", "[Mod] badprivs [v0.0.1] loaded.")
end
