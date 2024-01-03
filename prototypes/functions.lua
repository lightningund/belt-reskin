-- Copyright (c) 2024 lightningund
-- Part of Belt Reskin
--
-- See LICENSE.md in the project directory for license information.

-- Generally useful functions

-- Make our function host
if not belt_reskin then belt_reskin = {} end

-- Ensure tint is normalized to between 0 and 1
local function normalize_tint(tint)
	local r = tint.r or tint[1]
	local g = tint.g or tint[2]
	local b = tint.b or tint[3]
	local a

	if r > 255 or g > 255 or b > 255 then
		r = r / 255
		g = g / 255
		b = b / 255
		a = tint.a / 255 or tint[4] / 255 or 1
	end

	return { r = r, g = g, b = b, a = a }
end

-- Adjust the alpha value of a given tint
function belt_reskin.adjust_alpha(tint, alpha)
	local tint = normalize_tint(tint)
	local adjusted_tint = { r = tint.r, g = tint.g, b = tint.b, a = alpha }
	return adjusted_tint
end

-- Make an icon_pictures table for reskins-library
function belt_reskin.transport_belt_picture(tint, use_reskin_process)
	local standard_icon = belt_reskin.transport_belt_icon(tint, use_reskin_process)
	local icon_pictures = { layers = {} }

	for _, layer in pairs(standard_icon) do
		table.insert(icon_pictures.layers, {
			filename = layer.icon,
			size = layer.icon_size,
			mipmaps = layer.icon_mipmaps,
			scale = 0.25,
			tint = layer.tint,
		})
	end

	return icon_pictures
end

----------------------------------------------------------------------------------------------------
-- BELT COLORING API
----------------------------------------------------------------------------------------------------

