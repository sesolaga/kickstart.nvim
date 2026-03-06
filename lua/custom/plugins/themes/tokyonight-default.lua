return {
  spec = {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {},
  },
  colorscheme = 'tokyonight',
  highlights = function() end,
  cursor = function()
    vim.api.nvim_set_hl(0, 'Cursor', { fg = '#ffffff', bg = '#7aa2f7' })
    vim.opt.guicursor =
      'n-v-c-sm:block-Cursor-blinkon250-blinkoff250-blinkwait250,i-ci-ve:ver25-Cursor-blinkon250-blinkoff250-blinkwait250,r-cr-o:hor20-Cursor-blinkon250-blinkoff250-blinkwait250'
  end,
}
