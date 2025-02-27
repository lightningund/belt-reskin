-- Copyright (c) 2024 lightningund
-- Part of Belt Reskin
--
-- See LICENSE.md in the project directory for license information.

-- Generally useful functions

-- Make our function host
if not belt_reskin then belt_reskin = {} end

local function try_assign(obj, prop, val)
	if obj then
		obj[prop] = val
	end
end

local function icon(file, tint)
	return {
		{
			icon = "__belt-reskin__/graphics/icons/" .. file .. "-base.png",
			icon_size = 64
		},
		{
			icon = "__belt-reskin__/graphics/icons/" .. file .. "-mask.png",
			icon_size = 64,
			tint = tint
		}
	}
end

-- Standardize the belt icons
---@return table table a complete item icons definition
---@param tint Color Color of the arrows
function belt_reskin.transport_belt_icon(tint)
	return icon("belt", tint)
end

-- Standardize the splitter icons
---@return table table a complete item icons definition
---@param tint Color Color of the highlights
function belt_reskin.splitter_icon(tint)
	return icon("splitter", tint)
end

-- Standardize the underground belt icons
---@return table table a complete item icons definition
---@param tint Color Color of the highlights
function belt_reskin.underground_belt_icon(tint)
	return icon("underground-belt", tint)
end

-- Create animation set for transport belts
---@return table table complete animation set definition
---@param arrow_tint Color Color of the arrows
---@param belt_tint Color Color of the surface of the belt
---@param fast boolean Whether to use the fast sprites
function belt_reskin.transport_belt_animation_set(arrow_tint, belt_tint, fast)
	local frames
	local variant

	if fast then
		frames = 32
		variant = "fast-"
	else
		frames = 16
		variant = ""
	end

	local function make_anim(file, tint)
		return {
			filename = "__belt-reskin__/graphics/entity/transport-belt/hr-" .. variant .. "belt" .. file .. ".png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
			frame_count = frames,
			direction_count = 20,
			tint = tint
		}
	end

	return {
		animation_set = {
			layers = {
				make_anim("-base"),
				make_anim("-mask", belt_tint),
				make_anim("-arrows", arrow_tint) -- Might need to be blend_mode: additive
			}
		}
	}
end

-- Create animation set for underground belts
---@return table table complete animation set definition
---@param tint Color Color of the arrows
function belt_reskin.underground_belt_sprite_set(tint)
	local function fourway(yoff)
		return {
			sheets = {
				{
					filename = "__belt-reskin__/graphics/entity/underground-belt/hr-underground-base.png",
					priority = "extra-high",
					width = 192,
					height = 192,
					y = yoff * 2,
					scale = 0.5
				},
				{
					filename = "__belt-reskin__/graphics/entity/underground-belt/hr-underground-arrows.png",
					priority = "extra-high",
					width = 192,
					height = 192,
					y = yoff * 2,
					scale = 0.5,
					tint = tint
				}
			}
		}
	end

	return {
		direction_out = fourway(0),
		direction_in = fourway(96),
		direction_out_side_loading = fourway(96 * 2),
		direction_in_side_loading = fourway(96 * 3),
	}
end

-- Replace the animations of the splitter
---@param entity table The entity coming in
---@param tint Color Color of the arrows
function belt_reskin.splitter_sprite_set(entity, tint)
	local function sprite(file, hastint, width, height, shiftx, shifty, sheet)
		local obj = {
			filename = "__belt-reskin__/graphics/entity/splitter/hr-splitter-" .. file .. ".png",
			priority = "extra-high",
			width = width * 2,
			height = height * 2,
			shift = util.by_pixel(shiftx, shifty),
			scale = 0.5
		}

		if sheet then
			obj.frame_count = 32
			obj.line_length = 8
		else
			obj.repeat_count = 32
		end

		if hastint then
			obj.tint = tint
		end

		return obj
	end

	---@param direction string
	---@param width number
	---@param height number
	local function tinted_pair(direction, width, height, shiftx, shifty)
		return {
			layers = {
				sprite(direction, false, width, height, shiftx, shifty, true),
				sprite(direction .. "-mask", true, width, height, shiftx, shifty, false)
			}
		}
	end

	entity.structure = {
		north = tinted_pair("north", 82, 35, 8, -1),
		south = tinted_pair("south", 82, 35, 4, 0),
		east = tinted_pair("east", 45, 80, 4, -4),
		west = tinted_pair("west", 45, 80, 6, -4)
	}

	entity.structure_patch = nil
