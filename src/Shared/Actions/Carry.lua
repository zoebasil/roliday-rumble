local import = require(game.ReplicatedStorage.Lib.Import)

local Workspace = game:GetService("Workspace")

local Animations = import "Client/Systems/Animations"
local AnimationNames = import "Data/AnimationNames"

local ActionIds = import "Data/ActionIds"
local ActionState = import "Client/Systems/ActionState"
local Drop = import "Shared/Actions/Drop"

local Carry = {}
Carry.movementPriority = 1
Carry.actionId = ActionIds.CARRY

function Carry.validate()
	return true
end

function Carry.init(initialState)
	Animations.playAnimation(AnimationNames.CARRYING, function(anim)
		if not anim.isPlaying then
			return true
		end

		if not ActionState.hasAction(Carry.actionId) then
			anim:Stop()
			return true
		end

		return false
	end)

	ActionState.setActionState(Carry.actionId, {
		weldConstraint = initialState.weld
	})
end

function Carry.step(state)
	local weldConstraint = state.weldConstraint
	local isKnockedDown = ActionState.hasAction(ActionIds.FALLDOWN) or ActionState.hasAction(ActionIds.KNOCKOUT)
	if isKnockedDown then
		Drop.init()
		return
	end

	if not weldConstraint:IsDescendantOf(Workspace) then
		ActionState.setActionState(Carry.actionId, nil)
	end

	if weldConstraint.Part1 == nil or not weldConstraint.Part1:IsDescendantOf(Workspace) then
		ActionState.setActionState(Carry.actionId, nil)
	end
end

function Carry.changeSpeed(baseSpeed)
	return baseSpeed * 0.8
end


return Carry
