return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    suppressed_dirs = { '~/Downloads', '/tmp' },
    auto_save = true,
    pre_save_cmds = { 'silent! wa' },
    -- Show session picker when opening nvim in home dir with no args
    no_restore_cmds = {
      function()
        if vim.fn.getcwd() == vim.fn.expand '~' and vim.fn.argc() == 0 then
          vim.schedule(function()
            vim.cmd 'AutoSession search'
          end)
        end
      end,
    },
  },
  keys = {
    { '<leader>sp', '<cmd>AutoSession search<cr>', desc = '[S]earch [P]rojects (sessions)' },
  },
}
