-- AI plugin selection based on AI_PROVIDER environment variable
local ai_manager = require("plugins.ai.ai-manager")
return ai_manager.setup()
