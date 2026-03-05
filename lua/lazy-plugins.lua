-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
require('lazy').setup({
  { -- Colorscheme
    'baliestri/aura-theme',
    priority = 1000,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. '/packages/neovim')
      vim.cmd [[colorscheme aura-soft-dark]]

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

      -- Cursor: purple color + blink
      vim.api.nvim_set_hl(0, 'Cursor', { fg = '#ffffff', bg = '#a97cfb' })
      vim.opt.guicursor =
        'n-v-c-sm:block-Cursor-blinkon250-blinkoff250-blinkwait250,i-ci-ve:ver25-Cursor-blinkon250-blinkoff250-blinkwait250,r-cr-o:hor20-Cursor-blinkon250-blinkoff250-blinkwait250'
    end,
  },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup()

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    config = function()
      local filetypes = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'typescript', 'tsx', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function(args)
          -- Skip scratch/float buffers (handled by LSP's open_floating_preview)
          if vim.bo[args.buf].buftype == '' then vim.treesitter.start(args.buf) end
        end,
      })
    end,
  },

  -- Kickstart plugin modules
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns',

  -- Custom plugins (lua/custom/plugins/*.lua)
  { import = 'custom.plugins' }
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
