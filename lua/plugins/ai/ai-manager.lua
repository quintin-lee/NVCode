-- AI Tool Manager - Allows selecting one primary AI tool to avoid conflicts
local M = {}

-- Function to select which AI tool to load
function M.setup()
	-- You can set the AI_PROVIDER environment variable to choose the active AI tool
	local ai_provider = os.getenv("AI_PROVIDER") or "none" -- Options: avante, copilot, tabnine, none

	if ai_provider == "avante" then
		return { require("plugins.ai.avante") }
	elseif ai_provider == "copilot" then
		return { require("plugins.ai.copilot") }
	elseif ai_provider == "tabnine" then
		return { require("plugins.coding.tabnine") }
	elseif ai_provider == "all" then
		-- Only recommended for powerful machines, as it may cause performance issues
		return {
			require("plugins.ai.avante"),
			require("plugins.ai.copilot"),
			require("plugins.ai.mcphub"),
			require("plugins.ai.codecompanion"),
		}
	else
		-- Default: only load CodeCompanion
		return { require("plugins.ai.codecompanion") }
	end
end

return M

