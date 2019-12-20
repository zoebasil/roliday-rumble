local import = require(game.ReplicatedStorage.Lib.Import)

local IsValidCharacter = import "GameUtils/IsValidCharacter"
local Players = game:GetService("Players")

local Network = import "Network"
local CombatEvents = import "Data/NetworkEvents/CombatEvents"

local PlayerStateManager = {}
local playerStates = {}

local MAX_HEALTH = 100

local function setupCharacter(player)
	local health = Instance.new("NumberValue")
	health.Name = "HealthVal"
	health.Value = MAX_HEALTH
	health.Parent = player.Character

	for _, part in pairs(player.Character:GetChildren()) do
		if part:IsA("BasePart") then
			part.CustomPhysicalProperties = PhysicalProperties.new(4, 1, 0.1, 2, 2)
		end
	end
end

local function getInitialState(player)
	return {
		characterModel = player.Character,
		health = {
			currentHealth = MAX_HEALTH,
			lastDamagedTime = 0,
			lastRegenedTime = 0,
		},
		ko = {
			knockedOutTime = 0,
			isKnockedOut = false,
		},
		carrying = {
			playerImCarrying = nil,
			playerCarryingMe = nil,
			lastCarriedTime = 0,
			networkOwner = player,
			carryingWeld = nil,
		}
	}
end

function PlayerStateManager.getPlayerStates()
	return playerStates
end

function PlayerStateManager.resetPlayerStates()
	playerStates = {}
	local players = Players:GetPlayers()
	for _, player in pairs(players) do
		local userId = tostring(player.UserId)
		local character = player.character
		if IsValidCharacter(character) then
			local state = getInitialState(player)
			setupCharacter(player)
			Network.fireClient(CombatEvents.REPLICATE_ACTIVE, player, true)
			Network.fireClient(CombatEvents.REPLICATE_HEALTH, player, state.health.currentHealth)
			playerStates[userId] = state
		end
	end
end

return PlayerStateManager
