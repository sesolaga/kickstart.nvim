return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {}

    vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)

    vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end)
    vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end)
    vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end)
    vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end)

    vim.keymap.set('n', '<S-h>', function() harpoon:list():prev() end, { desc = 'Harpoon prev' })
    vim.keymap.set('n', '<S-l>', function() harpoon:list():next() end, { desc = 'Harpoon next' })
    vim.keymap.set('n', '<leader>r', function() harpoon:list():remove() end, { desc = 'Harpoon [R]emove current' })
  end,
}
