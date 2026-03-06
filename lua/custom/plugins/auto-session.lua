return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    suppressed_dirs = { '~/', '~/Downloads', '/tmp' },
  },
  keys = {
    { '<leader>sp', '<cmd>AutoSession search<cr>', desc = '[S]earch [P]rojects (sessions)' },
  },
}