end

local function retint(sheet, tint)
	sheet.tint = tint
end

-- Retints ent.structure.direction_in/out.sheets[sheet_num]
local function retint_dir_sheets(ent, sheet_num, tint)
	retint(ent.structure.direction_in.sheets[sheet_num], tint)
	retint(ent.structure.direction_out.sheets[sheet_num], tint)
end

local function assign_icons(ent, icons)
	if ent then
		ent.icons = icons
		try_assign(data.raw["item"][ent.name], "icons", icons)
		try_assign(data.raw["recipe"][ent.name], "icons", icons)
	end
end

local function regroup(item, subgroup, order)
	if settings.startup["belt-reskin-regroup"].value then
		if not data.raw["item-subgroup"][subgroup] then
			data:extend({
				{
					type = "item-subgroup",
					name = subgroup,
					group = "logistics",
					order = order,
				}
			})
		else
			local sg_data = data.raw["item-subgroup"][subgroup]
			sg_data.name = subgroup
			sg_data.group = "logistics"
			sg_data.order = order
		end

		if item then
			item.subgroup = subgroup
			item.group = "logistics"

			local recipe = data.raw["recipe"][item.name]
			if recipe then
				recipe.subgroup = subgroup
			end
		end
	end
end

local function regroup_name(name, subgroup, order)
	regroup(data.raw["item"][name], subgroup, order)
end

local function regroup_ent(ent, subgroup, order)
	if ent then
		regroup_name(ent.name, subgroup, order)
	end
end

function belt_reskin.regroup_vanilla(entities)
	regroup_ent(entities.belt, "belts", "a0")
	regroup_ent(entities.splitter, "splitters", "a1")
	regroup_ent(entities.underground, "underground-belts", "a2")
end

-- For the vanilla items... and 5dims transport
function belt_reskin.reskin_vanilla(entities, tint)
	-- Reskin the belt icon
	local belt_icons = belt_reskin.transport_belt_icon(tint)
	assign_icons(entities.belt, belt_icons)

	-- Reskin the splitter icon
	local splitter_icons = belt_reskin.splitter_icon(tint)
	assign_icons(entities.splitter, splitter_icons)

	-- Reskin the underground icon
	local underground_icons = belt_reskin.underground_belt_icon(tint)
	assign_icons(entities.underground, underground_icons)

	-- Reskin the splitter entity
	if entities.splitter then
		belt_reskin.splitter_sprite_set(entities.splitter, tint)
	end

	-- Reskin the underground entity
	if entities.underground then
		entities.underground.structure = belt_reskin.underground_belt_sprite_set(tint)
	end

	-- Reskin the 5dims extended undergrounds
	if entities.underground_30 then
		local icons_30 = table.deepcopy(underground_icons)
		icons_30[3] = {
			icon = "__belt-reskin__/graphics/icons/underground-belt-30-mask.png",
			icon_size = 64
		}

		assign_icons(entities.underground_30, icons_30)
		regroup_ent(entities.underground_30, "underground-belts-30", "a3")
	end

	-- Reskin the 5dims extendeder undergrounds
	if entities.underground_50 then
		local icons_50 = table.deepcopy(underground_icons)
		icons_50[3] = {
			icon = "__belt-reskin__/graphics/icons/underground-belt-50-mask.png",
			icon_size = 64
		}

		assign_icons(entities.underground_50, icons_50)
		regroup_ent(entities.underground_50, "underground-belts-50", "a4")
	end
end

