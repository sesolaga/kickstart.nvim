-- Theme system: each theme file returns { spec, colorscheme, highlights, cursor }
-- Add new themes by creating a file in this directory.

local themes = {
  require 'custom.plugins.themes.aura',
  require 'custom.plugins.themes.tokyonight',
}

-- Collect all plugin specs so lazy.nvim installs them
local specs = {}
for _, theme in ipairs(themes) do
  table.insert(specs, theme.spec)
end

-- Active theme index (persisted in vim.g for runtime access)
vim.g.theme_index = vim.g.theme_index or 1

-- Apply the active theme's colorscheme + highlights + cursor
local function apply_theme(index)
  local theme = themes[index]
  if not theme then return end
  vim.g.theme_index = index
  vim.cmd.colorscheme(theme.colorscheme)
  if theme.highlights then theme.highlights() end
  if theme.cursor then theme.cursor() end
  vim.notify('Theme: ' .. theme.colorscheme, vim.log.levels.INFO)
end

-- Apply on startup (after all plugins load)
vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyDone',
  once = true,
  callback = function() apply_theme(vim.g.theme_index) end,
})

-- Cycle themes with <leader>ct
table.insert(specs, {
  -- Virtual spec for the keymap (no actual plugin)
  dir = vim.fn.stdpath 'config',
  name = 'theme-switcher',
  virtual = true,
  lazy = false,
  keys = {
    {
      '<leader>ct',
      function()
        local next_index = (vim.g.theme_index % #themes) + 1
        apply_theme(next_index)
      end,
      desc = '[C]ycle [T]heme',
    },
  },
})

return specs
