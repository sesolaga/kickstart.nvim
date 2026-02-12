-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    {
      'antosha417/nvim-lsp-file-operations',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = true,
    },
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    event_handlers = {
      {
        event = 'file_renamed',
        handler = function() vim.defer_fn(function() vim.cmd('wa') end, 200) end,
      },
      {
        event = 'file_moved',
        handler = function() vim.defer_fn(function() vim.cmd('wa') end, 200) end,
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