function belt_reskin.retint_miniloader(entities, tint)
	local loader = entities.miniloader
	local ins = entities.miniloader_ins
	local item = entities.miniloader_item
	local f_loader = entities.filter_miniloader
	local f_ins = entities.filter_miniloader_ins
	local f_item = entities.filter_miniloader_item

	if loader and ins and item then
		retint_dir_sheets(loader, 2, tint)

		retint(ins.platform_picture.sheets[2], tint)

		retint(item.icons[2], tint)

		regroup(item, "miniloaders", "ba0")
	end

	if f_loader and f_ins and f_item then
		retint_dir_sheets(f_loader, 2, tint)

		retint(f_ins.platform_picture.sheets[2], tint)

		retint(f_item.icons[2], tint)

		regroup(f_item, "filter-miniloaders", "ba1")
	end
end

function belt_reskin.retint_deadlock(entities, tint)
	-- "average a colour with off-white, to get a brighter contrast colour for lamps and lights"
	-- used by deadlock, using here for consistency
	-- directly taken from deadlock-beltboxes-loaders by Deadlock989, Shane Madden
	local function brighter_colour(c)
		local w = 240
		return { r = math.floor((c.r + w)/2), g = math.floor((c.g + w)/2), b = math.floor((c.b + w)/2) }
	end

	local loader = entities.deadlock_loader
	local loader_item = entities.deadlock_loader_item
	local beltbox = entities.deadlock_beltbox
	local beltbox_item = entities.deadlock_beltbox_item

	if loader and loader_item and beltbox and beltbox_item then
		retint_dir_sheets(loader, 3, tint)

		retint(loader.icons[2], tint)
		retint(loader_item.icons[2], tint)

		regroup(loader_item, "deadlock-loaders", "bb0")

		retint(beltbox.graphics_set.animation.layers[2], tint)
		retint(beltbox.graphics_set.working_visualisations[1].animation, tint)

		beltbox.graphics_set.working_visualisations[1].light.color = brighter_colour(tint)

		retint(beltbox.icons[2], tint)
		retint(beltbox_item.icons[2], tint)

		regroup(beltbox_item, "deadlock-beltboxes", "bb1")
	end
end

function belt_reskin.retint_aai(entities, tint)
	local loader = entities.aai_loader
	local pipe = entities.aai_pipe
	local item = entities.aai_item
	local tech = entities.aai_tech

	if loader and pipe and item and tech then
		retint_dir_sheets(loader, 3, tint)

		retint(loader.icons[2], tint)
		retint(item.icons[2], tint)
		retint(pipe.icons[2], tint)
		retint(tech.icons[2], tint)

		regroup(item, "aai-loaders", "bc0")
	end
end

function belt_reskin.retint_loader_redux(entities, tint)
	local ent = entities.redux_ent
	local itm = entities.redux_item

	if ent and itm then
		retint_dir_sheets(ent, 2, tint)

		retint(ent.icons[2], tint)
		retint(itm.icons[2], tint)

		regroup(itm, "redux-loaders", "bd0")
	end
end

function belt_reskin.retint_vanilla_loader(entities, tint)
	local ent = entities.vl_ent
	local itm = entities.vl_item

	if ent and itm then
		retint_dir_sheets(ent, 2, tint)

		retint(ent.icons[2], tint)
		retint(itm.icons[2], tint)

		regroup(itm, "vanilla-loaders", "be0")
	end
end

function belt_reskin.retint_modernized_loaders(entities, tint)
	local ent = entities.modern_ent
	local itm = entities.modern_item

	if ent and itm then
		local using_aai_graphics = settings.startup["mdrn-use-aai-graphics"]
		if using_aai_graphics and using_aai_graphics.value then
			retint_dir_sheets(ent, 3, tint)
		else
			retint_dir_sheets(ent, 2, tint)
		end

		retint(ent.icons[2], tint)
		retint(itm.icons[2], tint)

		regroup(itm, "modernized-loaders", "bf0")
	end
end