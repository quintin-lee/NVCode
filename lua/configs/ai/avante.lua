local endpoint = tostring(os.getenv("AVANTE_API_ENDPOINT"))
local model    = tostring(os.getenv("AVANTE_MODEL_NAME"))
local api_key  = tostring(os.getenv("AVANTE_API_KEY"))

require('avante').setup({
  provider = "ollama",
  mappings = {
      ask = "na", -- ask
      edit = "ne", -- edit
      refresh = "nr", -- refresh
  },
  vendors = {
    ---@type AvanteProvider
    ollama = {
      ["local"] = true,
      endpoint = endpoint,
      model = model,
      parse_curl_args = function(opts, code_opts)
        return {
          url = opts.endpoint .. "/chat/completions",
          headers = {
            ["Accept"] = "application/json",
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. api_key,
          },
          body = {
            model = opts.model,
            messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
            max_tokens = 4096,
            stream = true,
          },
        }
      end,
      parse_response_data = function(data_stream, event_state, opts)
        require("avante.providers").openai.parse_response(data_stream, event_state, opts)
      end,
    },
  }
})

