-- Copyright (c) 2024 lightningund
-- Part of Belt Reskin
--
-- See LICENSE.md in the project directory for license information.

-- Generally useful functions

-- Make our function host
if not belt_reskin then belt_reskin = {} end

-- Standardize the belt icons
---@return table table a complete item icons definition
---@param tint Color Color of the arrows
function belt_reskin.transport_belt_icon(tint)
	return {
		{
			icon = "__belt-reskin__/graphics/icons/belt-base.png",
			icon_size = 64,
			icon_mipmaps = 4
		},
		{
			icon = "__belt-reskin__/graphics/icons/belt-arrows.png",
			icon_size = 64,
			icon_mipmaps = 4,
			tint = tint
		}
	}
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

-- Retint the deadlock loader entity
function belt_reskin.retint_deadlock_loader(entity, tint)
	entity.icons[2].tint = tint

	entity.structure.direction_in.sheets[3].tint = tint
	entity.structure.direction_in.sheets[3].hr_version.tint = tint
	entity.structure.direction_out.sheets[3].tint = tint
	entity.structure.direction_out.sheets[3].hr_version.tint = tint
end

-- "average a colour with off-white, to get a brighter contrast colour for lamps and lights"
-- used by deadlock, using here for consistency
-- directly taken from deadlock-beltboxes-loaders by Deadlock989, Shane Madden
local function brighter_colour(c)
	local w = 240
	return { r = math.floor((c.r + w)/2), g = math.floor((c.g + w)/2), b = math.floor((c.b + w)/2) }
end

function belt_reskin.retint_deadlock_beltbox(entity, tint)
	entity.icons[2].tint = tint

	entity.animation.layers[2].tint = tint
	entity.animation.layers[2].hr_version.tint = tint
	entity.working_visualisations[1].animation.tint = tint
	entity.working_visualisations[1].animation.hr_version.tint = brighter_colour(tint)
	entity.working_visualisations[1].light.color = brighter_colour(tint)
end

function belt_reskin.retint_mini_loader(entity, tint)
	entity.structure.direction_in.sheets[2].tint = tint
	entity.structure.direction_in.sheets[2].hr_version.tint = tint
	entity.structure.direction_out.sheets[2].tint = tint
	entity.structure.direction_out.sheets[2].hr_version.tint = tint
end

function belt_reskin.retint_mini_loader_ins(entity, tint)
	entity.platform_picture.sheets[2].tint = tint
	entity.platform_picture.sheets[2].hr_version.tint = tint
end