-- local import = require(game.ReplicatedStorage.Lib.Import)

local Commands = {}

function Commands.start()
	local Cmdr = require(game.ReplicatedStorage:WaitForChild("CmdrClient"))
	-- Configurable, and you can choose multiple keys
	Cmdr:SetActivationKeys({Enum.KeyCode.Equals})
end

return Commands
