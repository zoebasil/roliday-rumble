-- Entrypoint to game UI
local import = require(game.ReplicatedStorage.Lib.Import)

local Roact = import "Roact"
local HealthBar = import "UI/Components/HealthBar"
local HealthBarTagCollection = import "UI/Components/HealthbarTagCollection"
local DamageOverlay = import "UI/Components/DamageOverlay"

local function App()
	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		HealthBar = Roact.createElement(HealthBar),
		DamageOverlay = Roact.createElement(DamageOverlay),
		HealthBarTagCollection = Roact.createElement(HealthBarTagCollection),
	})
end

return App
