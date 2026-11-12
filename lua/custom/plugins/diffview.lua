-- Configure Diffview navigation and collapse the file tree on first load.
-- Limit LSP work in diff buffers to keep staging responsive.

return {
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
      file_panel = {
        win_config = {
          width = 50,
        },
      },
      hooks = {
        view_opened = function(view)
          if view.panel.listing_style ~= 'tree' then return end

          -- File entries load asynchronously after the view opens.
          view.emitter:once('files_updated', function()
            if view.panel:is_open() then vim.api.nvim_win_call(view.panel.winid, require('diffview.actions').close_all_folds) end
          end)
        end,
      },
    }
    -- Prevent LSP from doing work on diffview buffers (causes slow staging)
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        if vim.api.nvim_buf_get_name(args.buf):match '^diffview://' then pcall(vim.lsp.buf_detach_client, args.buf, args.data.client_id) end
      end,
    })
    -- Guard against nil buf_state when diffview triggers LSP on untracked buffers
    local ct = require 'vim.lsp._changetracking'
    local _orig_reset_buf = ct.reset_buf
    ct.reset_buf = function(client, bufnr) pcall(_orig_reset_buf, client, bufnr) end
    local _orig_get_and_set_name = ct._get_and_set_name
    ct._get_and_set_name = function(client, bufnr, name)
      local ok, result = pcall(_orig_get_and_set_name, client, bufnr, name)
      if ok then return result end

      return name
    end
  end,
}
