# Modular Neovim Config

Based on [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim).

## Structure

```
init.lua                          Entry point: leader keys + 4 requires
lua/
  options.lua                     Vim settings, diagnostics, folding
  keymaps.lua                     Global keymaps + autocmds
  lazy-bootstrap.lua              lazy.nvim installer
  lazy-plugins.lua                Kickstart modules + { import = 'custom.plugins' }
  kickstart/plugins/              Upstream kickstart modules (autopairs, gitsigns, lint, neo-tree)
  custom/plugins/                 One file per plugin
  custom/plugins/themes/          Theme system
    init.lua                      Switcher logic + <leader>ct keymap
    aura.lua                      Aura theme + highlight overrides
    tokyonight.lua                Tokyonight theme (placeholder)
after/ftplugin/
  rust.lua                        Rust indent settings
```

## Adding a plugin

Create `lua/custom/plugins/my-plugin.lua` returning a lazy.nvim spec:

```lua
return {
  'author/my-plugin.nvim',
  opts = {},
}
```

It's auto-imported via `{ import = 'custom.plugins' }` in `lazy-plugins.lua`.

## Adding a theme

1. Create `lua/custom/plugins/themes/mytheme.lua`:

```lua
return {
  spec = { 'author/mytheme.nvim', priority = 1000 },
  colorscheme = 'mytheme',
  highlights = function()
    -- custom highlight overrides
  end,
  cursor = function()
    vim.api.nvim_set_hl(0, 'Cursor', { fg = '#ffffff', bg = '#7aa2f7' })
    vim.opt.guicursor = '...'
  end,
}
```

2. Add `require 'custom.plugins.themes.mytheme'` to the `themes` table in `themes/init.lua`.

3. Press `<leader>ct` to cycle through themes at runtime.

## Key files

| File | Purpose |
|------|---------|
| `options.lua` | `vim.o.*` settings, diagnostic config, LSP rename handler |
| `keymaps.lua` | `<Esc>` clear search, `<leader>q` quickfix, `<leader>bd/bo` buffer ops, `<C-h>` window nav, yank highlight |
| `lspconfig.lua` | LSP servers, mason, float borders, hover/signature keymaps |
| `telescope.lua` | Fuzzy finder + LSP picker keymaps (`grr`, `gri`, `grd`, etc.) |
| `harpoon.lua` | File marks: `<C-j/k/l/f>` select, `<C-e>` menu, `<leader>a` add |
| `themes/init.lua` | Theme switcher: `<leader>ct` cycles themes |
