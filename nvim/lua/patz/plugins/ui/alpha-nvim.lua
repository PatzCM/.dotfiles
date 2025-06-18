-- Alpha (dashboard) for neovim
return {
  "goolord/alpha-nvim",
	priority = 1000,
	event = "VimEnter",
  dependencies = 'kyazdani42/nvim-web-devicons',
  config = function()
      vim.keymap.set('n', '<leader>a', ':Alpha<CR>', { silent = true, desc = "Open Alpha dashboard" })
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")

local options

-- For random header
math.randomseed(os.time())
-- Create button for initial keybind.
--- @param sc string
--- @param txt string
--- @param hl string
--- @param keybind string optional
--- @param keybind_opts table optional
local function button(sc, txt, hl, keybind, keybind_opts)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

  local opts = {
    position       = "center",
    shortcut       = sc,
    cursor         = 5,
    width          = 20,
    align_shortcut = "right",
		-- alight_shortcut = "left",
		-- align_shortcut = "center",
    hl_shortcut    = hl,
  }

  if keybind then
    keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
    opts.keymap = { "n", sc_, keybind, keybind_opts }
  end

  local function on_press()
    local key = vim.api.nvim_replace_termcodes(sc_ .. '<Ignore>', true, false, true)
    vim.api.nvim_feedkeys(key, "normal", false)
  end

  return {
    type     = "button",
    val      = txt,
    on_press = on_press,
    opts     = opts,
  }
end

--
-- Sections for Alpha.
--
local get_header = require("patz.plugins.ui.ascii.startpage-headers")

local header = {
	-- how to use db.header_pad 
	-- db.header_pad = 0
	--
  type = "text",
	-- types available: "text", "button", "group", "padding"
	-- differences between them:
	-- text: just text
	-- button: text with keybind
	-- group: group of buttons
	-- padding: empty space
	--
	-- Change 'rdn' to any program that gives you a random quote.
	-- math.random(1, #Headers) to get a random header.
  -- val = Headers[math.random(#Headers)],
  -- val = Headers[3],
	val = get_header(1),
  opts = {
    position = "center",
    -- hl       = "BufferInactiveTarget",
		-- hl = "Todo", -- Purple highlight group
		-- hl = "MiniStatuslineModeNormal",
		-- center = true,
	}
}

-- Get Neovim version
local get_neovim_version = function()
  local v = vim.version()
  return "v" .. v.major .. "." .. v.minor .. "." .. v.patch
end

local footer = {
  type = "text",
  -- Change 'rdn' to any program that gives you a random quote.
  -- https://github.com/BeyondMagic/scripts/blob/master/quotes/rdn
  -- Which returns one to three lines, being each divided by a line break.
  -- Or just an array: { "I see you:", "Above you." }
  
-- Create a section for date, time and plugins, with symbols
	-- "" for date and time
	-- "漣" for plugins
  val = {
    " ⛧☾༺         𝕻𝖆𝖙𝖟 𝖜𝖆𝖘 𝖍𝖊𝖗𝖊       ༻☽⛧ ",
    " ",
    "   -> " .. os.date("%H:%M") .. " ===   -> " .. os.date("%a, %d %b %y"),
    -- " -ˋˏ✄┈┈┈󰏗 " .. require("lazy").stats().count .. " plugins loaded 󰏗 ┈┈┈",
    " ██▓▒▒░░░ 𝕘𝕚𝕧𝕖 𝕞𝕖 𝕪𝕠𝕦𝕣 𝕡𝕦𝕤𝕤𝕪 ░░░▒▒▓██",
    " ",
  },
  opts = {
    position = "center",
    hl = "Todo", -- Purple highlight group
		-- hl = "MiniStatuslineModeNormal",
   -- open hightlight predefined schemes: :highlight
		}
}

---@diagnostic disable: missing-parameter
local buttons = {
  type = "group",
  val = {
    button("n", "  New file", 'MiniStatuslineModeNormal', ':ene <BAR> startinsert <CR>'),
    button("f", "  Find file", 'MiniStatuslineModeNormal', ':Telescope find_files <CR>'),
    button("F", "  Find text", 'MiniStatuslineModeNormal', ':Telescope live_grep <CR>'),
    button("-", "󰼙  Get Oil", 'MiniStatuslineModeNormal', ':Oil --float<CR>'),
    -- button("r", "󱣱  Get Ranger", 'MiniStatuslineModeNormal', ':Ranger<CR>'),
    button("l", "  Get Lazy", 'MiniStatuslineModeNormal', ':Lazy<CR>'),
    button("m", "  Get Mason", 'MiniStatuslineModeNormal', ':Mason<CR>'),
    button("h", "󰞋  Get Help", 'MiniStatuslineModeNormal', ':vertical help<CR>'),
    button("o", "  Get Options", 'MiniStatuslineModeNormal', ':vertical options<CR>'),
    button("q", "󰩈  Quit", 'MiniStatuslineModeNormal', ':qa<CR>'),
  },
	opts = {
    spacing = 1,
		-- how to set number to float? -> :lua print(vim.api.nvim_get_option('lines'))
		position = "center",
		hl       = "Macro",
  }
}
---@diagnostic enable: missing-parameter


		local greeting = function()
			-- Determine the appropriate greeting based on the hour
			local mesg
			local username = os.getenv("USERNAME")
			if datetime >= 0 and datetime < 6 then
				mesg = "Dreaming..󰒲 󰒲 "
			elseif datetime >= 6 and datetime < 12 then
				mesg = "🌅 Hi " .. username .. ", Good Morning ☀️"
			elseif datetime >= 12 and datetime < 18 then
				mesg = "🌞 Hi " .. username .. ", Good Afternoon ☕️"
			elseif datetime >= 18 and datetime < 21 then
				mesg = "🌆 Hi " .. username .. ", Good Evening 🌙"
			else
				mesg = "Hi " .. username .. ", it's getting late, get some sleep 😴"
			end
			return mesg
		end

local bottom_section = {
			type = "text",
			val = greeting,
			opts = {
				position = "center",
			},
		}

--
-- Centering handler of ALPHA
--

local ol = {                              -- occupied lines
  icon            = #header.val,          -- CONST: number of lines that your header will occupy
  message         = #footer.val,          -- CONST: because of padding at the bottom
  length_buttons  = #buttons.val * 2 - 1, -- CONST: it calculate the number that buttons will occupy
  neovim_lines    = 2,                    -- CONST: 2 of command line, 1 of the top bar
  padding_between = 2,                    -- STATIC: can be set to anything, padding between keybinds and header
}

local left_terminal_value = vim.api.nvim_get_option('lines') -
    (ol.length_buttons + ol.message + ol.padding_between + ol.icon + ol.neovim_lines)

-- Not screen enough to run the command.
if (left_terminal_value >= 0) then
  -- local top_padding    = math.floor(left_terminal_value / 2) 
	-- bigger option:
	local top_padding = math.floor(left_terminal_value / 5)
	local bottom_padding = left_terminal_value - top_padding
 -- center the header and footer 
  --
  -- Set alpha sections
  --
			--
  options              = {
    layout = {
      -- { type = "padding", val = top_padding },
			{type = "padding", val = 1},
      header,
      { type = "padding", val = ol.padding_between },
      buttons,
      footer,
      { type = "padding", val = bottom_padding },
		},
    opts = {
      -- margin = 0,
    },
  }
end

	-- Set alpha dashboard
	dashboard.section.header = header
	dashboard.section.buttons = buttons
	dashboard.section.footer = footer
	dashboard.section.bottom_section = bottom_section

	-- Set alpha greeting
	dashboard.section.greeting = {
		type = "text",
		val = greeting,
		opts = {
			position = "center",
			hl = "AlphaHeader", -- Highlight group for greeting
		},
	}
	-- Set alpha options
	dashboard.opts = options

	-- Set alpha theme
	alpha.setup(dashboard.opts)
	-- Set alpha theme options
		-- dashboard.opts.layout[1].val = 1 -- Set top padding to 1 line
		-- dashboard.opts.layout[2].val = 1 -- Set bottom padding to 1 line
		-- dashboard.opts.layout[3].val = 1 -- Set padding between header and buttons to 1 line
		-- 

	-- Set highlight groups
	vim.cmd [[highlight AlphaHeader guifg=#ff9e64 gui=bold]]
	vim.cmd [[highlight AlphaFooter guifg=#7f8c8d gui=italic]]
	vim.cmd [[highlight AlphaButtons guifg=#f1c40f gui=bold]]
	end,
}
