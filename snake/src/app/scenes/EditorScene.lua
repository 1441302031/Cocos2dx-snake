require "app.model.Command"
local Fence = require"app.model.Fence"
require"app.model.collideManager"

local EditorScene = class("EditorScene", function()
	return display.newScene("EditorScene")
	end)

function EditorScene:onEnter()
	self.fence = Fence.new(CBOUND, self)
end

return EditorScene
