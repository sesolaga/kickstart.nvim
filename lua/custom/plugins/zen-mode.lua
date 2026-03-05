return {
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
}
