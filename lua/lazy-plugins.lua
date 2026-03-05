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
  -- Harpoon
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup {}

      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)

      vim.keymap.set('n', '<C-j>', function() harpoon:list():select(1) end)
      vim.keymap.set('n', '<C-k>', function() harpoon:list():select(2) end)
      vim.keymap.set('n', '<C-l>', function() harpoon:list():select(3) end)
      vim.keymap.set('n', '<C-f>', function() harpoon:list():select(4) end)

      vim.keymap.set('n', '<S-h>', function() harpoon:list():prev() end, { desc = 'Harpoon prev' })
      vim.keymap.set('n', '<S-l>', function() harpoon:list():next() end, { desc = 'Harpoon next' })
      vim.keymap.set('n', '<leader>r', function() harpoon:list():remove() end, { desc = 'Harpoon [R]emove current' })
    end,
  },
  -- Side-by-side diff
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      {
        '<leader>gg',
        function()
          local lib = require 'diffview.lib'
          if lib.get_current_view() then
            vim.cmd 'DiffviewClose'
          else
            vim.cmd 'DiffviewOpen'
          end
        end,
        desc = 'Toggle Diffview',
      },
      { '<leader>gs', function() require('diffview.actions').toggle_stage_entry() end, desc = '[G]it [S]tage toggle' },
      { '<leader>gc', '<cmd>term git commit<CR>', desc = '[G]it [C]ommit' },
      {
        '<leader>gh',
        function()
          local lib = require 'diffview.lib'
          if lib.get_current_view() then
            vim.cmd 'DiffviewClose'
          else
            vim.cmd 'DiffviewFileHistory'
          end
        end,
        desc = 'File history',
      },
    },
    config = function()
      require('diffview').setup {
        -- optional config
        use_icons = true,
        enhanced_diff_hl = true,
      }
      -- Prevent LSP from doing work on diffview buffers (causes slow staging)
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          if vim.api.nvim_buf_get_name(args.buf):match '^diffview://' then pcall(vim.lsp.buf_detach_client, args.buf, args.data.client_id) end
        end,
      })
      -- Guard against nil buf_state when diffview cleans up buffers
      local ct = require 'vim.lsp._changetracking'
      local _orig_reset_buf = ct.reset_buf
      ct.reset_buf = function(client, bufnr) pcall(_orig_reset_buf, client, bufnr) end
    end,
  },

  -- Zen mode
  {
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup {
        window = {
          width = 120,
          options = {
            signcolumn = 'no', -- Disable sign column
            number = false, -- Disable line numbers
            relativenumber = false, -- Disable relative numbers
          },
        },
      }
    end,
    keys = {
      {
        '<leader>z',
        function() require('zen-mode').toggle() end,
        mode = 'n',
        desc = 'Toggle Zen Mode',
      },
    },
  },
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    enabled = true,
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<c-enter>'] = 'to_fuzzy_refine',
              ['<C-j>'] = require('telescope.actions').cycle_history_next,
              ['<C-k>'] = require('telescope.actions').cycle_history_prev,
            },
          },
        },
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf

          -- Find references for the word under your cursor.
          vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

          -- Jump to the implementation of the word under your cursor.
          vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

          -- Jump to the definition of the word under your cursor.
          vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

          -- Fuzzy find all the symbols in your current document.
          vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

          -- Fuzzy find all the symbols in your current workspace.
          vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

          -- Jump to the type of the word under your cursor.
          vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })

      -- Override default behavior and theme when searching
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        { desc = '[S]earch [/] in Open Files' }
      )

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- LSP hover/signature: pink border + padding
      local pink_border = {
        { '╭', 'FloatBorder' },
        { '─', 'FloatBorder' },
        { '╮', 'FloatBorder' },
        { '│', 'FloatBorder' },
        { '╯', 'FloatBorder' },
        { '─', 'FloatBorder' },
        { '╰', 'FloatBorder' },
        { '│', 'FloatBorder' },
      }

      -- Add vertical padding to LSP float previews (preserve code fences at start/end)
      local orig_open_floating_preview = vim.lsp.util.open_floating_preview
      vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
        local padded = {}
        for i, line in ipairs(contents) do
          if i == 1 and not line:match '^```' then table.insert(padded, '') end
          table.insert(padded, line)
        end
        if #contents > 0 and not contents[#contents]:match '^```' then table.insert(padded, '') end
        return orig_open_floating_preview(padded, syntax, opts, ...)
      end

      vim.keymap.set('n', 'K', function() vim.lsp.buf.hover { border = pink_border, max_width = 120 } end, { desc = 'LSP Hover' })
      vim.keymap.set({ 'n', 'i' }, '<C-k>', function() vim.lsp.buf.signature_help { border = pink_border, max_width = 120 } end, { desc = 'LSP Signature Help' })

      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      local servers = {
        ts_ls = {},
        rust_analyzer = {},
        hls = {},
      }

      -- Ensure the servers and tools above are installed
      local ensure_installed = {
        'lua-language-server',
        'stylua',
        'haskell-language-server',
        'rust-analyzer',
        'typescript-language-server',
      }

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end

      -- Special Lua Config, as recommended by neovim help docs
      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
              checkThirdParty = false,
              -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
              --  See https://github.com/neovim/nvim-lspconfig/issues/3189
              library = vim.api.nvim_get_runtime_file('', true),
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })
      vim.lsp.enable 'lua_ls'
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true, haskell = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
        menu = { direction_priority = { 's', 'n' } },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },

      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = {
        enabled = true,
        window = {
          direction_priority = { 'n', 's' },
          border = 'rounded',
        },
      },
    },
  },

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
