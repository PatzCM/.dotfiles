-- Alpha (dashboard) for neovim

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
    width          = 33,
    align_shortcut = "right",
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
  type = "text",
	-- Change 'rdn' to any program that gives you a random quote.
	-- math.random(1, #Headers) to get a random header.
  -- val = Headers[math.random(#Headers)],
  -- val = Headers[3],
	val = get_header(1),
  opts = {
    position = "center",
    hl       = "Character",
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
    " ",
    "⛧☾༺   " .. os.date("%H:%M") .. "   " .. os.date("%a, %d %b %y") .. " ༻☽⛧ ",
    " -ˋˏ✄┈┈┈󰏗 " .. require("lazy").stats().count .. " plugins loaded 󰏗 ┈┈┈",
    "  █▓▒▒░░░𝕘𝕚𝕧𝕖 𝕞𝕖 𝕪𝕠𝕦𝕣 𝕡𝕦𝕤𝕤𝕪░░░▒▒▓█ ",
    "          𝕻𝖆𝖙𝖟 𝖜𝖆𝖘 𝖍𝖊𝖗𝖊  ",
    " ",
  },
  opts = {
    position = "center",
    hl = "Todo", -- Purple highlight group
  }
}

---@diagnostic disable: missing-parameter
local buttons = {
  type = "group",
  val = {
    button("n", "  New file", 'Macro', ':ene <BAR> startinsert <CR>'),
    button("f", "  Find file", 'Macro', ':Telescope find_files <CR>'),
    button("F", "  Find text", 'Macro', ':Telescope live_grep <CR>'),
    button("-", "󰼙  Get Oil", 'Macro', ':Oil --float<CR>'),
    button("r", "󱣱  Get Ranger", 'Macro', ':Ranger<CR>'),
    button("l", "  Get Lazy", 'Macro', ':Lazy<CR>'),
    button("m", "  Get Mason", 'Macro', ':Mason<CR>'),
    button("h", "󰞋  Get Help", 'Macro', ':vertical help<CR>'),
    button("o", "  Get Options", 'Macro', ':vertical options<CR>'),
    button("q", "󰩈  Quit", 'Macro', ':qa<CR>'),
  },
  opts = {
    spacing = 1,
  }
}
---@diagnostic enable: missing-parameter

--
-- Centering handler of ALPHA
--

local ol = {                              -- occupied lines
  icon            = #header.val,          -- CONST: number of lines that your header will occupy
  message         = #footer.val,          -- CONST: because of padding at the bottom
  length_buttons  = #buttons.val * 2 - 1, -- CONST: it calculate the number that buttons will occupy
  neovim_lines    = 2,                    -- CONST: 2 of command line, 1 of the top bar
  padding_between = 5,                    -- STATIC: can be set to anything, padding between keybinds and header
}

local left_terminal_value = vim.api.nvim_get_option('lines') -
    (ol.length_buttons + ol.message + ol.padding_between + ol.icon + ol.neovim_lines)

-- Not screen enough to run the command.
if (left_terminal_value >= 0) then
  local top_padding    = math.floor(left_terminal_value / 2)
  local bottom_padding = left_terminal_value - top_padding

  --
  -- Set alpha sections
  --

  options              = {
    layout = {
      { type = "padding", val = top_padding },
      header,
      { type = "padding", val = ol.padding_between },
      buttons,
      footer,
      { type = "padding", val = bottom_padding },
    },
    opts = {
      margin = 5
    },
  }
end

return {
  "goolord/alpha-nvim",
	priority = 1000,
  dependencies = 'kyazdani42/nvim-web-devicons',
  config = function()
    if (options ~= nil) then
      require("alpha").setup(options)
    end
    vim.keymap.set('n', '<leader>a', ':Alpha<CR>', { silent = true, desc = "Open Alpha dashboard" })
  end
}
