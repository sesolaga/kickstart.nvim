-- lua/custom/bigfile.lua
local M = {}

local MAX_SIZE = 1024 * 300

function M.setup()
  vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(args)
      local buf = args.buf
      local file = vim.api.nvim_buf_get_name(buf)
      local stat = vim.loop.fs_stat(file)
      if not stat or stat.size < MAX_SIZE then return end

      vim.b.large_file = true

      for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
        client:stop()
      end

      pcall(vim.treesitter.stop, buf)
      vim.diagnostic.disable(buf)

      vim.bo[buf].syntax = "off"
      vim.bo[buf].filetype = "text"
      vim.b[buf].indent_blankline_enabled = false

      vim.schedule(function()
        vim.notify("Large file detected — disabled LSP, Treesitter, and diagnostics", vim.log.levels.WARN)
      end)
    end,
  })

  local ok, telescope = pcall(require, "telescope")
  if ok then
    local previewers = require("telescope.previewers")
    local builtin_maker = previewers.buffer_previewer_maker

    telescope.setup {
      defaults = {
        buffer_previewer_maker = function(filepath, bufnr, opts)
          local stat = vim.loop.fs_stat(filepath)
          if stat and stat.size > MAX_SIZE then return end
          builtin_maker(filepath, bufnr, opts)
        end,
      },
    }
  end
end

return M
