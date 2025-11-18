for _, planet in pairs(game.planets) do
	if planet.name == "fulgora" and planet.surface then
		local surface = planet.surface
		local map_gen_settings = surface.map_gen_settings

		map_gen_settings.autoplace_controls["holmium-sludge"] = {}
		map_gen_settings.autoplace_settings.entity.settings["holmium-sludge"] = {}

		surface.map_gen_settings = map_gen_settings

		surface.regenerate_entity("holmium-sludge")

		game.print("⚓Holmium Sludge was properly added to surface of Fulgora. Search in new chunks to find it!⚓")
	end
end