--[[
Need
	Icons
		X Belts
		Underground
		Splitters
		Beltboxes
		Loaders (Vanilla)
		Loaders (Deadlock)
		Loaders (mini)
		Filter Loaders (mini)
	Animations
		X Belts
		X Underground
		X Splitters
		X Beltboxes
		Loaders (Vanilla)
		X Loaders (Deadlock)
		X Loaders (mini) (sort of, the ultimate belts ones don't work for some reason)
		X Filter Loaders (mini)
	Remnants
		Belts
		Underground
		Splitters
		Beltboxes
		Loaders (Vanilla)
		Loaders (Deadlock)
		Loaders (mini)
		Filter Loaders (mini)
--]]

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

-- LOGISTICS TECHNOLOGY ICONS
-- Returns a complete technology icons definition
-- inputs   Table of parameters:
--      base_tint            Types/Color     Color to tint the base sprite (gears, rails) [Optional; default nil]
--      mask_tint            Types/Color     Color to tint the mask sprite (belt surface, arrows) [Optional; default nil]
--      use_reskin_process   Boolean         When true, uses the icons compliant with Artisanal Reskins version 2.0.0+ [Optional; default nil]
-- function belt_reskin.logistics_technology_icon(inputs)
-- 	local technology_icons
-- 	if inputs.use_reskin_process then
-- 		technology_icons = {
-- 			{
-- 				icon = "__prismatic-belts__/graphics/technology/reskins/logistics-technology-base.png",
-- 				icon_size = 256,
-- 				icon_mipmaps = 4,
-- 				tint = inputs.base_tint and belt_reskin.adjust_alpha(inputs.base_tint, 1)
-- 			},
-- 			{
-- 				icon = "__prismatic-belts__/graphics/technology/reskins/logistics-technology-mask.png",
-- 				icon_size = 256,
-- 				icon_mipmaps = 4,
-- 				tint = inputs.mask_tint,
-- 			},
-- 			{
-- 				icon = "__prismatic-belts__/graphics/technology/reskins/logistics-technology-highlights.png",
-- 				icon_size = 256,
-- 				icon_mipmaps = 4,
-- 				tint = { 1, 1, 1, 0 },
-- 			}
-- 		}
-- 	else
-- 		technology_icons = {
-- 			{
-- 				icon = "__prismatic-belts__/graphics/technology/standard/logistics-technology-base.png",
-- 				icon_size = 256,
-- 				icon_mipmaps = 4,
-- 				tint = inputs.base_tint and belt_reskin.adjust_alpha(inputs.base_tint, 1)
-- 			},
-- 			{
-- 				icon = "__prismatic-belts__/graphics/technology/standard/logistics-technology-mask.png",
-- 				icon_size = 256,
-- 				icon_mipmaps = 4,
-- 				tint = inputs.mask_tint,
-- 			}
-- 		}
-- 	end

-- 	return technology_icons
-- end

-- TRANSPORT BELT REMNANTS
-- This function reskins (or creates as needed) appropriate transport belt remnants
-- name     Prototype name of the transport belt
-- inputs   Table of parameters:
--      base_tint               Types/Color     Color to tint the base sprite (gears, rails) [Optional; default nil]
--      mask_tint               Types/Color     Color to tint the mask sprite (belt surface, arrows) [Optional; default nil]
--      brighten_arrows         Boolean         When true, blends a white arrow with the underlying tinted belts to brighen the arrows [Optional; default nil]
--      use_reskin_process      Boolean         When true, uses the tintable color masks consistent with Artisanal Reskins version 2.0.0+ [Optional; default nil]
-- function belt_reskin.create_remnant(name, inputs)
-- 	local remnant_layers

-- 	-- Returns a tailored layer of the belt remnants
-- 	-- inputs   Table of parameters:
-- 	--      blend_mode          String          Blending mode for the layer
-- 	--      directory           String          "standard" or "reskins", determines types of color masks to use
-- 	--      layer               String          "base", "mask" or "arrows" (standard), or "base", "mask" or "highlights" (reskins). Determines specific spritesheet used by the layer
-- 	--      tint                Types/Color     Color to tint the layer
-- 	local function return_remnant_layer(inputs)
-- 		-- Point to appropriate sprite directory
-- 		local directory = inputs.directory or "standard"

-- 		return
-- 		{
-- 			filename = "__prismatic-belts__/graphics/entity/" .. directory .. "/remnants/transport-belt-remnants-" .. inputs.layer .. ".png",
-- 			line_length = 1,
-- 			width = 54,
-- 			height = 52,
-- 			frame_count = 1,
-- 			variation_count = 1,
-- 			axially_symmetrical = false,
-- 			direction_count = 4,
-- 			tint = inputs.tint,
-- 			blend_mode = inputs.blend_mode,
-- 			shift = util.by_pixel(1, 0),
-- 			hr_version = {
-- 				filename = "__prismatic-belts__/graphics/entity/" .. directory .. "/remnants/hr-transport-belt-remnants-" .. inputs.layer .. ".png",
-- 				line_length = 1,
-- 				width = 106,
-- 				height = 102,
-- 				frame_count = 1,
-- 				variation_count = 1,
-- 				axially_symmetrical = false,
-- 				direction_count = 4,
-- 				tint = inputs.tint,
-- 				blend_mode = inputs.blend_mode,
-- 				shift = util.by_pixel(1, -0.5),
-- 				scale = 0.5,
-- 			}
-- 		}
-- 	end

-- 	-- Setup belt transport set
-- 	if inputs.use_reskin_process then
-- 		remnant_layers = {
-- 			return_remnant_layer { directory = "reskins", layer = "base", tint = inputs.base_tint and belt_reskin.adjust_alpha(inputs.base_tint, 1) or nil },
-- 			return_remnant_layer { directory = "reskins", layer = "mask", tint = inputs.mask_tint },
-- 			return_remnant_layer { directory = "reskins", layer = "highlights", blend_mode = "additive" },
-- 		}
-- 	else
-- 		remnant_layers = {
-- 			return_remnant_layer { layer = "base", tint = inputs.base_tint and belt_reskin.adjust_alpha(inputs.base_tint, 1) or nil },
-- 			return_remnant_layer { layer = "mask", tint = inputs.mask_tint },
-- 		}

-- 		if inputs.brighten_arrows then
-- 			table.insert(remnant_layers, return_remnant_layer { layer = "arrows", tint = util.color("4"), blend_mode = "additive-soft" })
-- 		end
-- 	end

-- 	-- Fetch remnant
-- 	local remnants = data.raw["corpse"][name .. "-remnants"]

-- 	-- If there is no existing remnant, create one
-- 	if not remnants then
-- 		remnants = {
-- 			type = "corpse",
-- 			name = "prismatic-belts-" .. name .. "-remnants",
-- 			icons = data.raw["transport-belt"][name].icons,
-- 			icon = data.raw["transport-belt"][name].icon,
-- 			icon_size = data.raw["transport-belt"][name].icon_size,
-- 			icon_mipmaps = data.raw["transport-belt"][name].icon_mipmaps,
-- 			flags = { "placeable-neutral", "not-on-map" },
-- 			subgroup = "belt-remnants",
-- 			order = (data.raw.item[name] and data.raw.item[name].order) and data.raw.item[name].order .. "-a[" .. name .. "-remnants]" or "a-a-a",
-- 			selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
-- 			tile_width = 1,
-- 			tile_height = 1,
-- 			selectable_in_game = false,
-- 			time_before_removed = 60 * 60 * 15, -- 15 minutes
-- 			final_render_layer = "remnants",
-- 			animation = make_rotated_animation_variations_from_sheet(2, { layers = remnant_layers })
-- 		}

-- 		data:extend({ remnants })

-- 		-- Assign the corpse
-- 		data.raw["transport-belt"][name].corpse = "prismatic-belts-" .. name .. "-remnants"
-- 	else
-- 		remnants.icons = data.raw["transport-belt"][name].icons
-- 		remnants.icon = data.raw["transport-belt"][name].icon
-- 		remnants.icon_size = data.raw["transport-belt"][name].icon_size
-- 		remnants.animation = make_rotated_animation_variations_from_sheet(2, { layers = remnant_layers })
-- 	end
-- end
