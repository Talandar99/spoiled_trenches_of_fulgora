-----------------------------------------------------------------------------------------------------------------------
-- storage init
-----------------------------------------------------------------------------------------------------------------------
local function on_init(event)
	storage.oil_rig_collectors = storage.oil_rig_collectors or {}
end
script.on_init(on_init)

local function on_configuration_changed(event)
	storage.oil_rig_collectors = storage.oil_rig_collectors or {}
end
script.on_configuration_changed(on_configuration_changed)
-----------------------------------------------------------------------------------------------------------------------
-- oil rig: spawn/remove hidden lightning collector on Fulgora
-----------------------------------------------------------------------------------------------------------------------

local function on_built_oil_rig(event)
	local rig = event.entity or event.created_entity
	if not (rig and rig.valid and rig.name == "oil_rig") then
		return
	end

	local surface = rig.surface
	if not (surface and surface.valid and (surface.name == "fulgora" or string.find(surface.name, "fulgora"))) then
		return
	end

	storage.oil_rig_collectors = storage.oil_rig_collectors or {}
	storage.oil_rig_collectors[rig.unit_number] = { rig = rig, collector = nil }

	local collector = surface.create_entity({
		name = "or_lightning_collector",
		position = rig.position,
		force = rig.force,
		create_build_effect_smoke = false,
		move_stuck_players = true,
	})
	if collector then
		collector.destructible = false
		collector.operable = false
		storage.oil_rig_collectors[rig.unit_number].collector = collector
	end
end

local function on_removed_oil_rig(event)
	local e = event.entity
	if not (e and e.valid and e.name == "oil_rig") then
		return
	end

	local data = storage.oil_rig_collectors and storage.oil_rig_collectors[e.unit_number]
	if data and data.collector and data.collector.valid then
		data.collector.destroy()
	end
	if storage.oil_rig_collectors then
		storage.oil_rig_collectors[e.unit_number] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------
-- hooks
-----------------------------------------------------------------------------------------------------------------------
script.on_event(defines.events.on_built_entity, function(event)
	local e = event.created_entity or event.entity
	if not e then
		return
	end

	on_built_oil_rig(event)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	local e = event.created_entity or event.entity
	if not e then
		return
	end
	on_built_oil_rig(event)
end)

script.on_event(
	{ defines.events.on_entity_died, defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity },
	function(event)
		local e = event.entity
		if not e then
			return
		end

		on_removed_oil_rig(event)
	end
)
-----------------------------------------------------------------------------------------------------------------------
