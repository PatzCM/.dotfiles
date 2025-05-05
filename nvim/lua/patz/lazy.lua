local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { import = 'patz.plugins' },
    { import = 'patz.plugins.ui' },
    { import = 'patz.plugins.ai' },
    { import = 'patz.plugins.edit' },
    { import = 'patz.plugins.git' },
    { import = 'patz.plugins.lsp' },
    { import = 'patz.plugins.nav' },
{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }
  },
  -- install = { colorscheme = { "dracula" } },
	{colorscheme = { "catppuccin macchiato" }},
  {
    checker = {
      enabled = true,
      notify = false,
    },
    -- Initialize lazy with dynamic loading of anything in the plugins directory
    change_detection = {
      enabled = true, -- automatically check for config file changes and reload the ui
      notify = false, -- turn off notifications whenever plugin changes are made
    },
  }
)
