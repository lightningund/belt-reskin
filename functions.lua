-- Copyright (c) 2024 lightningund
-- Part of Belt Reskin
--
-- See LICENSE.md in the project directory for license information.

-- Generally useful functions

-- Make our function host
if not belt_reskin then belt_reskin = {} end

local function icon(file, tint)
	return {
		{
			icon = "__belt-reskin__/graphics/icons/" .. file .. "-base.png",
			icon_size = 64,
			icon_mipmaps = 4
		},
		{
			icon = "__belt-reskin__/graphics/icons/" .. file .. "-mask.png",
			icon_size = 64,
			icon_mipmaps = 4,
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
			filename = "__belt-reskin__/graphics/entity/transport-belt/" .. variant .. "belt" .. file .. ".png",
			priority = "extra-high",
			width = 64,
			height = 64,
			frame_count = frames,
			direction_count = 20,
			tint = tint,
			hr_version = {
				filename = "__belt-reskin__/graphics/entity/transport-belt/hr-" .. variant .. "belt" .. file .. ".png",
				priority = "extra-high",
				width = 128,
				height = 128,
				scale = 0.5,
				frame_count = frames,
				direction_count = 20,
				tint = tint
			}
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
					filename = "__belt-reskin__/graphics/entity/underground-belt/underground-base.png",
					priority = "extra-high",
					width = 96,
					height = 96,
					y = yoff,
					hr_version = {
						filename = "__belt-reskin__/graphics/entity/underground-belt/hr-underground-base.png",
						priority = "extra-high",
						width = 192,
						height = 192,
						y = yoff * 2,
						scale = 0.5
					}
				},
				{
					filename = "__belt-reskin__/graphics/entity/underground-belt/underground-arrows.png",
					priority = "extra-high",
					width = 96,
					height = 96,
					y = yoff,
					tint = tint,
					hr_version = {
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
			filename = "__belt-reskin__/graphics/entity/splitter/splitter-" .. file .. ".png",
			priority = "extra-high",
			width = width,
			height = height,
			shift = util.by_pixel(shiftx, shifty),
			hr_version = {
				filename = "__belt-reskin__/graphics/entity/splitter/hr-splitter-" .. file .. ".png",
				priority = "extra-high",
				width = width * 2,
				height = height * 2,
				shift = util.by_pixel(shiftx, shifty),
				scale = 0.5
			}
		}

		if sheet then
			obj.frame_count = 32
			obj.line_length = 8
			obj.hr_version.frame_count = 32
			obj.hr_version.line_length = 8
		else
			obj.repeat_count = 32
			obj.hr_version.repeat_count = 32
		end

		if hastint then
			obj.tint = tint
			obj.hr_version.tint = tint
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
		end

		if item then
			item.subgroup = subgroup

			local recipe = data.raw["recipe"][item.name]
			if recipe then
				recipe.subgroup = subgroup
			end
		end
	end
end

function belt_reskin.regroup_vanilla(entities)
	regroup(entities.belt_item, "belts", "a0")
	regroup(entities.splitter_item, "splitters", "a1")
	regroup(entities.underground_item, "underground-belts", "a2")
end

function belt_reskin.retint_miniloader(entities, tint)
	local function retint(loader, ins, item, tint)
		loader.structure.direction_in.sheets[2].tint = tint
		loader.structure.direction_in.sheets[2].hr_version.tint = tint
		loader.structure.direction_out.sheets[2].tint = tint
		loader.structure.direction_out.sheets[2].hr_version.tint = tint

		ins.platform_picture.sheets[2].tint = tint
		ins.platform_picture.sheets[2].hr_version.tint = tint

		item.icons[2].tint = tint
	end

	local loader = entities.miniloader
	local ins = entities.miniloader_ins
	local item = entities.miniloader_item
	local f_loader = entities.filter_miniloader
	local f_ins = entities.filter_miniloader_ins
	local f_item = entities.filter_miniloader_item

	if loader and ins and item then
		retint(loader, ins, item, tint)

		regroup(item, "miniloaders", "ba0")
	end

	if f_loader and f_ins and f_item then
		retint(f_loader, f_ins, f_item, tint)

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
		loader.icons[2].tint = tint
		loader.structure.direction_in.sheets[3].tint = tint
		loader.structure.direction_in.sheets[3].hr_version.tint = tint
		loader.structure.direction_out.sheets[3].tint = tint
		loader.structure.direction_out.sheets[3].hr_version.tint = tint

		loader_item.icons[2].tint = tint
		regroup(loader_item, "deadlock-loaders", "bb0")

		beltbox.icons[2].tint = tint
		beltbox.animation.layers[2].tint = tint
		beltbox.animation.layers[2].hr_version.tint = tint
		beltbox.working_visualisations[1].animation.tint = tint
		beltbox.working_visualisations[1].animation.hr_version.tint = brighter_colour(tint)
		beltbox.working_visualisations[1].light.color = brighter_colour(tint)

		beltbox_item.icons[2].tint = tint
		regroup(beltbox_item, "deadlock-beltboxes", "bb1")
	end
end

function belt_reskin.retint_aai(entities, tint)
	local loader = entities.aai_loader
	local pipe = entities.aai_pipe
	local item = entities.aai_item
	local tech = entities.aai_tech
	if loader and pipe and item and tech then
		loader.icons[2].tint = tint
		loader.structure.direction_in.sheets[3].tint = tint
		loader.structure.direction_in.sheets[3].hr_version.tint = tint
		loader.structure.direction_out.sheets[3].tint = tint
		loader.structure.direction_out.sheets[3].hr_version.tint = tint

		pipe.icons[2].tint = tint

		item.icons[2].tint = tint

		tech.icons[2].tint = tint

		regroup(item, "aai-loaders", "bc0")
	end
end

function belt_reskin.retint_loader_redux(entities, tint)
	if mods["LoaderRedux"] then
		local ent = entities.redux_ent
		local itm = entities.redux_item
		if ent and itm then
			ent.icons[2].tint = tint
			ent.structure.direction_in.sheets[2].tint = tint
			ent.structure.direction_in.sheets[2].hr_version.tint = tint
			ent.structure.direction_out.sheets[2].tint = tint
			ent.structure.direction_out.sheets[2].hr_version.tint = tint

			itm.icons[2].tint = tint

			regroup(itm, "redux-loaders", "bd0")
		end
	end
end

function belt_reskin.retint_vanilla_loader(entities, tint)
	if not mods["vanilla-loaders-hd"] then
		return
	end

	local ent = entities.vl_ent
	local itm = entities.vl_item

	if ent and itm then
		ent.icons[2].tint = tint
		ent.structure.direction_in.sheets[2].tint = tint
		ent.structure.direction_in.sheets[2].hr_version.tint = tint
		ent.structure.direction_out.sheets[2].tint = tint
		ent.structure.direction_out.sheets[2].hr_version.tint = tint

		itm.icons[2].tint = tint

		regroup(itm, "vanilla-loaders", "be0")
	end
end