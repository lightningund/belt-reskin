-- Copyright (c) 2024 lightningund
-- Part of Belt Reskin
--
-- See LICENSE.md in the project directory for license information.

-- Core functions
require("functions")

local tiers = require("tiers")

local belt_animation_sets = {}

local belt_tint = util.color("FFF")

for prefix, properties in pairs(tiers) do
	local settings_name = "belt-reskin-" .. prefix .. "color"

	-- Of course, nothing is sacred, ultimate belts had to be a little bit goofy
	if prefix == "original-ultimate-" then
		settings_name = "belt-reskin-ultimate-color"
	end

	-- And so did 5dims
	if properties.postfix then
		settings_name = "belt-reskin-5d" .. properties.postfix
	end

	local col ---@type Color
	if settings.startup[settings_name] then
		col = settings.startup[settings_name].value --[[@as Color]]
	else
		col = util.color("ff8000")
	end

	belt_animation_sets[prefix .. properties.suffix] = belt_reskin.transport_belt_animation_set(col, belt_tint, properties.fast)

	local ml_prefix = properties.ml_prefix or prefix

	-- Fetch entities
	local entities = {
		-- Vanilla
		belt = data.raw["transport-belt"][prefix .. properties.suffix],
		splitter = data.raw["splitter"][prefix .. "splitter"],
		underground = data.raw["underground-belt"][prefix .. "underground-belt"]
	}

	if entities.belt then
		local readers = entities.belt.belt_animation_set.belt_reader
		belt_animation_sets[prefix .. properties.suffix].belt_reader = readers
	end

	-- Regroup Vanilla Items
	belt_reskin.regroup_vanilla(entities)

	-- Reskin Vanilla entities and items
	belt_reskin.reskin_vanilla(entities, col)

	-- Miniloader
	if mods["miniloader"] then
		entities["miniloader"] = data.raw["loader-1x1"][ml_prefix .. "miniloader-loader"]
		entities["miniloader_ins"] = data.raw["inserter"][ml_prefix .. "miniloader-inserter"]
		entities["miniloader_item"] = data.raw["item"][ml_prefix .. "miniloader"]
		entities["filter_miniloader"] = data.raw["loader-1x1"][ml_prefix .. "filter-miniloader-loader"]
		entities["filter_miniloader_ins"] = data.raw["inserter"][ml_prefix .. "filter-miniloader-inserter"]
		entities["filter_miniloader_item"] = data.raw["item"][ml_prefix .. "filter-miniloader"]

		belt_reskin.retint_miniloader(entities, col)
	end

	-- Deadlock Stacking Beltboxes and Compact loaders
	if mods["deadlock-beltboxes-loaders"] then
		entities["deadlock_loader"] = data.raw["loader-1x1"][prefix .. properties.suffix .. "-loader"]
		entities["deadlock_loader_item"] = data.raw["item"][prefix .. properties.suffix .. "-loader"]
		entities["deadlock_beltbox"] = data.raw["furnace"][prefix .. properties.suffix .. "-beltbox"]
		entities["deadlock_beltbox_item"] = data.raw["item"][prefix .. properties.suffix .. "-beltbox"]

		belt_reskin.retint_deadlock(entities, col)
	end

	-- AAI Loader
	if mods["aai-loaders"] then
		entities["aai_loader"] = data.raw["loader-1x1"]["aai-" .. prefix .. "loader"]
		entities["aai_pipe"] = data.raw["storage-tank"]["aai-" .. prefix .. "loader-pipe"]
		entities["aai_item"] = data.raw["item"]["aai-" .. prefix .. "loader"]
		entities["aai_tech"] = data.raw["technology"]["aai-" .. prefix .. "loader"]

		belt_reskin.retint_aai(entities, col)
	end

	-- Loader Redux
	if mods["LoaderRedux"] then
		entities["redux_ent"] = data.raw["loader"][prefix .. "loader"]
		entities["redux_item"] = data.raw["item"][prefix .. "loader"]

		belt_reskin.retint_loader_redux(entities, col)
	end

	-- Vanilla Loaders HD
	if mods["vanilla-loaders-hd"] then
		entities["vl_ent"] = data.raw["loader"][ml_prefix .. "loader"]
		entities["vl_item"] = data.raw["item"][ml_prefix .. "loader"]

		belt_reskin.retint_vanilla_loader(entities, col)
	end

	-- Loaders Modernized
	if mods["loaders-modernized"] then
		entities["modern_ent"] = data.raw["loader-1x1"][prefix .. "mdrn-loader"]
		entities["modern_item"] = data.raw["item"][prefix .. "mdrn-loader"]

		belt_reskin.retint_modernized_loaders(entities, col)
	end

	-- 5d-fast-underground-belt-30-02
	-- WHYYY

	-- 5Dims
	if mods["5dim_transport"] then
		if properties.postfix then
			entities["belt"] = data.raw["transport-belt"]["5d-transport-belt" .. properties.postfix]
			entities["splitter"] = data.raw["splitter"]["5d-splitter" .. properties.postfix]
			entities["underground"] = data.raw["underground-belt"]["5d-underground-belt" .. properties.postfix]
			entities["underground_30"] = data.raw["underground-belt"]["5d-underground-belt-30" .. properties.postfix]
			entities["underground_50"] = data.raw["underground-belt"]["5d-underground-belt-50" .. properties.postfix]

			if entities.belt then
				local readers = entities.belt.belt_animation_set.belt_reader
				belt_animation_sets[prefix .. properties.suffix].belt_reader = readers
			end

			belt_reskin.regroup_vanilla(entities)
			belt_reskin.reskin_vanilla(entities, col)

			-- Loaders Modernized x 5Dims
			if mods["loaders-modernized"] then
				entities["modern_ent"] = data.raw["loader-1x1"]["mdrn-loader" .. properties.postfix]
				entities["modern_item"] = data.raw["item"]["mdrn-loader" .. properties.postfix]

				belt_reskin.retint_modernized_loaders(entities, col)
			end
		end
	end

	-- Reskin the belts on all related entity types
	for _, entity in pairs(entities) do
		if entity then
			if entity.belt_animation_set then
				entity.belt_animation_set = belt_animation_sets[prefix .. properties.suffix]
			end
		end
	end
end

local v_loader = data.raw["loader-1x1"]["loader-1x1"]
if v_loader then
	v_loader.belt_animation_set = belt_animation_sets["transport-belt"]
end

if mods["miniloader"] then
	local chute = data.raw["loader-1x1"]["chute-miniloader-loader"]
	local chute_itm = data.raw["item"]["chute-miniloader"]
	local chute_rcp = data.raw["recipe"]["chute-miniloader"]

	if chute then
		chute.belt_animation_set = belt_animation_sets["transport-belt"]

		chute_itm.subgroup = "miniloaders"
		chute_itm.order = "e[miniloader]-0[chute]"
		chute_rcp.subgroup = "miniloaders"
		chute_rcp.order = "e[miniloader]-z[chute]"
	end
end