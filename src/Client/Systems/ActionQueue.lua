local import = require(game.ReplicatedStorage.Lib.Import)

local RunService = game:GetService("RunService")

local Input = import "Client/Systems/Input"
local StepOrder = import "Data/StepOrder"
local Actions = import "Shared/Actions"
local ActionIds = import "Data/ActionIds"
local ActionQueue =  {}

local Network = import "Network"
local CombatEvents = import "Data/NetworkEvents/CombatEvents"

local _queue = {}

function ActionQueue.queueAction(actionId, initialState)
	_queue[#_queue+1] = {
		actionId = actionId,
		initialState = initialState
	}
end

function ActionQueue.step()
	for _, queuedAction in ipairs(_queue) do
		local actionId = queuedAction.actionId
		local initialState = queuedAction.initialState
		local action = Actions[actionId]
		assert(action, "No action found for actionId "..actionId)

		if action.validate(initialState) then
			action.init(initialState)
		end
	end

	_queue = {}
end

function ActionQueue.start()
	Input.bindActionInput("Attack", Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
	Input.bindActionInput("FallDown", Enum.KeyCode.F)

	Network.hookEvent(CombatEvents.REPLICATE_ACTION, function(actionId, initialState)
		local action = Actions[actionId]
		assert(action, "No action found for actionId "..actionId)

		if action.validate(initialState) then
			action.init(initialState)
		end
	end)

	RunService:BindToRenderStep("ActionQueue", StepOrder.ACTION_QUEUE, function()

		local _, attackInputState = Input.readBoundAction("Attack")
		if attackInputState == Enum.UserInputState.Begin then
			ActionQueue.queueAction(ActionIds.ATTACK)
		end

		local _, falldownInputState = Input.readBoundAction("FallDown")
		if falldownInputState == Enum.UserInputState.Begin then
			ActionQueue.queueAction(ActionIds.FALLDOWN, {
				velocity = (workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)) * 30
			})
		end

		ActionQueue.step()
	end)
end

return ActionQueue
