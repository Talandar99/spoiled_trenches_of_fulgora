local resource_autoplace = require("resource-autoplace")
local r = data.raw.resource["holmium-sludge"]
if r then
	r.autoplace = r.autoplace
		or resource_autoplace.resource_autoplace_settings({
			name = "holmium-sludge",
			order = "b",
			base_density = 1,
			base_spots_per_km2 = 1.8,
			random_probability = 1 / 100,
			random_spot_size_minimum = 1,
			random_spot_size_maximum = 2,
			additional_richness = 250000,
			has_starting_area_placement = false,
			regular_rq_factor_multiplier = 1,
			planet = "fulgora",
		})
end
local planet = data.raw.planet and data.raw.planet["fulgora"]
local mgs = planet.map_gen_settings or {}
mgs.autoplace_controls = mgs.autoplace_controls or {}
mgs.autoplace_controls["holmium-sludge"] = mgs.autoplace_controls["holmium-sludge"]
	or {
		frequency = 3,
		size = 1.2,
		richness = 2,
		starting_area = false,
	}

mgs.autoplace_settings = mgs.autoplace_settings or {}
mgs.autoplace_settings["entity"] = mgs.autoplace_settings["entity"] or { settings = {} }
mgs.autoplace_settings["entity"].settings["holmium-sludge"] = mgs.autoplace_settings["entity"].settings["holmium-sludge"]
	or {}

planet.map_gen_settings = mgs
