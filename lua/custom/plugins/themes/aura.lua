return {
  spec = {
    'baliestri/aura-theme',
    priority = 1000,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. '/packages/neovim')
    end,
  },
  colorscheme = 'aura-soft-dark',
  highlights = function()
    -- Pinkish keywords and properties (Aura Dracula Spirit style)
    local pink = '#f694ff'
    vim.api.nvim_set_hl(0, 'Normal', { bg = '#262335' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1e1a2e' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = pink, bg = '#1e1a2e' })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#2e2b40' })

    vim.api.nvim_set_hl(0, '@keyword.import', { fg = pink })
    vim.api.nvim_set_hl(0, '@keyword.export', { fg = pink })
    vim.api.nvim_set_hl(0, '@property', { fg = pink })
    vim.api.nvim_set_hl(0, '@lsp.type.property', { fg = pink })
    vim.api.nvim_set_hl(0, '@variable.member', { fg = pink })

    -- Italic types (Aura Dracula Spirit style)
    vim.api.nvim_set_hl(0, '@type', { fg = '#82e2ff', italic = true })
    vim.api.nvim_set_hl(0, '@type.definition', { fg = '#82e2ff', italic = true })
    vim.api.nvim_set_hl(0, '@lsp.type.type', { fg = '#82e2ff', italic = true })
    vim.api.nvim_set_hl(0, '@lsp.type.interface', { fg = '#82e2ff', italic = true })
    vim.api.nvim_set_hl(0, '@lsp.type.class', { fg = '#82e2ff', italic = true })
    vim.api.nvim_set_hl(0, '@lsp.type.enum', { fg = '#82e2ff', italic = true })

    vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { bg = '#2e2b40' })
    vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = '#4d4578', bg = '#2e2b40' })

    vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#3d375e' })
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#3d375e' })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#3d375e' })

    vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#1a3a2a' })
    vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#1a2a3a' })
    vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#3a1a2a' })
    vim.api.nvim_set_hl(0, 'DiffText', { bg = '#2a3a4a' })

    vim.api.nvim_set_hl(0, 'Search', { bg = '#3d375e', fg = 'NONE' })
    vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#3d375e', fg = 'NONE' })
    vim.api.nvim_set_hl(0, 'CurSearch', { bg = '#4d4578', fg = 'NONE' })
  end,
  cursor = function()
    vim.api.nvim_set_hl(0, 'Cursor', { fg = '#ffffff', bg = '#a97cfb' })
    vim.opt.guicursor =
      'n-v-c-sm:block-Cursor-blinkon250-blinkoff250-blinkwait250,i-ci-ve:ver25-Cursor-blinkon250-blinkoff250-blinkwait250,r-cr-o:hor20-Cursor-blinkon250-blinkoff250-blinkwait250'
  end,
}
