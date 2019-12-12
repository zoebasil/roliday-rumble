local import = require(game.ReplicatedStorage.Lib.Import)

local IsValidCharacter = import "GameUtils/IsValidCharacter"
local Players = game:GetService("Players")

local PlayerStateManager = {}
local playerStates = {}

local function getInitialState(player)
	return {
		characterModel = player.Character,
		health = {
			currentHealth = 100,
			lastDamagedTime = 0,
			lastRegenedTime = 0,
		},
		knockDown = {
			isKnockedDown = false,
			lastKnockedDownTime = 0,
			isRagdoll = false,
		},
		carrying = {
			isBeingCarried = false,
			lastCarriedTime = 0,
			canBeCarried = false,
			networkOwner = player,
			carryingModel = nil,
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
			playerStates[userId] = getInitialState(player)
		end
	end
end

return PlayerStateManager
